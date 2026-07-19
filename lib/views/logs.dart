import 'package:bett_box/common/common.dart';
import 'package:bett_box/enum/enum.dart';
import 'package:bett_box/providers/providers.dart';
import 'package:bett_box/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class LogsView extends ConsumerStatefulWidget {
  const LogsView({super.key});

  @override
  ConsumerState<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends ConsumerState<LogsView> {
  late final ScrollController _scrollController;
  var _autoScrollToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final logs = globalState.appState.logs.list;
    if (logs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) return;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    ref.read(logsSearchProvider.notifier).state = value;
  }

  void _onKeywordsUpdate(List<String> keywords) {
    ref.read(logsKeywordsProvider.notifier).state = keywords;
    _scrollToTop();
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.jumpTo(0);
    });
  }

  void _toggleAutoScroll() {
    setState(() {
      _autoScrollToEnd = !_autoScrollToEnd;
    });
  }

  void _cancelAutoScroll() {
    if (_autoScrollToEnd) {
      setState(() {
        _autoScrollToEnd = false;
      });
    }
  }

  Future<void> _handleLogLevelSettings() async {
    final currentLogLevel = ref.read(
      patchClashConfigProvider.select((state) => state.logLevel),
    );

    final selectedLogLevel = await globalState.showCommonDialog<LogLevel>(
      child: OptionsDialog<LogLevel>(
        title: appLocalizations.logLevel,
        options: LogLevel.values,
        value: currentLogLevel,
        textBuilder: (logLevel) => logLevel.name,
      ),
    );

    if (selectedLogLevel != null && selectedLogLevel != currentLogLevel) {
      ref
          .read(patchClashConfigProvider.notifier)
          .updateState((state) => state.copyWith(logLevel: selectedLogLevel));
      globalState.appController.updateClashConfigDebounce();
    }
  }

  Future<void> _handleExport() async {
    final res = await globalState.appController.safeRun<bool>(
      () async {
        return await globalState.appController.exportLogs();
      },
      needLoading: true,
      title: appLocalizations.exportLogs,
    );
    if (res != true) return;
    globalState.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(text: appLocalizations.exportSuccess),
    );
  }

  void _handleClearLogs() {
    ref.read(logsProvider.notifier).clearLogs();
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(filteredLogsProvider);
    final hasLogs = logs.isNotEmpty;
    final classicTheme = ref.watch(
      themeSettingProvider.select(
        (state) => (state.classicTheme as dynamic) == true,
      ),
    );

    return CommonScaffold(
      actions: [
        IconButton(
          onPressed: _handleLogLevelSettings,
          icon: const Icon(Icons.settings_outlined),
          tooltip: appLocalizations.logLevel,
        ),
        IconButton(
          style: _autoScrollToEnd
              ? ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    context.colorScheme.secondaryContainer,
                  ),
                )
              : null,
          onPressed: _toggleAutoScroll,
          icon: const Icon(Icons.vertical_align_top_outlined),
        ),
        InkWell(
          onTap: _handleExport,
          onLongPress: _handleClearLogs,
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.save_as_outlined, size: 24),
          ),
        ),
      ],
      onKeywordsUpdate: _onKeywordsUpdate,
      searchState: AppBarSearchState(onSearch: _onSearch),
      title: appLocalizations.logs,
      body: !hasLogs
          ? NullStatus(label: appLocalizations.nullTip(appLocalizations.logs))
          : ScrollToEndBox(
              onCancelToEnd: _cancelAutoScroll,
              controller: _scrollController,
              enable: _autoScrollToEnd,
              dataSource: logs,
              child: CommonScrollBar(
                controller: _scrollController,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    physics: const NextClampingScrollPhysics(),
                    reverse: true,
                    shrinkWrap: logs.length < 20,
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      bottom: classicTheme ? 0 : 16,
                      top: classicTheme ? 0 : 8,
                    ),
                    itemBuilder: (context, index) {
                      if (classicTheme) {
                        if (index.isOdd) {
                          return const Divider(height: 0);
                        }
                        final itemIndex = index ~/ 2;
                        if (itemIndex >= logs.length) {
                          return const SizedBox.shrink();
                        }
                        final log = logs[itemIndex];
                        return LogItem(
                          key: ValueKey(log.dateTime),
                          log: log,
                          onClick: (value) {
                            context.commonScaffoldState?.addKeyword(value);
                          },
                        );
                      } else {
                        final log = logs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: CommonCard(
                            type: CommonCardType.filled,
                            child: LogItem(
                              key: ValueKey(log.dateTime),
                              log: log,
                              onClick: (value) {
                                context.commonScaffoldState?.addKeyword(value);
                              },
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: classicTheme ? logs.length * 2 - 1 : logs.length,
                  ),
                ),
              ),
            ),
    );
  }
}

class LogItem extends StatelessWidget {
  final Log log;
  final Function(String)? onClick;

  const LogItem({super.key, required this.log, this.onClick});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListItem(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          globalState.showCommonDialog(child: LogDetailDialog(log: log));
        },
        title: Text(
          log.payload,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge?.copyWith(
            color: log.logLevel.color,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonChip(
                onPressed: () {
                  onClick?.call(log.logLevel.name);
                },
                label: log.logLevel.name,
              ),
              Text(
                log.dateTime,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.opacity80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogDetailDialog extends StatelessWidget {
  final Log log;

  const LogDetailDialog({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: appLocalizations.details,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(appLocalizations.confirm),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          SelectableText(
            log.payload,
            style: context.textTheme.bodyLarge?.copyWith(
              color: log.logLevel.color,
            ),
          ),
          SelectableText(
            log.dateTime,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
