// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsViewModel)
final settingsViewModelProvider = SettingsViewModelProvider._();

final class SettingsViewModelProvider
    extends $NotifierProvider<SettingsViewModel, Currency> {
  SettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsViewModelHash();

  @$internal
  @override
  SettingsViewModel create() => SettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Currency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Currency>(value),
    );
  }
}

String _$settingsViewModelHash() => r'2b177a624bd8134a2c11a4179ea2dc729e40821d';

abstract class _$SettingsViewModel extends $Notifier<Currency> {
  Currency build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Currency, Currency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Currency, Currency>,
              Currency,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
