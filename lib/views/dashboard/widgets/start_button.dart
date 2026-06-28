import 'dart:async';
import 'package:bett_box/common/common.dart';
import 'package:bett_box/enum/enum.dart';
import 'package:bett_box/models/models.dart';
import 'package:bett_box/providers/providers.dart';
import 'package:bett_box/state.dart';
import 'package:bett_box/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StartButton extends ConsumerStatefulWidget {
  const StartButton({super.key});

  @override
  ConsumerState<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  static const Duration _disableDuration = Duration(milliseconds: 1000);
  Timer? _disableTimer;
  bool _isDisabled = false;

  void _handleStart() {
    if (_isDisabled) return;
    _disableTimer?.cancel();
    setState(() {
      _isDisabled = true;
    });
    _disableTimer = Timer(_disableDuration, () {
      if (!mounted) return;
      setState(() {
        _isDisabled = false;
      });
    });
    final isStart = ref.read(runTimeProvider) != null;
    final newState = !isStart;

    debouncer.call(FunctionTag.updateStatus, () {
      globalState.appController.updateStatus(newState);
    }, duration: commonDuration);
  }

  Future<void> _handleLongPress() async {
    final isStart = ref.read(runTimeProvider) != null;
    if (!isStart) return;

    final result = await globalState.showCommonDialog<bool>(
      child: CommonDialog(
        title: appLocalizations.restartCoreTitle,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(false);
            },
            child: Text(appLocalizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(true);
            },
            child: Text(appLocalizations.confirm),
          ),
        ],
        child: Text(appLocalizations.restartCoreDesc),
      ),
    );

    if (result == true) {
      await globalState.appController.restartCore();
      globalState.showNotifier(appLocalizations.success);
    }
  }

  @override
  void dispose() {
    _disableTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startButtonSelectorStateProvider);
    final canPress = state.isInit && state.hasProfile && !_isDisabled;
    final isRestarting = ref.watch(isRestartingCoreProvider);

    return ValueListenableBuilder<int>(
      valueListenable: dashboardRefreshManager.tick1s,
      builder: (_, _, _) {
        final runTime = ref.read(runTimeProvider);
        final isStart = runTime != null;
        return SizedBox(
          height: getWidgetHeight(1),
          child: CommonCard(
            info: Info(
              label: isRestarting
                  ? appLocalizations.restartCoreTitle
                  : isStart
                  ? appLocalizations.runTime
                  : appLocalizations.powerSwitch,
              iconData: Icons.power_settings_new,
            ),
            onPressed: canPress ? _handleStart : null,
            onLongPress: canPress ? _handleLongPress : null,
            child: Container(
              padding: baseInfoEdgeInsets.copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: globalState.measure.bodyMediumHeight + 2,
                    child: FadeThroughBox(
                      child: _buildContent(
                        context,
                        ref,
                        state,
                        isStart,
                        runTime,
                        isRestarting,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    StartButtonSelectorState state,
    bool isStart,
    int? runTime,
    bool isRestarting,
  ) {
    if (!state.isInit) {
      return Container(
        padding: EdgeInsets.all(2),
        child: AspectRatio(
          aspectRatio: 1,
          child: SpinKitThreeBounce(
            color: context.colorScheme.primary,
            size: 16,
          ),
        ),
      );
    }

    if (!state.hasProfile) {
      return Text(
        appLocalizations.checkOrAddProfile,
        style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (isRestarting) {
      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 16,
          height: 16,
          child: SpinKitThreeBounce(
            color: context.colorScheme.primary,
            size: 16,
          ),
        ),
      );
    }

    if (!isStart) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.play_arrow, size: 16, color: context.colorScheme.primary),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              appLocalizations.serviceReady,
              style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    // Started state: show pause icon + run time
    final timeText = _formatRunTime(runTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.pause, size: 16, color: context.colorScheme.primary),
        SizedBox(width: 4),
        Text('  ', style: context.textTheme.bodyMedium?.toLight.adjustSize(1)),
        Expanded(
          child: Text(
            timeText,
            style: context.textTheme.bodyMedium?.toLight.adjustSize(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatRunTime(int? timeStamp) {
    if (timeStamp == null) return '00:00:00';

    final diff = timeStamp / 1000;
    int inHours = (diff / 3600).floor();
    int inMinutes = (diff / 60 % 60).floor();
    int inSeconds = (diff % 60).floor();

    // Limit maximum display to 999:59:59
    if (inHours > 999) {
      inHours = 999;
      inMinutes = 59;
      inSeconds = 59;
    }

    // If less than 100 hours, show 2 digits; otherwise 3
    final hourStr = inHours < 100
        ? inHours.toString().padLeft(2, '0')
        : inHours.toString().padLeft(3, '0');

    return '$hourStr:${inMinutes.toString().padLeft(2, '0')}:${inSeconds.toString().padLeft(2, '0')}';
  }
}
