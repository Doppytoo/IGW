import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/user.dart';
import 'package:speed_monitor/providers/secure_storage.dart';

part 'api.g.dart';

@riverpod
String? authToken(AuthTokenRef ref) {
  final secureStorage = ref.watch(secureStorageProvider).requireValue;
  return secureStorage.get('token');
}

@riverpod
LoginDetails? login(LoginRef ref) {
  final secureStorage = ref.watch(secureStorageProvider).requireValue;

  if (secureStorage.get('username') != null &&
      secureStorage.get('password') != null) {
    return LoginDetails(
      username: secureStorage.get('username')!,
      password: secureStorage.get('password')!,
    );
  }

  return null;
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
  final link = ref.keepAlive();

  try {
    return await api.getCurrentUser();
  } on DioException catch (e) {
    if (e.type == DioExceptionType.badResponse &&
        e.response!.statusCode == 401) {
      final login = ref.read(loginProvider);
      if (login != null) {
        try {
          final token = await api.login(login);

          ref.read(secureStorageProvider).requireValue.set('token', token);
          ref.invalidate(authTokenProvider);
        } on DioException catch (e) {
          if (e.type == DioExceptionType.badResponse &&
              e.response!.statusCode == 400) {
            ref.read(secureStorageProvider).requireValue.remove('token');
            ref.read(secureStorageProvider).requireValue.remove('username');
            ref.read(secureStorageProvider).requireValue.remove('password');
            ref.invalidate(authTokenProvider);
          } else {
            rethrow;
          }
        }
      }
    } else {
      rethrow;
    }
  }

  return null;
}
