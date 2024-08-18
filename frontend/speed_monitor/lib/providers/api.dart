import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/providers/secure_storage.dart';

part 'api.g.dart';

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
String? authToken(AuthTokenRef ref) {
  final secureStorage = ref.watch(secureStorageProvider).requireValue;
  return secureStorage.get('token');
}
