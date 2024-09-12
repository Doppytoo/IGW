import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/filters.dart';
import 'package:speed_monitor/ui/home/widgets/service_status_graph.dart';
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
        children: [
          ServiceStatusGraph(),
          Flexible(
            child: IncidentList(
              filter: IncidentFilterData(serviceId: service.id),
            ),
          ),
        ],
      ),
    );
  }
}
