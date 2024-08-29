import 'package:dio/dio.dart';

import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/user.dart';

class SpeedMonitorApiClient {
  static final _defaultOptions = BaseOptions(
    baseUrl: 'http://127.0.0.1:8000',
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

  // * Incidents
  Future<List<Incident>> getIncidients({
    int skip = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final resp = await _httpClient.get('/incidents', queryParameters: {
      'skip': skip,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });

    return (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Incident.fromJson)
        .toList();
  }

  // * Records
  Future<List<SpeedRecord>> getRecords({
    int skip = 0,
    int lim = 100,
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final resp = await _httpClient.get('/records', queryParameters: {
      'skip': skip,
      'lim': lim,
      if (serviceId != null) 'service_id': serviceId,
      if (start != null) 'period_start': start.toIso8601String(),
      if (end != null) 'period_end': end.toIso8601String(),
    });

    final records = (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SpeedRecord.fromJson)
        .toList();

    return records;
  }

  Future<List<SpeedRecord>> getLatestRecords() async {
    final resp = await _httpClient.get('/records/latest');

    final records = (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(SpeedRecord.fromJson)
        .toList();

    return records;
  }

  // * Services
  Future<List<Service>> getServices() async {
    final resp = await _httpClient.get('/services/all');

    return (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map<Service>(Service.fromJson)
        .toList();
  }

  Future<Service> addService(Map<String, dynamic> serviceJson) async {
    final resp = await _httpClient.post('/services/new', data: serviceJson);

    return Service.fromJson(resp.data);
  }

  // * Users
  Future<User> getCurrentUser() async {
    final resp = await _httpClient.get('/users/me');

    return User.fromJson(resp.data);
  }

  Future<User> getUser(int id) async {
    final resp = await _httpClient.get('/users/$id');

    return User.fromJson(resp.data);
  }

  // * Settings
  // Future<Map<String, Object>> getAllSettings() async {
  //   final resp = await _httpClient.get('/settings/all');

  //   return resp.data;
  // }

  // Future<Object> getSetting(String key) async {
  //   final resp = await _httpClient.get('/settings/$key');

  //   return resp.data;
  // }

  // Future<void> setSetting(String key, Object value) async {
  //   final resp = await _httpClient.post('/settings/$key');
  // }
}
