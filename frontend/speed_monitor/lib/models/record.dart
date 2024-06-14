import 'package:speed_monitor/models/service.dart';

class Record {
  final int id;
  final DateTime timeRecordedAt;
  final double pingTime;
  final Service service;

  Record({
    required this.id,
    required this.timeRecordedAt,
    required this.pingTime,
    required this.service,
  });
}
