import 'dart:async';

import 'package:currency_exchange/model/convert_model.dart';
import 'package:currency_exchange/services/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/latest_model.dart';

class CurrencyProvider extends ChangeNotifier {
  Dio? dio;
  var isConverLoading = false;
  // var isConvertError = false;
  String _fromCode = "LYD";
  String _toCode = "USD";
  String _baseLatestRate = "LYD";
  ConvertModel? convertData;
  StreamController<LatestModel> latestRateStream =
      StreamController<LatestModel>();

  CurrencyProvider() {
    print("dio created!");
    dio = Dio(
      BaseOptions(
        contentType: "Application/json",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<void> currencyConverter(
    double amount,
  ) async {
    print("get convert called");
    String url =
        Constants.getConvertEP(from: _fromCode, to: _toCode, amount: amount);
    isConverLoading = true;
    notifyListeners();
    try {
      print("url: $url");
      var response =
          await dio?.get(url, queryParameters: {"api_key": Constants.apiKey});
      print(response);
      Map<String, dynamic> jsonMap = response?.data;
      convertData = ConvertModel.fromJson(jsonMap);
      isConverLoading = false;
      notifyListeners();
    } catch (error) {
      isConverLoading = false;
      // isConvertError = true;

      print(error.toString());
    }
  }

  Future<void> getLatestRates() async {
    print("get convert called");
    String url = Constants.getLatestEP(
      baseC: _baseLatestRate,
      symbols: Constants.getCountryCodesList
          .where((e) => e != _baseLatestRate)
          .toList(),
    );
    print(url);
    try {
      var response =
          await dio?.get(url, queryParameters: {"api_key": Constants.apiKey});
      print("latest: $response");
      Map<String, dynamic> jsonMap = response?.data;
      print(jsonMap);
      latestRateStream.add(LatestModel.fromJson(jsonMap));
    } catch (e) {
      print(e.toString());
      latestRateStream.addError("Error");
    }
  }

  // set latestRateData(LatestModel? latestRateData) {
  //   _latestRateData = latestRateData;
  //   // notifyListeners();
  // }
  //
  // LatestModel? get latestRateData {
  //   return _latestRateData;
  // }

  set baseLatestRate(String code) {
    _baseLatestRate = code;
    notifyListeners();
  }

  String get baseLatestRate => _baseLatestRate;

  set fromCode(String code) {
    _fromCode = code;
    notifyListeners();
  }

  String get fromCode => _fromCode;

  set toCode(String code) {
    _toCode = code;
    notifyListeners();
  }

  String get toCode => _toCode;

  void refresh() {
    notifyListeners();
  }
}
