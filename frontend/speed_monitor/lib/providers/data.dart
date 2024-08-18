import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/providers/api.dart';

part 'data.g.dart';

@riverpod
Future<List<Incident>> incidents(IncidentsRef ref) async {
  final SpeedMonitorApiClient api = ref.watch(apiProvider);

  return await api.getIncidients();
}
