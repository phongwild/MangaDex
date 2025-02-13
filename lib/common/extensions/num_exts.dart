import 'package:intl/intl.dart';

extension NumExts on num {
  String stringMoney() {
    final NumberFormat format = NumberFormat("###,###,###");
    String result = format.format(this);
    return result.trim();
  }
  
}
