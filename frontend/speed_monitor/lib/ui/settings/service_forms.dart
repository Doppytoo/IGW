import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';

class EditServiceForm extends ConsumerWidget {
  EditServiceForm({required this.serviceId, super.key});

  final int serviceId;

  final nameFieldController = TextEditingController();
  final urlFieldController = TextEditingController();
  final pingThresholdFieldController = TextEditingController();

  bool validateInput() {
    return (RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)')
                .stringMatch(urlFieldController.text) ==
            urlFieldController.text) &&
        (nameFieldController.text.isNotEmpty) &&
        (double.tryParse(pingThresholdFieldController.text) != null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return LayoutBuilder(
      builder: (context, constraints) => AsyncValueConnectionWrapper(
        value: servicesAsync,
        onData: (services) {
          final service = services.firstWhere((svc) => svc.id == serviceId);

          nameFieldController.text = service.name;
          urlFieldController.text = service.url;
          pingThresholdFieldController.text = service.pingThreshold.toString();

          return Container(
            width: min(constraints.maxWidth, 480),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Изменить сервис',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[-a-zA-Zа-яА-Я0-9()@:%_\+.~#?&//= !$^*]'))
                  ],
                  decoration: const InputDecoration(label: Text('Название')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: urlFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[-a-zA-Z0-9()@:%_\+.~#?&//=]'))
                  ],
                  decoration: const InputDecoration(label: Text('URL')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pingThresholdFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) return newValue;

                      if (newValue.text[newValue.text.length - 1]
                          .contains(RegExp(r'[,.]'))) {
                        if (!newValue.text
                            .substring(0, newValue.text.length - 1)
                            .contains(RegExp(r'[,.]'))) {
                          return newValue;
                        }
                      } else {
                        return newValue;
                      }

                      return oldValue;
                    })
                  ],
                  decoration: const InputDecoration(
                      label: Text('Порог скорости загрузки'),
                      suffix: Text('сек')),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        if (!validateInput()) return;

                        await ref
                            .read(servicesProvider.notifier)
                            .updateService(service.copyWith(
                              name: nameFieldController.text,
                              url: urlFieldController.text,
                              pingThreshold: double.parse(
                                  pingThresholdFieldController.text),
                            ));

                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Применить'),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class NewServiceForm extends ConsumerWidget {
  NewServiceForm({super.key});

  final nameFieldController = TextEditingController();
  final urlFieldController = TextEditingController();
  final pingThresholdFieldController = TextEditingController();

  bool validateInput() {
    return (RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)')
                .stringMatch(urlFieldController.text) ==
            urlFieldController.text) &&
        (nameFieldController.text.isNotEmpty) &&
        (double.tryParse(pingThresholdFieldController.text) != null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return LayoutBuilder(
      builder: (context, constraints) => AsyncValueConnectionWrapper(
        value: servicesAsync,
        onData: (services) {
          return Container(
            width: min(constraints.maxWidth, 480),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Добавить сервис',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextField(
                  controller: nameFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[-a-zA-Zа-яА-Я0-9()@:%_\+.~#?&//= !$^*]'))
                  ],
                  decoration: const InputDecoration(label: Text('Название')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: urlFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[-a-zA-Z0-9()@:%_\+.~#?&//=]'))
                  ],
                  decoration: const InputDecoration(label: Text('URL')),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pingThresholdFieldController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isEmpty) return newValue;

                      if (newValue.text[newValue.text.length - 1]
                          .contains(RegExp(r'[,.]'))) {
                        if (!newValue.text
                            .substring(0, newValue.text.length - 1)
                            .contains(RegExp(r'[,.]'))) {
                          return newValue;
                        }
                      } else {
                        return newValue;
                      }

                      return oldValue;
                    })
                  ],
                  decoration: const InputDecoration(
                      label: Text('Порог скорости загрузки'),
                      suffix: Text('сек')),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        if (!validateInput()) return;

                        await ref
                            .read(servicesProvider.notifier)
                            .createService(Service(
                              id: services.length,
                              name: nameFieldController.text,
                              url: urlFieldController.text,
                              pingThreshold: double.parse(
                                  pingThresholdFieldController.text),
                            ));

                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Создать'),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
