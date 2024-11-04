import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duration/duration.dart';
import 'package:intl/intl.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';

class ServiceStatusCard extends ConsumerWidget {
  const ServiceStatusCard({required this.service, super.key});

  final Service service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Actual info, not placeholders
    final metricsAsync = ref.watch(serviceMetricsProvider(service.id));

    return Card.filled(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: AsyncValueConnectionWrapper(
        value: metricsAsync,
        onData: (metrics) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            Text(
              "${DateFormat.yMMMd('ru_RU').format(DateTime.now().add(const Duration(days: -7)))} - ${DateFormat.yMMMd('ru_RU').format(DateTime.now())}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ListTile(
              title: const Text('Кол-во инцидентов'),
              trailing: Text(
                '${metrics.numberOfIncidents}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (metrics.numberOfIncidents > 0)
              ListTile(
                title: const Text('Суммарное время инцидентов'),
                trailing: Text(
                  metrics.totalIncidentTime.pretty(
                    abbreviated: true,
                    upperTersity: DurationTersity.day,
                    spacer: '  ',
                    locale: DurationLocale.fromLanguageCode('ru')!,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (metrics.numberOfIncidents > 0)
              ListTile(
                title: const Text('Худшая скорость загрузки'),
                trailing: Text(
                  '${metrics.maxPingTime.toStringAsFixed(3)} cек (${metrics.maxPingTime * 100 ~/ service.pingThreshold}%)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
