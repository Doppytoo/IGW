import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filters.g.dart';

class IncidentFilterData {
  final List<int> serviceIds;
  final DateTime? start;
  final DateTime? end;

  const IncidentFilterData({
    this.serviceIds = const [],
    this.start,
    this.end,
  });

  IncidentFilterData copyWith({
    List<int>? serviceIds,
    DateTime? start,
    DateTime? end,
  }) {
    return IncidentFilterData(
      serviceIds: serviceIds ?? this.serviceIds,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  IncidentFilterData copyWithServiceIds(List<int> serviceIds) =>
      IncidentFilterData(serviceIds: serviceIds, start: start, end: end);

  IncidentFilterData copyWithStart(DateTime? start) =>
      IncidentFilterData(serviceIds: serviceIds, start: start, end: end);

  IncidentFilterData copyWithEnd(DateTime? end) =>
      IncidentFilterData(serviceIds: serviceIds, start: start, end: end);
}

@riverpod
class IncidentFilter extends _$IncidentFilter {
  @override
  IncidentFilterData build() {
    return IncidentFilterData();
  }

  void updateServiceIds(List<int> serviceIds) {
    state = state.copyWithServiceIds(serviceIds);
  }

  void addServiceId(int serviceId) {
    state = state.copyWithServiceIds([...state.serviceIds, serviceId]);
  }

  void removeServiceId(int serviceId) {
    state = state.copyWithServiceIds(state.serviceIds..remove(serviceId));
  }

  void updateStartDate(DateTime? start) {
    state = state.copyWithStart(start);
  }

  void updateEndDate(DateTime? end) {
    state = state.copyWithEnd(end);
  }
}
