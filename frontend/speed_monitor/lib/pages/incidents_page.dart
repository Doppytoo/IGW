import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/widgets/incident_tile.dart';

class IncidentsPage extends ConsumerStatefulWidget {
  const IncidentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends ConsumerState<IncidentsPage> {
  bool _do = true;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMMEEEEd('ru_RU');
    final incidentsAsync = ref.watch(incidentsProvider);

    return NotificationListener(
      onNotification: (notif) {
        // print(notif);

        if (notif is ScrollUpdateNotification) {
          final ScrollMetrics(:pixels, :maxScrollExtent) = notif.metrics;

          // print('px: $pixels | me: $maxScrollExtent');

          if (pixels >= maxScrollExtent - 64 && !incidentsAsync.isLoading) {
            ref.read(incidentsProvider.notifier).loadMore();
          }

          return true;
        }
        return false;
      },
      child: incidentsAsync.when(
        skipLoadingOnReload: true,
        error: (error, st) {
          return Center(
            child: Text(error.toString() + '\n' + st.toString()),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        data: (incidents) => ListView.builder(
          itemCount: incidents.length + 1,
          itemBuilder: (ctx, idx) {
            if (idx == incidents.length) {
              return (incidentsAsync.isLoading) // On reload
                  ? SizedBox(height: 4, child: LinearProgressIndicator())
                  : SizedBox(height: 4);
            }

            return IncidentTile(incidents[idx]);
          },
        ),
      ),
    );
  }
}
