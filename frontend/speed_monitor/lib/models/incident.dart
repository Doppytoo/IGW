import 'package:speed_monitor/models/service.dart';

class Incident {
  final int id;
  final DateTime timeStarted;
  final DateTime? timeEnded;
  final double pingTimeAtStart;
  final double? pingTimeAtEnd;

  final int serviceId;
  final Service? service;

  Incident({
    required this.serviceId,
    required this.id,
    required this.timeStarted,
    required this.pingTimeAtStart,
    this.timeEnded,
    this.pingTimeAtEnd,
    this.service,
  });

  Incident.fromJson(Map<String, dynamic> json)
      : this(
          serviceId: json['service_id'],
          id: json['id'],
          timeStarted: DateTime.parse(json['time_started_at']),
          pingTimeAtStart: json['ping_time_at_start'],
          timeEnded:
              json.containsKey('time_ended_at') && json['time_ended_at'] != null
                  ? DateTime.parse(json['time_ended_at'])
                  : null,
          pingTimeAtEnd: json.containsKey('ping_time_at_end')
              ? json['ping_time_at_end']
              : null,
        );

  Incident copyWith({
    int? id,
    DateTime? timeStarted,
    DateTime? timeEnded,
    double? pingTimeAtStart,
    double? pingTimeAtEnd,
    int? serviceId,
    Service? service,
  }) =>
      Incident(
        serviceId: serviceId ?? this.serviceId,
        id: id ?? this.id,
        timeStarted: timeStarted ?? this.timeStarted,
        pingTimeAtStart: pingTimeAtStart ?? this.pingTimeAtStart,
        timeEnded: timeEnded ?? this.timeEnded,
        pingTimeAtEnd: pingTimeAtEnd ?? this.pingTimeAtEnd,
        service: service ?? this.service,
      );

  bool get hasEnded => (timeEnded != null) && (pingTimeAtEnd != null);
}
