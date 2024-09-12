import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filters.g.dart';

class IncidentFilterData {
  final int? serviceId;
  final DateTime? start;
  final DateTime? end;

  IncidentFilterData({
    this.serviceId,
    this.start,
    this.end,
  });

  IncidentFilterData copyWith({
    int? serviceId,
    DateTime? start,
    DateTime? end,
  }) {
    return IncidentFilterData(
      serviceId: serviceId ?? this.serviceId,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  IncidentFilterData copyWithServiceId(int? serviceId) =>
      IncidentFilterData(serviceId: serviceId, start: start, end: end);

  IncidentFilterData copyWithStart(DateTime? start) =>
      IncidentFilterData(serviceId: serviceId, start: start, end: end);

  IncidentFilterData copyWithEnd(DateTime? end) =>
      IncidentFilterData(serviceId: serviceId, start: start, end: end);
}

@riverpod
class IncidentFilter extends _$IncidentFilter {
  @override
  IncidentFilterData build() {
    return IncidentFilterData();
  }

  void updateServiceId(int? serviceId) {
    state = state.copyWithServiceId(serviceId);
  }

  void updateStartDate(DateTime? start) {
    state = state.copyWithStart(start);
  }

  void updateEndDate(DateTime? end) {
    state = state.copyWithEnd(end);
  }
}
