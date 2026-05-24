import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bett_box/clash/interface.dart';
import 'package:bett_box/common/common.dart';
import 'package:bett_box/models/core.dart';
import 'package:bett_box/state.dart';

class ClashService extends ClashHandlerInterface {
  static ClashService? _instance;

  Completer<ServerSocket> serverCompleter = Completer();

  Completer<Socket> socketCompleter = Completer();

  bool isStarting = false;
  bool _isDestroying = false;

  Process? process;

  factory ClashService() {
    _instance ??= ClashService._internal();
    return _instance!;
  }

  ClashService._internal() {
    _initServer();
    reStart();
  }

  Future<void> _initServer() async {
    runZonedGuarded(
      () async {
        final address = !system.isWindows
            ? InternetAddress(unixSocketPath, type: InternetAddressType.unix)
            : InternetAddress(localhost, type: InternetAddressType.IPv4);
        await _deleteSocketFile();
        final server = await ServerSocket.bind(address, 0, shared: true);
        serverCompleter.complete(server);
        await for (final socket in server) {
          await _destroySocket();
          socketCompleter.complete(socket);
          socket
              .transform(uint8ListToListIntConverter)
              .transform(utf8.decoder)
              .transform(LineSplitter())
              .listen((data) {
                handleResult(ActionResult.fromJson(json.decode(data.trim())));
              });
        }
      },
      (error, stack) {
        commonPrint.log(error.toString());
        if (error is SocketException &&
            !_isDestroying &&
            !globalState.isExiting) {
          globalState.showNotifier(error.toString());
          // globalState.appController.restartCore();
        }
      },
    );
  }

  @override
  reStart() async {
    if (isStarting) return;
    isStarting = true;
    _isDestroying = false;

    await _destroySocket();

    process?.kill();
    for (var i = 0; i < 5; i++) {
      if (process == null) break;
      try {
        process!.exitCode;
        break;
      } on StateError {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    process = null;

    socketCompleter = Completer();

    final serverSocket = await serverCompleter.future;
    final arg = system.isWindows
        ? '${serverSocket.port}'
        : serverSocket.address.address;

    if (system.isWindows) {
      final serviceOk = await windows?.registerService() ?? false;
      if (serviceOk) {
        final isSuccess = await request.startCoreByHelper(arg);
        if (isSuccess) {
          await _waitForCoreReady();
          isStarting = false;
          return;
        }
      }
    }

    final homeDirPath = await appPath.homeDirPath;
    final environment = Map<String, String>.from(Platform.environment);
    environment['SAFE_PATHS'] = homeDirPath;

    process = await Process.start(appPath.corePath, [
      arg,
    ], environment: environment);
    process?.stdout.listen((_) {});
    process?.stderr.listen((e) {
      final error = utf8.decode(e);
      if (error.isNotEmpty) commonPrint.log(error);
    });
    await _waitForCoreReady();
    isStarting = false;
  }

  Future<void> _waitForCoreReady() async {
    const maxAttempts = 5;
    const interval = Duration(milliseconds: 1000);

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      if (socketCompleter.isCompleted) return;
      await Future.delayed(interval);
    }
    commonPrint.log(
      'Core ready timeout after ${maxAttempts * interval.inMilliseconds}ms',
    );
  }

  @override
  destroy() async {
    _isDestroying = true;
    final server = await serverCompleter.future;
    await server.close();
    await _deleteSocketFile();
    return true;
  }

  @override
  sendMessage(String message) async {
    if (_isDestroying || globalState.isExiting) {
      return;
    }
    final socket = await socketCompleter.future;
    try {
      socket.writeln(message);
    } on SocketException catch (e) {
      if (_isDestroying || globalState.isExiting) {
        commonPrint.log('Ignore socket error during shutdown: $e');
        return;
      }
      rethrow;
    }
  }

  Future<void> _deleteSocketFile() async {
    if (!system.isWindows) {
      final file = File(unixSocketPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> _destroySocket() async {
    if (socketCompleter.isCompleted) {
      final lastSocket = await socketCompleter.future;
      await lastSocket.close();
      socketCompleter = Completer();
    }
  }

  @override
  shutdown() async {
    _isDestroying = true;
    if (system.isWindows) {
      await request.stopCoreByHelper();
    }
    await _destroySocket();
    process?.kill();
    process = null;
    return true;
  }

  @override
  Future<bool> preload() async {
    await serverCompleter.future;
    return true;
  }
}

final clashService = system.isDesktop ? ClashService() : null;
