extension StringExts on String {
  num numFromMoney() {
    String moneyValue = this;
    if (contains(',')) {
      moneyValue = replaceAll(',', '');
    }
    if (contains('.')) {
      moneyValue = replaceAll('.', '');
    }
    return num.tryParse(moneyValue) ?? 0;
  }

  String addVND() {
    return '$this VND';
  }
}
