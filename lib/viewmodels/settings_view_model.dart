import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/currency.dart';
import '../repositories/settings_repository.dart';

part 'settings_view_model.g.dart';

/// Đơn vị tiền tệ đang chọn. Đổi state để màn hình đổi ngay,
/// đồng thời lưu SharedPreferences để mở lại app vẫn giữ.
@Riverpod(keepAlive: true)
class SettingsViewModel extends _$SettingsViewModel {
  @override
  Currency build() {
    return ref.read(settingsRepositoryProvider).loadCurrency();
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    await ref.read(settingsRepositoryProvider).saveCurrency(currency);
  }
}
