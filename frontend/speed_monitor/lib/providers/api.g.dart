// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authTokenHash() => r'5e01318f54b52afe6596def78821aa13b8373900';

/// See also [authToken].
@ProviderFor(authToken)
final authTokenProvider = AutoDisposeProvider<String?>.internal(
  authToken,
  name: r'authTokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthTokenRef = AutoDisposeProviderRef<String?>;
String _$apiHash() => r'b45521f58a806120082ef193dac6993d5b9990ea';

/// See also [api].
@ProviderFor(api)
final apiProvider = AutoDisposeProvider<SpeedMonitorApiClient>.internal(
  api,
  name: r'apiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApiRef = AutoDisposeProviderRef<SpeedMonitorApiClient>;
String _$userInfoHash() => r'fe73dfdf551f418879e7b17403e5514e9adcd59d';

/// See also [userInfo].
@ProviderFor(userInfo)
final userInfoProvider = AutoDisposeFutureProvider<User?>.internal(
  userInfo,
  name: r'userInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserInfoRef = AutoDisposeFutureProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
