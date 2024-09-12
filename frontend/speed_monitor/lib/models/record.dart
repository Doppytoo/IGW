import 'package:speed_monitor/models/service.dart';

class SpeedRecord {
  final int id;
  final DateTime timeRecordedAt;
  final double pingTime;

  final int serviceId;
  final Service? service;

  SpeedRecord({
    required this.serviceId,
    required this.id,
    required this.timeRecordedAt,
    required this.pingTime,
    this.service,
  });

  SpeedRecord.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          timeRecordedAt: DateTime.parse(json['time_recorded_at']),
          pingTime: json['ping_time'],
          serviceId: json['service_id'],
        );

  SpeedRecord copyWith({
    int? id,
    DateTime? timeRecordedAt,
    double? pingTime,
    int? serviceId,
    Service? service,
  }) =>
      SpeedRecord(
        serviceId: serviceId ?? this.serviceId,
        id: id ?? this.id,
        timeRecordedAt: timeRecordedAt ?? this.timeRecordedAt,
        pingTime: pingTime ?? this.pingTime,
        service: service ?? this.service,
      );
}
