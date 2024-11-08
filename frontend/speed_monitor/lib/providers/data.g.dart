// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceMetricsHash() => r'2ce474c4e2a29a376b30c10a7076e412f8dbdb3c';

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

/// See also [serviceMetrics].
@ProviderFor(serviceMetrics)
const serviceMetricsProvider = ServiceMetricsFamily();

/// See also [serviceMetrics].
class ServiceMetricsFamily extends Family<AsyncValue<EssentialMetrics>> {
  /// See also [serviceMetrics].
  const ServiceMetricsFamily();

  /// See also [serviceMetrics].
  ServiceMetricsProvider call(
    int id,
  ) {
    return ServiceMetricsProvider(
      id,
    );
  }

  @override
  ServiceMetricsProvider getProviderOverride(
    covariant ServiceMetricsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'serviceMetricsProvider';
}

/// See also [serviceMetrics].
class ServiceMetricsProvider
    extends AutoDisposeFutureProvider<EssentialMetrics> {
  /// See also [serviceMetrics].
  ServiceMetricsProvider(
    int id,
  ) : this._internal(
          (ref) => serviceMetrics(
            ref as ServiceMetricsRef,
            id,
          ),
          from: serviceMetricsProvider,
          name: r'serviceMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceMetricsHash,
          dependencies: ServiceMetricsFamily._dependencies,
          allTransitiveDependencies:
              ServiceMetricsFamily._allTransitiveDependencies,
          id: id,
        );

  ServiceMetricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<EssentialMetrics> Function(ServiceMetricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceMetricsProvider._internal(
        (ref) => create(ref as ServiceMetricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<EssentialMetrics> createElement() {
    return _ServiceMetricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceMetricsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceMetricsRef on AutoDisposeFutureProviderRef<EssentialMetrics> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ServiceMetricsProviderElement
    extends AutoDisposeFutureProviderElement<EssentialMetrics>
    with ServiceMetricsRef {
  _ServiceMetricsProviderElement(super.provider);

  @override
  int get id => (origin as ServiceMetricsProvider).id;
}

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
String _$incidentsHash() => r'dccd8a8eef82de227b6f6493e2b28293caec81e4';

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
