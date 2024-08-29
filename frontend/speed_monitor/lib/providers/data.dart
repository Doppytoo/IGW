import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/api.dart';

part 'data.g.dart';

@riverpod
Future<List<Service>> services(ServicesRef ref) async {
  final SpeedMonitorApiClient api = ref.watch(apiProvider);

  // TODO: Implement Caching

  return await api.getServices();
}

@riverpod
Future<List<SpeedRecord>> latestRecords(LatestRecordsRef ref) async {
  final SpeedMonitorApiClient api = ref.watch(apiProvider);
  final List<Service> services = ref.watch(servicesProvider).requireValue;

  return (await api.getLatestRecords())
      .map((r) => r.copyWith(service: services[r.serviceId - 1]))
      .toList();
}

@riverpod
class Records extends _$Records {
  static const recordsPerPage = 30;

  @override
  Future<List<SpeedRecord>> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);
    final List<Service> services = ref.watch(servicesProvider).requireValue;

    return (await api.getRecords(lim: recordsPerPage))
        .map((i) => i.copyWith(service: services[i.serviceId - 1]))
        .toList();
  }

  Future<void> loadMore() async {
    final oldRecords = await future;

    state = const AsyncLoading();

    final services = ref.read(servicesProvider).requireValue;

    state = await AsyncValue.guard(() async {
      try {
        final newRecords = (await ref.read(apiProvider).getRecords(
                  lim: recordsPerPage,
                  skip: oldRecords.length,
                ))
            .map((i) => i.copyWith(service: services[i.serviceId - 1]))
            .toList();

        return [...oldRecords, ...newRecords];
      } on DioException catch (e) {
        if (e.type == DioExceptionType.badResponse &&
            e.response!.statusCode == 404) {
          return oldRecords;
        } else {
          rethrow;
        }
      }
    });
  }
}

@riverpod
class Incidents extends _$Incidents {
  static const incidentsPerPage = 30;

  @override
  Future<List<Incident>> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);
    final List<Service> services = ref.watch(servicesProvider).requireValue;

    return (await api.getIncidients(lim: incidentsPerPage))
        .map((i) => i.copyWith(service: services[i.serviceId - 1]))
        .toList();
  }

  Future<void> loadMore() async {
    final oldIncidents = await future;

    state = const AsyncLoading();

    final services = ref.read(servicesProvider).requireValue;

    state = await AsyncValue.guard(() async {
      try {
        final newIncidents = (await ref.read(apiProvider).getIncidients(
                  lim: incidentsPerPage,
                  skip: oldIncidents.length,
                ))
            .map((i) => i.copyWith(service: services[i.serviceId - 1]))
            .toList();

        return [...oldIncidents, ...newIncidents];
      } on DioException catch (e) {
        if (e.type == DioExceptionType.badResponse &&
            e.response!.statusCode == 404) {
          return oldIncidents;
        } else {
          rethrow;
        }
      }
    });
  }
}
