import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/currency.dart';

part 'settings_repository.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'Phải override sharedPreferencesProvider trong main()',
  );
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
}

class SettingsRepository {
  static const _currencyKey = 'currency';
  final SharedPreferences _prefs;
  SettingsRepository(this._prefs);
  Currency loadCurrency() {
    final code = _prefs.getString(_currencyKey);
    return Currency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => Currency.vnd,
    );
  }

  Future<void> saveCurrency(Currency currency) async {
    await _prefs.setString(_currencyKey, currency.code);
  }
}
