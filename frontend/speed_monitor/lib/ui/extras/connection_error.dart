import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ConnectionErrorCard extends StatelessWidget {
  const ConnectionErrorCard(this.error, {super.key});

  final DioException error;

  @override
  Widget build(BuildContext context) {
    final fgColor = Theme.of(context).colorScheme.onErrorContainer;
    final bgColor = Theme.of(context).colorScheme.errorContainer;
    const icon = Icons.signal_wifi_bad;

    const title = "Нет подключения";
    const subtitle = "Проверьте своё соединение с интернетом";

    return LayoutBuilder(
      builder: (context, constraints) => Card.filled(
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        color: bgColor,
        child: Container(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 24.0,
            top: 12.0,
            bottom: 12.0,
          ),
          child: Row(
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
                width: constraints.maxWidth * 0.6,
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
          ),
        ),
      ),
    );
  }
}
