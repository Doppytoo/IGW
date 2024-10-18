import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

@riverpod
Future<SharedPreferencesWithCache> preferences(PreferencesRef ref) async {
  final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions());

  return prefs;
}

@riverpod
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    final prefs = ref.watch(preferencesProvider).requireValue;

    switch (prefs.getString('theme')) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    final prefs = ref.read(preferencesProvider).requireValue;

    await prefs.setString('theme', theme.toString());
    ref.invalidateSelf();
  }
}
