// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/models/telegram_account.dart';
import 'package:speed_monitor/providers/preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:speed_monitor/providers/api.dart';
import 'package:speed_monitor/providers/backend_settings.dart';
import 'package:speed_monitor/providers/secure_storage.dart';
import 'package:speed_monitor/providers/telegram.dart';
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
    // TODO: Refresh (on telegram link?)

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
              if (currentUser != null) {
                ref.watch(telegramLinkProvider);
              }

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

                    return RefreshIndicator.adaptive(
                      onRefresh: () async {
                        await ref.refresh(userInfoProvider.future);
                        await ref.refresh(backendSettingsProvider.future);
                        await ref.refresh(telegramLinkProvider.future);
                      },
                      child: ListView(
                        children: [
                          Card.outlined(
                            margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentUser.username,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                                          ref
                                              .read(secureStorageProvider)
                                              .requireValue
                                            ..remove('token')
                                            ..remove('username')
                                            ..remove('password');
                                          ref.invalidate(authTokenProvider);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TelegramLinkTile(),
                                ],
                              ),
                            ),
                          ),
                          AppThemeSelectionTile(),

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
                                decoration:
                                    InputDecoration(suffix: Text('мин')),
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
                            title: Text(
                                'Повторное оповещение об инцидентах через'),
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
                                decoration:
                                    InputDecoration(suffix: Text('мин')),
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
                      ),
                    );
                  },
                );
              } else {
                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    await ref.refresh(userInfoProvider.future);
                    await ref.refresh(telegramLinkProvider.future);
                  },
                  child: ListView(
                    children: [
                      Card.outlined(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentUser!.username,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                      ref
                                          .read(secureStorageProvider)
                                          .requireValue
                                        ..remove('token')
                                        ..remove('username')
                                        ..remove('password');
                                      ref.invalidate(authTokenProvider);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TelegramLinkTile(),
                            ],
                          ),
                        ),
                      ),
                      AppThemeSelectionTile(),
                    ],
                  ),
                );
              }
            }));
  }
}

class AppThemeSelectionTile extends ConsumerWidget {
  const AppThemeSelectionTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

    return ListTile(
      title: Text('Тема приложения'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: currentTheme,
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
          onChanged: (value) async {
            await ref
                .read(appThemeProvider.notifier)
                .setTheme(value as ThemeMode);
          },
        ),
      ),
    );
  }
}

class TelegramLinkTile extends ConsumerWidget {
  const TelegramLinkTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telegramAccountAsync = ref.watch(telegramLinkProvider);

    return AsyncValueConnectionWrapper(
      value: telegramAccountAsync,
      onData: (telegramAccount) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.telegram),
              const SizedBox(width: 8),
              Text(
                telegramAccount != null ? telegramAccount.fullName : 'Telegram',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          telegramAccount == null
              ? FilledButton.tonalIcon(
                  // style: FilledButton.styleFrom(
                  //     foregroundColor: Theme.of(context)
                  //         .colorScheme
                  //         .onErrorContainer,
                  //     backgroundColor: Theme.of(context)
                  //         .colorScheme
                  //         .errorContainer),
                  label: Text('Привязать'),
                  icon: Icon(Icons.add_link),
                  onPressed: () {
                    final codeFuture =
                        ref.read(telegramLinkProvider.notifier).linkNew();

                    showDialog(
                      context: context,
                      builder: (ctx) => FutureBuilder(
                          future: codeFuture,
                          builder: (ctx, code) {
                            if (code.hasData) {
                              return AlertDialog(
                                title: Text(code.requireData),
                                content: Text(
                                    'Чтобы привязать Telegram, нажмите кнопку ниже или отправьте этот код в телеграм-бот с помощью команды /login'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Готово'),
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          'https://t.me/LorraineChungBot?start=${code.requireData}');

                                      final launched = await launchUrl(url);

                                      if (launched && ctx.mounted) {
                                        Navigator.of(ctx).pop();
                                      }
                                    },
                                    child: const Text('Открыть Telegram'),
                                  ),
                                ],
                              );
                            }

                            return Dialog(
                              child: const CircularProgressIndicator.adaptive(),
                            );
                          }),
                    );
                  },
                )
              : FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onErrorContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer),
                  label: Text('Отвязать'),
                  icon: Icon(Icons.link_off),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title:
                            Text('Вы уверены, что хотите отвязать Telegram?'),
                        content: Text('Это действие не может быть отменено!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Нет'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await ref
                                  .read(telegramLinkProvider.notifier)
                                  .unlink();

                              if (ctx.mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                            child: const Text('Да'),
                          ),
                        ],
                      ),
                    );
                  },
                )
          // : FilledButton.tonalIcon(
          //     style: FilledButton.styleFrom(
          //         foregroundColor:
          //             Theme.of(context).colorScheme.onErrorContainer,
          //         backgroundColor:
          //             Theme.of(context).colorScheme.errorContainer),
          //     label: Text('Отвязать'),
          //     icon: Icon(Icons.link_off),
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (ctx) => Placeholder(),
          //       );
          //     },
          //   )
        ],
      ),
    );
  }
}
