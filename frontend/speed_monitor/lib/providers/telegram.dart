import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:speed_monitor/api_client.dart';
import 'package:speed_monitor/models/telegram_account.dart';
import 'package:speed_monitor/providers/api.dart';

part 'telegram.g.dart';

@riverpod
class TelegramLink extends _$TelegramLink {
  @override
  Future<TelegramAccount?> build() async {
    final SpeedMonitorApiClient api = ref.watch(apiProvider);

    return await api.getCurrentTelegram();
  }

  Future<String> linkNew() async {
    return await ref.read(apiProvider).linkTelegram();
  }

  Future<void> unlink() async {
    await ref.read(apiProvider).unlinkTelegram();

    state = const AsyncValue.data(null);
  }
}
