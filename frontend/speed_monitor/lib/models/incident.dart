import 'package:speed_monitor/models/service.dart';

class Incident {
  final int id;
  final DateTime timeStarted;
  final DateTime? timeEnded;
  final double pingTimeAtStart;
  final double? pingTimeAtEnd;

  final int serviceId;

  Incident({
    required this.serviceId,
    required this.id,
    required this.timeStarted,
    required this.pingTimeAtStart,
    this.timeEnded,
    this.pingTimeAtEnd,
  });

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        serviceId: json['service_id'],
        id: json['id'],
        timeStarted: json['time_started_at'],
        pingTimeAtStart: json['ping_time_at_start'],
        timeEnded:
            json.containsKey('time_ended_at') ? json['time_ended_at'] : null,
        pingTimeAtEnd: json.containsKey('ping_time_at_end')
            ? json['ping_time_at_end']
            : null,
      );

  bool get hasEnded => (timeEnded != null) && (pingTimeAtEnd != null);
}
