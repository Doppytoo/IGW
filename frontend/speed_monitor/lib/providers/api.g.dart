// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authTokenHash() => r'f2ef118fba5f64eb1040ff26c452bfa8c6b43904';

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
String _$loginHash() => r'75b0600d69dbe4a508c44cd71984c5cd986d7487';

/// See also [login].
@ProviderFor(login)
final loginProvider = AutoDisposeProvider<LoginDetails?>.internal(
  login,
  name: r'loginProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoginRef = AutoDisposeProviderRef<LoginDetails?>;
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
String _$userInfoHash() => r'479b3227a5bc846ee045532ea9ebea59ea92bc3c';

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
