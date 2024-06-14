import 'package:speed_monitor/models/service.dart';

class Incident {
  final int id;
  final DateTime timeStarted;
  final DateTime? timeEnded;
  final double pingTimeAtStart;
  final double? pingTimeAtEnd;

  final Service service;

  Incident({
    required this.service,
    required this.id,
    required this.timeStarted,
    required this.pingTimeAtStart,
    this.timeEnded,
    this.pingTimeAtEnd,
  });

  bool get hasEnded => (timeEnded != null) && (pingTimeAtEnd != null);
}
