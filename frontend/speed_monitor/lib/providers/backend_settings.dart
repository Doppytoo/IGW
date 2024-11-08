import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/providers/api.dart';

part 'backend_settings.g.dart';

class BackendSettingsData {
  final int pingInterval;
  final int urgentPingInterval;
  final bool repeatIncidentNotifications;
  final int? incidentNotificationRepeatDelay;

  BackendSettingsData({
    required this.pingInterval,
    required this.urgentPingInterval,
    required this.repeatIncidentNotifications,
    this.incidentNotificationRepeatDelay,
  });

  BackendSettingsData.fromJson(Map<String, dynamic> json)
      : this(
          pingInterval: json['ping_interval'],
          urgentPingInterval: json['urgent_ping_interval'],
          repeatIncidentNotifications: json['repeat_incident_notifications'],
          incidentNotificationRepeatDelay:
              json['incident_notification_repeat_delay'],
        );

  Map<String, Object> toJson() => {
        'ping_interval': pingInterval,
        'urgent_ping_interval': urgentPingInterval,
        'repeat_incident_notifications': repeatIncidentNotifications,
        if (incidentNotificationRepeatDelay != null)
          'incident_notification_repeat_delay':
              incidentNotificationRepeatDelay!,
      };

  @override
  operator ==(Object other) =>
      other is BackendSettingsData &&
      this.pingInterval == other.pingInterval &&
      this.urgentPingInterval == other.urgentPingInterval &&
      this.repeatIncidentNotifications == other.repeatIncidentNotifications &&
      this.incidentNotificationRepeatDelay ==
          other.incidentNotificationRepeatDelay;
}

@riverpod
class BackendSettings extends _$BackendSettings {
  @override
  Future<BackendSettingsData> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);

    return BackendSettingsData.fromJson(await api.getAllSettings());
  }

  Future<void> updateSettings(BackendSettingsData settings) async {
    final api = ref.read(apiProvider);

    for (var entry in settings.toJson().entries) {
      await api.setSetting(entry.key, entry.value);
    }

    state = AsyncData(BackendSettingsData.fromJson(await api.getAllSettings()));
  }
}
