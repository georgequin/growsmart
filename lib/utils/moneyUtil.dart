import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class MoneyUtils extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
      ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = newValue.text.replaceAll(',', '');

    if (int.tryParse(newText) != null) {
      newText = NumberFormat("#,##0", "en_US").format(int.parse(newText));
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String formatAmount(int amount) {
    final formatter = NumberFormat("#,##0", "en_US");

    return "₦${formatter.format(amount)}";
  }

  String getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

  int getAmountAsInt(TextEditingController amount) {
    String text = amount.text.replaceAll(',', ''); // Remove commas
    return int.tryParse(text) ?? 0; // Convert to int, return 0 if null
  }

  String payStackPublicKey = 'pk_test_aae035e8425d5319b6500ef86c0472474a38a5fd';
}
