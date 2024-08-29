import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/user.dart';
import 'package:speed_monitor/providers/secure_storage.dart';

part 'api.g.dart';

@riverpod
String? authToken(AuthTokenRef ref) {
  // return null;

  // ! RUNNING WITH TEST TOKEN
  return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTcyNTEzODAwMH0.vCt5lmFQOb0ITCDqus5-BWoK7e7bEFb-C217Mkuym0E';

  final secureStorage = ref.watch(secureStorageProvider).requireValue;
  return secureStorage.get('token');
}

@riverpod
SpeedMonitorApiClient api(ApiRef ref) {
  final token = ref.watch(authTokenProvider);

  final SpeedMonitorApiClient client;

  client = token != null
      ? SpeedMonitorApiClient.withToken(token)
      : SpeedMonitorApiClient();
  ref.keepAlive();

  return client;
}

@riverpod
Future<User?> userInfo(UserInfoRef ref) async {
  final api = ref.watch(apiProvider);
  try {
    return await api.getCurrentUser();
  } on DioException catch (e) {
    if (e.type == DioExceptionType.badResponse &&
        e.response!.statusCode == 401) {
      return null;
    } else {
      rethrow;
    }
  }
}
