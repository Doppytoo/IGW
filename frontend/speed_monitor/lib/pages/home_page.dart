import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_monitor/providers/data.dart';

import 'package:speed_monitor/widgets/status_card.dart';
import 'package:speed_monitor/widgets/service_tile.dart';

import 'package:speed_monitor/models/service.dart';
import 'package:speed_monitor/models/status.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 27,
//       itemBuilder: (ctx, idx) {
//         if (idx-- == 0) return const StatusCard(Status.maybe, errorCount: 5);

//         return ServiceTile(
//             Service(
//               id: idx,
//               name: 'Сайт #$idx',
//               url: 'http://service$idx.example.com',
//               pingThreshold: 0.5,
//             ),
//             0.3,
//             idx % 5 == 2 ? Status.maybe : Status.good);
//       },
//     );
//   }
// }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(latestRecordsProvider);

    return recordsAsync.when(
      error: (e, s) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      data: (records) => ListView.builder(
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
    );
  }
}
