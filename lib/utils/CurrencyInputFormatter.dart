import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String locale;

  CurrencyInputFormatter({this.locale = "pt_Br"});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String onlyNumbers = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    double value = double.parse(onlyNumbers);

    final formatter = NumberFormat.simpleCurrency(locale: locale);

    String newText = formatter.format(value / 100);

    newText = newText.replaceAll(formatter.currencySymbol, '');

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
