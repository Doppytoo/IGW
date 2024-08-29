// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servicesHash() => r'c7c47a8f03f93c635a08de12ba567bd5f9fc3a04';

/// See also [services].
@ProviderFor(services)
final servicesProvider = AutoDisposeFutureProvider<List<Service>>.internal(
  services,
  name: r'servicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$servicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ServicesRef = AutoDisposeFutureProviderRef<List<Service>>;
String _$latestRecordsHash() => r'd5b55b60e600ef417ce7d2be4b169c6b548008a7';

/// See also [latestRecords].
@ProviderFor(latestRecords)
final latestRecordsProvider =
    AutoDisposeFutureProvider<List<SpeedRecord>>.internal(
  latestRecords,
  name: r'latestRecordsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestRecordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LatestRecordsRef = AutoDisposeFutureProviderRef<List<SpeedRecord>>;
String _$recordsHash() => r'0c1648e4f54afaf89b3f30b67add33920620b157';

/// See also [Records].
@ProviderFor(Records)
final recordsProvider =
    AutoDisposeAsyncNotifierProvider<Records, List<SpeedRecord>>.internal(
  Records.new,
  name: r'recordsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recordsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Records = AutoDisposeAsyncNotifier<List<SpeedRecord>>;
String _$incidentsHash() => r'663110af1f04dac1dd6727cbe061bad75727da55';

/// See also [Incidents].
@ProviderFor(Incidents)
final incidentsProvider =
    AutoDisposeAsyncNotifierProvider<Incidents, List<Incident>>.internal(
  Incidents.new,
  name: r'incidentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$incidentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Incidents = AutoDisposeAsyncNotifier<List<Incident>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
