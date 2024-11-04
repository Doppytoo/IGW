import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/providers/filters.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';
import 'package:speed_monitor/ui/incidents/widgets/incident_tile.dart';

class IncidentList extends ConsumerWidget {
  const IncidentList({required this.filter, super.key});

  final IncidentFilterData filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat.yMMMMEEEEd('ru_RU');
    final incidentsAsync = ref.watch(incidentsProvider(filter: filter));

    return NotificationListener(
      onNotification: (notif) {
        if (notif is ScrollUpdateNotification) {
          final ScrollMetrics(:pixels, :maxScrollExtent) = notif.metrics;

          if (pixels >= maxScrollExtent - 64 && !incidentsAsync.isLoading) {
            ref.read(incidentsProvider(filter: filter).notifier).loadMore();
          }

          return true;
        }
        return false;
      },
      child: AsyncValueConnectionWrapper(
        value: incidentsAsync,
        skipLoadingOnReload: true,
        onData: (incidents) => incidents.isEmpty
            ? const Center(
                child: Text('Инциденты не найдены'),
              )
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await ref.refresh(incidentsProvider(filter: filter).future);
                },
                child: ListView.builder(
                  itemCount: incidents.length + 1,
                  itemBuilder: (ctx, idx) {
                    if (idx == incidents.length) {
                      return (incidentsAsync.isLoading) // On reload
                          ? const SizedBox(
                              height: 4, child: LinearProgressIndicator())
                          : const SizedBox(height: 4);
                    }

                    if (idx == 0 ||
                        incidents[idx].timeStarted.copyWith(
                                hour: 0,
                                minute: 0,
                                second: 0,
                                millisecond: 0,
                                microsecond: 0) !=
                            incidents[idx - 1].timeStarted.copyWith(
                                hour: 0,
                                minute: 0,
                                second: 0,
                                millisecond: 0,
                                microsecond: 0)) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Text(
                              df.format(incidents[idx].timeStarted),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          IncidentTile(incidents[idx]),
                        ],
                      );
                    }

                    return IncidentTile(incidents[idx]);
                  },
                ),
              ),
      ),
    );
  }
}
