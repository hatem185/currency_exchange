import 'dart:convert';

import 'package:flutter/services.dart';

class ReadCurrencyCodeFromJson {
  static late final List<Map<String, String>> currencySymbols;

 static Future<void> readCurrencyJsonFile() async {
    try {
      String jsonString = await rootBundle
          .loadString('assets/json_files/currency_symbols.json');
      currencySymbols = json.decode(jsonString);
    } catch (e) {
      print('Error parsing JSON file');
    }
  }
}
