import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bett_box/common/common.dart';
import 'package:bett_box/state.dart';
import 'package:path/path.dart' as p;
import 'package:restart_app/restart_app.dart';

class ExternalControl {
  static ServerSocket? _server;

  static Future<void> start() async {
    if (!system.isDesktop || _server != null) return;
    final socketPath = await _socketPath();
    final type = FileSystemEntity.typeSync(socketPath);
    if (type != FileSystemEntityType.notFound) {
      try {
        await File(socketPath).delete();
      } catch (_) {}
    }
    final address = InternetAddress(socketPath, type: InternetAddressType.unix);
    _server = await ServerSocket.bind(address, 0);
    _server!.listen(
      (socket) => socket
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_handleCommand),
      onError: (e) => commonPrint.log('ExternalControl server error: $e'),
    );
  }

  static Future<void> stop() async {
    await _server?.close();
    _server = null;
    try {
      final socketPath = await _socketPath();
      final type = FileSystemEntity.typeSync(socketPath);
      if (type != FileSystemEntityType.notFound) {
        await File(socketPath).delete();
      }
    } catch (_) {}
  }

  static Future<void> sendCommand(String command) async {
    if (!system.isDesktop) return;
    final socketPath = await _socketPath();
    final type = FileSystemEntity.typeSync(socketPath);
    if (type == FileSystemEntityType.notFound) {
      throw StateError('Bettbox is not running');
    }
    final address = InternetAddress(socketPath, type: InternetAddressType.unix);
    final socket = await Socket.connect(
      address,
      0,
    ).timeout(const Duration(seconds: 2));
    try {
      socket.write('$command\n');
      await socket.flush();
    } finally {
      await socket.close();
    }
  }

  static Future<String> _socketPath() async {
    final dir = await appPath.dataDir.future;
    return p.join(dir.path, '${AppIdentity.dataDirName}.control.sock');
  }

  static void _handleCommand(String command) {
    switch (command.trim()) {
      case 'exit':
        globalState.appController.handleExit();
      case 'restart':
        Restart.restartApp();
      default:
        commonPrint.log('ExternalControl unknown command: $command');
    }
  }
}
