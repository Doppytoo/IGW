// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestRecordsHash() => r'6d8271681f0bd661ac379014a45ffcd53c133f72';

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
String _$servicesHash() => r'ed57d939c7bc8d14e16fa5f272805ea99ba62f01';

/// See also [Services].
@ProviderFor(Services)
final servicesProvider =
    AutoDisposeAsyncNotifierProvider<Services, List<Service>>.internal(
  Services.new,
  name: r'servicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$servicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Services = AutoDisposeAsyncNotifier<List<Service>>;
String _$recordsHash() => r'5215b209d55e5c01d65e47476b54c9d2b64fef98';

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
String _$incidentsHash() => r'055955d2b3295cd6381a0516211cded21591a35d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Incidents
    extends BuildlessAutoDisposeAsyncNotifier<List<Incident>> {
  late final IncidentFilterData filter;

  FutureOr<List<Incident>> build({
    IncidentFilterData filter = const IncidentFilterData(),
  });
}

/// See also [Incidents].
@ProviderFor(Incidents)
const incidentsProvider = IncidentsFamily();

/// See also [Incidents].
class IncidentsFamily extends Family<AsyncValue<List<Incident>>> {
  /// See also [Incidents].
  const IncidentsFamily();

  /// See also [Incidents].
  IncidentsProvider call({
    IncidentFilterData filter = const IncidentFilterData(),
  }) {
    return IncidentsProvider(
      filter: filter,
    );
  }

  @override
  IncidentsProvider getProviderOverride(
    covariant IncidentsProvider provider,
  ) {
    return call(
      filter: provider.filter,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'incidentsProvider';
}

/// See also [Incidents].
class IncidentsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Incidents, List<Incident>> {
  /// See also [Incidents].
  IncidentsProvider({
    IncidentFilterData filter = const IncidentFilterData(),
  }) : this._internal(
          () => Incidents()..filter = filter,
          from: incidentsProvider,
          name: r'incidentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$incidentsHash,
          dependencies: IncidentsFamily._dependencies,
          allTransitiveDependencies: IncidentsFamily._allTransitiveDependencies,
          filter: filter,
        );

  IncidentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final IncidentFilterData filter;

  @override
  FutureOr<List<Incident>> runNotifierBuild(
    covariant Incidents notifier,
  ) {
    return notifier.build(
      filter: filter,
    );
  }

  @override
  Override overrideWith(Incidents Function() create) {
    return ProviderOverride(
      origin: this,
      override: IncidentsProvider._internal(
        () => create()..filter = filter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Incidents, List<Incident>>
      createElement() {
    return _IncidentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncidentsProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IncidentsRef on AutoDisposeAsyncNotifierProviderRef<List<Incident>> {
  /// The parameter `filter` of this provider.
  IncidentFilterData get filter;
}

class _IncidentsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Incidents, List<Incident>>
    with IncidentsRef {
  _IncidentsProviderElement(super.provider);

  @override
  IncidentFilterData get filter => (origin as IncidentsProvider).filter;
}

String _$usersHash() => r'715fde6189360d0c57f2d24a651395266a811d2b';

/// See also [Users].
@ProviderFor(Users)
final usersProvider =
    AutoDisposeAsyncNotifierProvider<Users, List<User>>.internal(
  Users.new,
  name: r'usersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Users = AutoDisposeAsyncNotifier<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
