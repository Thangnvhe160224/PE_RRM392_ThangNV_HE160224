enum Currency {
  vnd('VND', 'VND (Việt Nam Đồng)'),
  usd('USD', 'USD (Đô la Mỹ)');

  final String code;
  final String label;

  const Currency(this.code, this.label);
}
const vndPerUsd = 25000;
