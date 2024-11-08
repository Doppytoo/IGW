import 'package:flutter/material.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/status.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile(
    this.service,
    this.pingTime,
    this.status, {
    super.key,
  });

  final Service service;
  final double pingTime;
  final Status status;

  @override
  Widget build(BuildContext context) {
    late final Color? fgColor;
    late final Color? bgColor;
    late final IconData statusIcon;

    switch (status) {
      case Status.good:
        fgColor = null;
        bgColor = null;
        statusIcon = Icons.gpp_good;
        break;
      case Status.maybe:
        fgColor = Theme.of(context).colorScheme.onErrorContainer;
        bgColor = Theme.of(context).colorScheme.errorContainer;
        statusIcon = Icons.gpp_maybe;
        break;
      case Status.bad:
        fgColor = Theme.of(context).colorScheme.onError;
        bgColor = Theme.of(context).colorScheme.error;
        statusIcon = Icons.gpp_bad;
        break;
      default:
    }

    final tile = ListTile(
      iconColor: fgColor,
      textColor: fgColor,
      // tileColor: bgColor,
      leading: Icon(statusIcon),
      title: Text(service.name),
      subtitle:
          Text('${pingTime.toStringAsFixed(2)}с/${service.pingThreshold}с'),
      // subtitle: Text(service.url),
      // trailing: Text('0.3с/${service.pingThreshold}с'),
      trailing: const Icon(Icons.arrow_forward_ios),
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
      onTap: () => Navigator.of(context)
          .pushNamed('/serviceDetails', arguments: service),
    );

    return Card.outlined(
      color: bgColor,
      child: tile,
    );
  }
}
