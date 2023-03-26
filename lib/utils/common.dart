import 'package:flutter/material.dart';

Image getImageCode(String code) {
  var spCode = code.startsWith('XA')
      ? code.toLowerCase()
      : code.substring(0, 2).toLowerCase();
  try {
    return Image.asset(
      'icons/flags/png/$spCode.png',
      package: 'country_icons',
      width: 50,
      height: 50,
    );
  } catch (e) {
    return Image.asset(
      'assets/not404.png',
      width: 50,
      height: 50,
    );
  }
}

DropdownMenuItem<String> currencyCodeItem(String? e) {
  return DropdownMenuItem(
    value: e,
    child: Text(
      e ?? "",
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
    ),
  );
}
