import 'package:speed_monitor/providers/api.dart';
import 'package:speed_monitor/providers/data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authTokenProvider);
    final user = ref.watch(userInfoProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(token ?? 'TOKEN NULL'),
          user.when(
            error: (e, st) => Text(e.toString()),
            loading: () => Text('LOADING'),
            data: (userData) => Text(userData.toString()),
          ),
        ],
      ),
    );
  }
}

/*
class RecordListPage extends ConsumerStatefulWidget {
  const RecordListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordListPageState();
}

class _RecordListPageState extends ConsumerState<RecordListPage> {
  bool _do = true;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yMd hh:mm:ss', 'ru_RU');
    final recordsAsync = ref.watch(recordsProvider);

    return NotificationListener(
      onNotification: (notif) {
        // print(notif);

        if (notif is ScrollUpdateNotification) {
          final ScrollMetrics(:pixels, :maxScrollExtent) = notif.metrics;

          // print('px: $pixels | me: $maxScrollExtent');

          if (pixels >= maxScrollExtent - 120 && !recordsAsync.isLoading) {
            print('CALLED');
            ref.read(recordsProvider.notifier).loadMore();
          }

          return true;
        }
        return false;
      },
      child: recordsAsync.when(
        skipLoadingOnReload: true,
        error: (error, st) {
          return Center(
            child: Text(error.toString() + '\n' + st.toString()),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        data: (records) => ListView.builder(
          itemCount: records.length + 1,
          itemBuilder: (ctx, idx) {
            if (idx == records.length) {
              return (recordsAsync.isLoading) // On reload
                  ? SizedBox(height: 4, child: LinearProgressIndicator())
                  : SizedBox(height: 4);
            }

            return Card(
              child: Column(
                children: [
                  Text(records[idx].id.toString()),
                  Text(records[idx].service!.name),
                  Text(records[idx].pingTime.toStringAsFixed(2)),
                  Text(df.format(records[idx].timeRecordedAt)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
*/