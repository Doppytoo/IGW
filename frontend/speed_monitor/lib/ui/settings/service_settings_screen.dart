import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';
import 'package:speed_monitor/ui/settings/service_forms.dart';

class ServiceSettingsScreen extends ConsumerWidget {
  const ServiceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сервисы'),
        // actions: [
        //   IconButton(
        //       onPressed: () => showDialog(
        //           context: context,
        //           builder: (ctx) => Dialog(child: NewServiceForm())),
        //       icon: const Icon(Icons.add)),
        //   const SizedBox(width: 8)
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => Dialog(child: NewServiceForm()),
        ),
        child: const Icon(Icons.add),
      ),
      body: AsyncValueConnectionWrapper(
        value: servicesAsync,
        onData: (services) => ListView.builder(
          itemCount: services.length,
          itemBuilder: (ctx, idx) => ListTile(
            leading: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.speed),
                    const SizedBox(width: 4),
                    Text('${services[idx].pingThreshold}с',
                        style: Theme.of(context).textTheme.titleSmall)
                  ],
                ),
              ),
              // child: ,
            ),
            title: Text(services[idx].name),
            subtitle: Text(services[idx].url),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                          child: EditServiceForm(serviceId: services[idx].id))),
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text('Удалить сервис?'),
                              content:
                                  const Text('Сервис будет удалён навсегда.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Нет'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(servicesProvider.notifier)
                                        .deleteService(services[idx].id);

                                    ref.invalidate(latestRecordsProvider);

                                    if (ctx.mounted) Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Да'),
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(ctx).colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
