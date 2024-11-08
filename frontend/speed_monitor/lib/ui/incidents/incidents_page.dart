import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/providers/filters.dart';
import 'package:speed_monitor/ui/incidents/widgets/incident_filter_form.dart';
import 'package:speed_monitor/ui/incidents/widgets/incident_list.dart';

class IncidentsPage extends ConsumerWidget {
  const IncidentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(incidentFilterProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Инциденты'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const Dialog(child: IncidentFilterForm()),
                );
              },
              icon: const Icon(Icons.filter_list),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IncidentList(filter: filter));
  }
}
