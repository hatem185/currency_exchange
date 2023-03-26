import 'meta_model.dart';
/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class Rate {
  String? currencyCode;
  double? rate;

  Rate({this.currencyCode, this.rate});

  Rate.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currencyCode'] = currencyCode;
    data['rate'] = rate;
    return data;
  }

  @override
  String toString() => 'Rate{currencyCode: $currencyCode, reate: $rate}';
}

class LatestResponse {
  DateTime? date;
  String? base;
  List<Rate?>? rates;

  LatestResponse({this.date, this.base, this.rates});

  LatestResponse.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    base = json['base'];
    if (json['rates'] != null) {
      rates = <Rate>[];
      json['rates'].forEach((key, value) {
        rates!.add(Rate.fromJson({"currencyCode": key, "rate": value}));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date.toString();
    data['base'] = base;
    rates?.forEach((e) => data['rates'][e?.currencyCode] = e?.rate);
    return data;
  }

  @override
  String toString() => 'LatestResponse{base: $base, rates: $rates}';
}

class LatestModel {
  Meta? meta;
  LatestResponse? response;

  LatestModel({this.meta, this.response});

  LatestModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta?.fromJson(json['meta']) : null;
    response = json['response'] != null
        ? LatestResponse?.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['meta'] = meta!.toJson();
    data['response'] = response!.toJson();
    return data;
  }

  @override
  String toString() => 'LatestModel{meta: $meta, response: $response}';
}
