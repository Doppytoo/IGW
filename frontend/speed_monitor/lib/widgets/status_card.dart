import 'package:flutter/material.dart';

import 'package:speed_monitor/models/status.dart';

class StatusCard extends StatelessWidget {
  const StatusCard(this.status, {this.errorCount, super.key});

  final Status status;
  final int? errorCount;

  @override
  Widget build(BuildContext context) {
    late final Color fgColor;
    late final Color bgColor;
    late final IconData icon;

    switch (status) {
      case Status.good:
        fgColor = Theme.of(context).colorScheme.onSecondaryContainer;
        bgColor = Theme.of(context).colorScheme.secondaryContainer;
        icon = Icons.gpp_good;
        break;
      case Status.maybe:
        fgColor = Theme.of(context).colorScheme.onErrorContainer;
        bgColor = Theme.of(context).colorScheme.errorContainer;
        icon = Icons.gpp_maybe;
        break;
      case Status.bad:
        fgColor = Theme.of(context).colorScheme.onError;
        bgColor = Theme.of(context).colorScheme.error;
        icon = Icons.gpp_bad;
        break;
      default:
    }

    final String title =
        (status == Status.good) ? "Всё хорошо" : "Есть проблемы";
    final String subtitle = (status == Status.good)
        ? "Все сервисы загружаются достаточно быстро."
        : (errorCount == null)
            ? "Несколько сервисов загружаются слишком медленно."
            : "$errorCount сервис${(errorCount! % 10 == 1) ? '' : (2 <= errorCount! % 10 && errorCount! % 10 <= 4) ? 'а' : 'ов'} загружа${errorCount! % 10 == 1 ? 'ется' : 'ются'} слишком медленно.";

    return Card.filled(
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 4.0,
      //   vertical: 4.0,
      // ),
      color: bgColor,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 24.0,
            top: 12.0,
            bottom: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: fgColor,
                    size: 96.0,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
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
              Icon(
                Icons.arrow_forward_ios,
                color: fgColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
