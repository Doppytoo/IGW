import 'package:speed_monitor/models/service.dart';

class SpeedRecord {
  final int id;
  final DateTime timeRecordedAt;
  final double pingTime;
  final int serviceId;

  SpeedRecord({
    required this.id,
    required this.timeRecordedAt,
    required this.pingTime,
    required this.serviceId,
  });

  factory SpeedRecord.fromJson(Map<String, dynamic> json) => SpeedRecord(
        id: json['id'],
        timeRecordedAt: json['time_recorded_at'],
        pingTime: json['ping_time'],
        serviceId: json['service_id'],
      );
}
