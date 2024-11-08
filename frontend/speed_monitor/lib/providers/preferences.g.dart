// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$preferencesHash() => r'937cd858f4a91b8bed3934184c891c1bb3cf6561';

/// See also [preferences].
@ProviderFor(preferences)
final preferencesProvider =
    AutoDisposeFutureProvider<SharedPreferencesWithCache>.internal(
  preferences,
  name: r'preferencesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$preferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PreferencesRef
    = AutoDisposeFutureProviderRef<SharedPreferencesWithCache>;
String _$appThemeHash() => r'569490f0f16cae9a47120ff85153b315f2fbebaa';

/// See also [AppTheme].
@ProviderFor(AppTheme)
final appThemeProvider =
    AutoDisposeNotifierProvider<AppTheme, ThemeMode>.internal(
  AppTheme.new,
  name: r'appThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppTheme = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
