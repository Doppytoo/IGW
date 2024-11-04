import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/filters.dart';
import 'package:speed_monitor/ui/home/widgets/service_status_card.dart';
import 'package:speed_monitor/ui/incidents/widgets/incident_list.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  const ServiceDetailsScreen(this.service, {super.key});

  final Service service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        forceMaterialTransparency: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceStatusCard(service: service),
          const Divider(indent: 8, endIndent: 8),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Text(
              'Инциденты за всё время',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Flexible(
            child: IncidentList(
              filter: IncidentFilterData(serviceIds: [service.id]),
            ),
          ),
        ],
      ),
    );
  }
}
