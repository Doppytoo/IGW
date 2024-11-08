import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/providers/data.dart';
import 'package:speed_monitor/ui/extras/async_value_wrapper.dart';

import 'package:speed_monitor/ui/home/widgets/status_card.dart';
import 'package:speed_monitor/ui/home/widgets/service_tile.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/status.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(latestRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Главная страница')),
      body: AsyncValueConnectionWrapper(
        value: recordsAsync,
        onData: (records) => RefreshIndicator.adaptive(
          onRefresh: () async {
            await ref.refresh(latestRecordsProvider.future);
          },
          child: ListView.builder(
            itemCount: records.length + 1,
            itemBuilder: (ctx, idx) {
              if (idx-- == 0) {
                final errorCount = records.fold<int>(
                    0,
                    (previousCount, r) => r.pingTime > r.service!.pingThreshold
                        ? previousCount + 1
                        : previousCount);

                return StatusCard(
                  errorCount == 0 ? Status.good : Status.maybe,
                  errorCount: errorCount,
                );
              }

              return ServiceTile(
                records[idx].service!,
                records[idx].pingTime,
                records[idx].pingTime <= records[idx].service!.pingThreshold
                    ? Status.good
                    : Status.maybe,
              );
            },
          ),
        ),
      ),
    );
  }
}
