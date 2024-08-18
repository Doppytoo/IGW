import 'package:dio/dio.dart';

import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/user.dart';

class SpeedMonitorApiClient {
  static final _defaultOptions = BaseOptions(
    baseUrl: '127.0.0.1:8000',
  );

  final Dio _httpClient;

  SpeedMonitorApiClient() : _httpClient = Dio(_defaultOptions);

  SpeedMonitorApiClient.withToken(String authToken)
      : _httpClient = Dio(_defaultOptions.copyWith()
          ..headers['Authorization'] = 'Bearer $authToken');

  Future<bool> ping() async {
    final resp = await _httpClient.get('/ping');

    return (resp.statusCode == 200);
  }

  Future<String> login(LoginDetails data) async {
    final response = await _httpClient.post(
      '/token',
      data: FormData.fromMap(data.toJson()),
    );

    return response.data['token'] as String;
  }

  Future<List<Incident>> getIncidients({
    int page = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final resp = await _httpClient.get('/incidents', queryParameters: {
      'page': page,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });

    return (resp.data as List<Map<String, dynamic>>)
        .map((incidentJson) => Incident.fromJson(incidentJson))
        .toList();
  }

  Future<List<SpeedRecord>> getRecords({
    int page = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final resp = await _httpClient.get('/records', queryParameters: {
      'page': page,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });

    final records = (resp.data as List<Map<String, dynamic>>)
        .map((recordJson) => SpeedRecord.fromJson(recordJson))
        .toList();

    return records;
  }

  Future<List<Service>> getServices() async {
    final resp = await _httpClient.get('/services/all');

    return (resp.data as List<Map<String, dynamic>>)
        .map((serviceJson) => Service.fromJson(serviceJson))
        .toList();
  }

  Future<Service> addService(Map<String, dynamic> serviceJson) async {
    final resp = await _httpClient.post('/services/new', data: serviceJson);

    return Service.fromJson(resp.data);
  }
}
