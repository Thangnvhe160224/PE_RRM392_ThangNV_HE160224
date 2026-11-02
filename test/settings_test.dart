import 'package:course_sqlite/models/currency.dart';
import 'package:course_sqlite/repositories/settings_repository.dart';
import 'package:course_sqlite/utils/formatters.dart';
import 'package:course_sqlite/viewmodels/settings_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> createContainer() async {
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer.test(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  }

  test('chưa lưu gì thì mặc định VND', () async {
    SharedPreferences.setMockInitialValues({});
    final container = await createContainer();

    expect(container.read(settingsViewModelProvider), Currency.vnd);
  });

  test('chọn USD, "tắt app mở lại" vẫn là USD', () async {
    SharedPreferences.setMockInitialValues({});
    final container = await createContainer();

    await container
        .read(settingsViewModelProvider.notifier)
        .setCurrency(Currency.usd);

    final reopened = await createContainer();
    expect(reopened.read(settingsViewModelProvider), Currency.usd);
  });

  test('định dạng tiền và ngày giống ảnh đề', () {
    expect(formatMoney(150000, Currency.vnd), '150,000 VND');
    expect(formatMoney(3550000, Currency.vnd), '3,550,000 VND');
    expect(formatMoney(150000, Currency.usd), '6.00 USD');
    expect(formatDate(DateTime(2026, 10, 29)), '29/10/2026');
  });
}
