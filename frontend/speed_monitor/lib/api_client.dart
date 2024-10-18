import 'package:dio/dio.dart';

import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/telegram_account.dart';
import 'package:speed_monitor/models/user.dart';

class SpeedMonitorApiClient {
  static final _defaultOptions = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000', contentType: 'application/json');

  final Dio _httpClient;

  SpeedMonitorApiClient() : _httpClient = Dio(_defaultOptions);

  SpeedMonitorApiClient.withToken(String authToken)
      : _httpClient = Dio(_defaultOptions.copyWith()
          ..headers['Authorization'] = 'Bearer $authToken');

  bool get hasToken => _httpClient.options.headers['Authorization'] != null;

  Future<bool> ping() async {
    final resp = await _httpClient.get('/ping');

    return (resp.statusCode == 200);
  }

  Future<String> login(LoginDetails data) async {
    final response = await _httpClient.post(
      '/auth/login',
      data: FormData.fromMap(data.toJson()),
    );

    return response.data['access_token'] as String;
  }

  // * Incidents
  Future<List<Incident>> getIncidients({
    int skip = 0,
    int lim = 100,
    List<int> serviceIds = const [],
    DateTime? start,
    DateTime? end,
  }) async {
    final resp = await _httpClient.get('/incidents', queryParameters: {
      'skip': skip,
      'lim': lim,
      'service_id': serviceIds,
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

  Future<Service> getService(int id) async {
    final resp = await _httpClient.get('/services/$id');

    return Service.fromJson(resp.data);
  }

  Future<Service> addService(Service service) async {
    final resp =
        await _httpClient.post('/services/new', data: service.toJson());

    return Service.fromJson(resp.data);
  }

  Future<Service> updateService(Service service) async {
    final resp = await _httpClient.patch('/services/${service.id}',
        data: service.toJson());

    return Service.fromJson(resp.data);
  }

  Future<void> deleteService(int id) async {
    await _httpClient.delete('/services/$id');
  }

  // Future<Service> updateService()

  // * Users
  Future<List<User>> getAllUsers() async {
    final resp = await _httpClient.get('/users/all');

    return (resp.data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList();
  }

  Future<User> getCurrentUser() async {
    final resp = await _httpClient.get('/users/me');

    return User.fromJson(resp.data);
  }

  Future<User> getUser(int id) async {
    final resp = await _httpClient.get('/users/$id');

    return User.fromJson(resp.data);
  }

  Future<User> updateUser({required User user, String? password}) async {
    final requestData = {
      ...user.toJson(),
      if (password != null) 'password': password,
    };

    final resp =
        await _httpClient.patch('/users/${user.id}', data: requestData);

    return User.fromJson(resp.data);
  }

  Future<User> addUser({required User user, required String password}) async {
    final requestData = {
      ...user.toJson(),
      'password': password,
    };

    final resp = await _httpClient.post('/users/new', data: requestData);

    return User.fromJson(resp.data);
  }

  Future<void> deleteUser(int id) async {
    await _httpClient.delete('/users/$id');
  }

  // * Telegram
  Future<TelegramAccount?> getCurrentTelegram() async {
    final resp = await _httpClient.get('/telegram/my');

    return (resp.data as List).isNotEmpty
        ? TelegramAccount.fromJson(resp.data[0])
        : null;
  }

  Future<String> linkTelegram() async {
    final resp = await _httpClient.get('/telegram/link');

    return (resp.data as Map<String, dynamic>)['code'];
  }

  Future<void> unlinkTelegram() async {
    await _httpClient.delete('/telegram/unlink');
  }

  // * Settings
  Future<Map<String, Object?>> getAllSettings() async {
    final resp = await _httpClient.get('/settings/all');

    return resp.data;
  }

  Future<Object> getSetting(String key) async {
    final resp = await _httpClient.get('/settings/$key');

    return resp.data;
  }

  Future<void> setSetting(String key, Object value) async {
    final resp = await _httpClient.post('/settings/$key', data: value);

    // return resp.data;
  }
}
