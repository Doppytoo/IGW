import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/widgets/connection_error.dart';
import 'package:speed_monitor/widgets/incident_tile.dart';

class IncidentsPage extends ConsumerStatefulWidget {
  const IncidentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IncidentsPageState();
}

class _IncidentsPageState extends ConsumerState<IncidentsPage> {
  int? _serviceId;
  DateTime? _periodStart;
  DateTime? _periodEnd;

  Widget _filterSheetBuilder(BuildContext ctx) {
    return Container(
      height: 480,
      child: DateRangePickerDialog(
        firstDate: DateTime(1970, 1, 1, 0, 0),
        lastDate: DateTime(2070, 1, 1, 0, 0),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
      ),
    );
  }

  void _openFilterModal() {
    showModalBottomSheet(context: context, builder: _filterSheetBuilder);
  }

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
        error: (e, s) {
          if (e is DioException) {
            if (e.type == DioExceptionType.connectionError) {
              return Center(child: ConnectionErrorCard(e));
            }
          }

          if (e is StateError) {
            if (e.toString().contains('requireValue')) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }

          return Text(e.toString());
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        data: (incidents) => ListView.builder(
          itemCount: incidents.length + 2,
          itemBuilder: (ctx, idx) {
            if (idx-- == 0) {
              return OutlinedButton.icon(
                  onPressed: _openFilterModal, label: Icon(Icons.filter_list));
            }
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
