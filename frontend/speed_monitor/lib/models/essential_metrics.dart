import 'package:speed_monitor/models/service.dart';

class EssentialMetrics {
  final int serviceId;
  final int numberOfIncidents;
  final Duration totalIncidentTime; // Minutes
  final double maxPingTime;

  EssentialMetrics({
    required this.serviceId,
    required this.numberOfIncidents,
    required this.totalIncidentTime,
    required this.maxPingTime,
  });

  EssentialMetrics.fromJson(Map<String, dynamic> json)
      : this(
          serviceId: json['service_id'],
          numberOfIncidents: json['number_of_incidents'],
          totalIncidentTime: Duration(seconds: json['total_incident_time']),
          maxPingTime: json['max_ping_time'],
        );
}
