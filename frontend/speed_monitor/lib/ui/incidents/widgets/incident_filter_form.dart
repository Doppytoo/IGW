import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/providers/filters.dart';

class IncidentFilterForm extends ConsumerWidget {
  const IncidentFilterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(incidentFilterProvider);

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: min(constraints.maxWidth, 480),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButton<int?>(
            //   value: filter.serviceIds?[0],
            //   hint: Text('Select Service'),
            //   items: [
            //     const DropdownMenuItem(value: null, child: Text('All')),
            //     ...ref.watch(servicesProvider).requireValue.map((service) {
            //       return DropdownMenuItem<int>(
            //         value: service.id,
            //         child: SizedBox(
            //           width: min(constraints.maxWidth - 72, 480 - 72),
            //           child: Text(
            //             service.name,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //       );
            //     })
            //   ],
            //   onChanged: (value) {
            //     ref
            //         .read(incidentFilterProvider.notifier)
            //         .updateServiceIds(value != null ? [value] : []);
            //   },
            // ),
            Text(
              'Сервисы',
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            ),
            SizedBox(
              width: min(constraints.maxWidth - 48, 432),
              height: min(constraints.maxHeight - 240, 360),
              child: ListView(
                children:
                    ref.watch(servicesProvider).requireValue.map((service) {
                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(service.name),
                    value: filter.serviceIds.contains(service.id),
                    onChanged: (value) {
                      if (value ?? false) {
                        ref
                            .read(incidentFilterProvider.notifier)
                            .addServiceId(service.id);
                      } else {
                        ref
                            .read(incidentFilterProvider.notifier)
                            .removeServiceId(service.id);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Даты',
                    ),
                    readOnly: true,
                    onTap: () async {
                      final pickedDateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDateRange != null) {
                        ref
                            .read(incidentFilterProvider.notifier)
                            .updateStartDate(pickedDateRange.start);
                        ref
                            .read(incidentFilterProvider.notifier)
                            .updateEndDate(pickedDateRange.end);
                      }
                    },
                    controller: TextEditingController(
                      text:
                          "${DateFormat.yMMMd('ru_RU').format(filter.start ?? DateTime(2000))} - ${DateFormat.yMMMd('ru_RU').format(filter.end ?? DateTime.now())}",
                    ),
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {
                    ref
                        .read(incidentFilterProvider.notifier)
                        .updateStartDate(null);
                    ref
                        .read(incidentFilterProvider.notifier)
                        .updateEndDate(null);
                  },
                  icon: const Icon(Icons.restart_alt),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Готово'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
