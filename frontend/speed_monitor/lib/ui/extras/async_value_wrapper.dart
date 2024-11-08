import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:speed_monitor/ui/extras/connection_error.dart';

class AsyncValueConnectionWrapper<T> extends StatelessWidget {
  const AsyncValueConnectionWrapper({
    required this.value,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
    this.skipError = false,
    required this.onData,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) onData;

  final bool skipLoadingOnReload;
  final bool skipLoadingOnRefresh;
  final bool skipError;

  static Widget onError(Object e, StackTrace st) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return Material(
            child: Center(
                child: ConnectionErrorCard(error: e, showRetryButton: true)));
      }
    }

    if (e is StateError) {
      if (e.toString().contains('requireValue')) {
        return const Material(
            child: Center(child: CircularProgressIndicator.adaptive()));
      }
    }

    return Material(
      child: Text(
        '${e.runtimeType} : $e\n@ $st',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  static Widget onLoading() => const Material(
      child: Center(child: CircularProgressIndicator.adaptive()));

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      error: onError,
      loading: onLoading,
      data: onData,
    );
  }
}
