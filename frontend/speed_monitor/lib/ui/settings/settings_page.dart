// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/providers/api.dart';
import 'package:speed_monitor/providers/backend_settings.dart';
import 'package:speed_monitor/providers/secure_storage.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _pingIntervalFieldController = TextEditingController();
  bool? _repeatIncidentNotifications;
  final _repeatedNotificationDelayFieldController = TextEditingController();

  bool _hasUnappliedSettings = false;
  void _checkSettingChanges() {
    final currentSettings = ref.read(backendSettingsProvider).requireValue;

    final newSettings = BackendSettingsData(
      pingInterval: int.parse(_pingIntervalFieldController.text),
      urgentPingInterval: 5,
      repeatIncidentNotifications: _repeatIncidentNotifications!,
      incidentNotificationRepeatDelay:
          _repeatedNotificationDelayFieldController.text.isNotEmpty
              ? int.parse(_repeatedNotificationDelayFieldController.text)
              : null,
    );

    setState(() {
      if (currentSettings != newSettings) {
        _hasUnappliedSettings = true;
      } else {
        _hasUnappliedSettings = false;
      }
    });
  }

  Future<void> _applyNewSettings() async {
    await ref
        .read(backendSettingsProvider.notifier)
        .updateSettings(BackendSettingsData(
          pingInterval: int.parse(_pingIntervalFieldController.text),
          urgentPingInterval: 5,
          repeatIncidentNotifications: _repeatIncidentNotifications!,
          incidentNotificationRepeatDelay:
              _repeatedNotificationDelayFieldController.text.isNotEmpty
                  ? int.parse(_repeatedNotificationDelayFieldController.text)
                  : null,
        ));

    await Future.delayed(Duration(milliseconds: 250));
    setState(() {
      _hasUnappliedSettings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(userInfoProvider);
    // TODO: Telegram linking

    return Scaffold(
        appBar: AppBar(
          title: Text("Настройки"),
        ),
        floatingActionButton: _hasUnappliedSettings
            ? FloatingActionButton.extended(
                onPressed: _applyNewSettings,
                label: Text('Применить'),
                icon: Icon(Icons.check),
              )
            : null,
        body: AsyncValueConnectionWrapper(
            value: currentUserAsync,
            onData: (currentUser) {
              if (currentUser != null && currentUser.isAdmin) {
                final currentSettings = ref.watch(backendSettingsProvider);
                return AsyncValueConnectionWrapper(
                  value: currentSettings,
                  onData: (currentSettingsData) {
                    if (_pingIntervalFieldController.text.isEmpty) {
                      _pingIntervalFieldController.text =
                          currentSettingsData.pingInterval.toString();
                    }

                    _repeatIncidentNotifications ??=
                        currentSettingsData.repeatIncidentNotifications;

                    if (_repeatedNotificationDelayFieldController
                            .text.isEmpty &&
                        currentSettingsData.incidentNotificationRepeatDelay !=
                            null) {
                      _repeatedNotificationDelayFieldController.text =
                          currentSettingsData.incidentNotificationRepeatDelay
                              .toString();
                    }

                    return ListView(
                      children: [
                        Card.outlined(
                          margin: EdgeInsets.all(8.0),
                          // color: Theme.of(context).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currentUser.username,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .errorContainer),
                                  label: Text('Выйти'),
                                  icon: Icon(Icons.logout),
                                  onPressed: () {
                                    ref.read(secureStorageProvider).requireValue
                                      ..remove('token')
                                      ..remove('username')
                                      ..remove('password');
                                    ref.invalidate(authTokenProvider);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Тема приложения'),
                          trailing: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: ThemeMode.system,
                              items: const <DropdownMenuItem>[
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.contrast),
                                      SizedBox(width: 8),
                                      Text('Системная'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.light_mode),
                                      SizedBox(width: 8),
                                      Text('Светлая'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.dark_mode),
                                      SizedBox(width: 8),
                                      Text('Тёмная'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),

                        const Divider(indent: 8, endIndent: 8),
                        ListTile(
                          title: Text('Периодичность проверки скорости'),
                          trailing: SizedBox(
                            width: 72,
                            child: TextField(
                              controller: _pingIntervalFieldController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              decoration: InputDecoration(suffix: Text('мин')),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (_) => _checkSettingChanges(),
                            ),
                          ),
                        ),
                        SwitchListTile.adaptive(
                            title: Text('Оповещать об инцидентах повторно'),
                            value: _repeatIncidentNotifications!,
                            onChanged: (value) {
                              setState(() {
                                _repeatIncidentNotifications = value;
                              });
                              _checkSettingChanges();
                            }),
                        ListTile(
                          title:
                              Text('Повторное оповещение об инцидентах через'),
                          enabled: _repeatIncidentNotifications!,
                          trailing: SizedBox(
                            width: 72,
                            child: TextField(
                              enabled: _repeatIncidentNotifications,
                              controller:
                                  _repeatedNotificationDelayFieldController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              decoration: InputDecoration(suffix: Text('мин')),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (_) => _checkSettingChanges(),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Сервисы'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/settings/services'),
                        ),
                        ListTile(
                          title: Text('Пользователи'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.of(context)
                              .pushNamed('/settings/users'),
                        ),

                        // AboutListTile(
                        //   icon: Icon(Icons.info),

                        // ),
                      ],
                    );
                  },
                );
              } else {
                return ListView(
                  children: [
                    Card.outlined(
                      margin: EdgeInsets.all(8.0),
                      // color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentUser!.username,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer),
                              label: Text('Выйти'),
                              icon: Icon(Icons.logout),
                              onPressed: () {
                                ref.read(secureStorageProvider).requireValue
                                  ..remove('token')
                                  ..remove('username')
                                  ..remove('password');
                                ref.invalidate(authTokenProvider);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Тема приложения'),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: ThemeMode.system,
                          items: const <DropdownMenuItem>[
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.contrast),
                                  SizedBox(width: 8),
                                  Text('Системная'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.light_mode),
                                  SizedBox(width: 8),
                                  Text('Светлая'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.dark_mode),
                                  SizedBox(width: 8),
                                  Text('Тёмная'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),

                    // AboutListTile(
                    //   icon: Icon(Icons.info),

                    // ),
                  ],
                );
              }
            }));
  }
}
