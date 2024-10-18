import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/providers/api.dart';

class ConnectionErrorCard extends ConsumerWidget {
  const ConnectionErrorCard(
      {required this.error, this.showRetryButton = false, super.key});

  final DioException error;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fgColor = Theme.of(context).colorScheme.onErrorContainer;
    final bgColor = Theme.of(context).colorScheme.errorContainer;
    const icon = Icons.signal_wifi_bad;

    const title = "Нет подключения";
    const subtitle = "Проверьте своё соединение с интернетом";

    return Card.filled(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      color: bgColor,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: fgColor,
                    size: 72.0,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: constraints.maxWidth * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: fgColor),
                        ),
                        // if (errorCount > 0)
                        Text(
                          subtitle,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: fgColor),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            if (showRetryButton) ...[
              const SizedBox(height: 8.0),
              FilledButton.icon(
                label: const Text('Попробовать ещё раз'),
                icon: const Icon(Icons.restart_alt),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.errorContainer,
                  backgroundColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                ),
                onPressed: () {
                  ref.invalidate(apiProvider);
                },
              )
            ]
          ],
        ),
      ),
    );
  }
}
