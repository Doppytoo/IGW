import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/incident.dart';
import 'package:speed_monitor/models/record.dart';
import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/user.dart';
import 'package:speed_monitor/providers/api.dart';

part 'data.g.dart';

// * Services
@riverpod
class Services extends _$Services {
  @override
  Future<List<Service>> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);

    // ? TODO: Implement Caching

    return await api.getServices().catchError(
      (e, st) async {
        await ref.refresh(userInfoProvider.future);
        ref.invalidateSelf();
      },
      test: (e) =>
          e is DioException &&
          e.type == DioExceptionType.badResponse &&
          e.response!.statusCode == 401,
    );
  }

  Future<void> updateService(Service data) async {
    state = await AsyncValue.guard(() async {
      final services = await future;
      final newService = await ref.read(apiProvider).updateService(data);

      services[services.indexWhere((svc) => svc.id == newService.id)] =
          newService;

      return services;
    });
  }

  Future<void> createService(Service data) async {
    state = await AsyncValue.guard(() async {
      final services = await future;

      final newService = await ref.read(apiProvider).addService(data);

      services.add(newService);
      return services;
    });
  }

  Future<void> deleteService(int id) async {
    state = await AsyncValue.guard(() async {
      final services = await future;

      await ref.read(apiProvider).deleteService(id);
      services.removeWhere((svc) => svc.id == id);

      return services;
    });
  }
}

// * Records
@riverpod
Future<List<SpeedRecord>> latestRecords(LatestRecordsRef ref) async {
  final SpeedMonitorApiClient api = ref.watch(apiProvider);
  final List<Service> services = ref.watch(servicesProvider).requireValue;

  return (await api.getLatestRecords().catchError(
    (e, st) async {
      await ref.refresh(userInfoProvider.future);
      ref.invalidateSelf();
    },
    test: (e) =>
        e is DioException &&
        e.type == DioExceptionType.badResponse &&
        e.response!.statusCode == 401,
  ))
      .map((r) => r.copyWith(
          service: services.firstWhere((svc) => svc.id == r.serviceId)))
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
        .map((r) => r.copyWith(
            service: services.firstWhere((svc) => svc.id == r.serviceId)))
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
            .map((r) => r.copyWith(
                service: services.firstWhere((svc) => svc.id == r.serviceId)))
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

// * Incidents
@riverpod
class Incidents extends _$Incidents {
  static const incidentsPerPage = 30;

  @override
  Future<List<Incident>> build({
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);
    final List<Service> services = ref.watch(servicesProvider).requireValue;

    try {
      return (await api.getIncidients(
        lim: incidentsPerPage,
        serviceId: serviceId,
        start: start,
        end: end,
      ))
          .map((i) => i.copyWith(
              service: services.firstWhere((svc) => svc.id == i.serviceId)))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse &&
          e.response!.statusCode == 404) {
        return [];
      } else {
        rethrow;
      }
    }
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
                  serviceId: serviceId,
                  start: start,
                  end: end,
                ))
            .map((i) => i.copyWith(
                service: services.firstWhere((svc) => svc.id == i.serviceId)))
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

// * Users
@riverpod
class Users extends _$Users {
  @override
  Future<List<User>> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);

    return await api.getAllUsers();
  }

  Future<void> updateUser({required User user, String? password}) async {
    state = await AsyncValue.guard(() async {
      final users = await future;
      final newUser = await ref
          .read(apiProvider)
          .updateUser(user: user, password: password);

      users[users.indexWhere((svc) => svc.id == newUser.id)] = newUser;

      return users;
    });
  }

  Future<void> createUser(
      {required User user, required String password}) async {
    state = await AsyncValue.guard(() async {
      final users = await future;

      final newUser =
          await ref.read(apiProvider).addUser(user: user, password: password);

      users.add(newUser);
      return users;
    });
  }

  // Future<void> deleteService(int id) async {
  //   state = await AsyncValue.guard(() async {
  //     final services = await future;

  //     await ref.read(apiProvider).deleteService(id);
  //     services.removeWhere((svc) => svc.id == id);

  //     return services;
  //   });
  // }
}
