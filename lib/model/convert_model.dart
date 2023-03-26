// ignore_for_file: public_member_api_docs, sort_constructors_first
/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/



import 'latest_model.dart';
import 'meta_model.dart';

class ConvertResponse {
  int? timestamp;
  String? date;
  String? from;
  String? to;
  int? amount;
  double? value;

  ConvertResponse(
      {this.timestamp, this.date, this.from, this.to, this.amount, this.value});

  ConvertResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    date = json['date'];
    from = json['from'];
    to = json['to'];
    amount = json['amount'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['date'] = date;
    data['from'] = from;
    data['to'] = to;
    data['amount'] = amount;
    data['value'] = value;
    return data;
  }

  @override
  String toString() {
    return 'Response(timestamp: $timestamp, date: $date, from: $from, to: $to, amount: $amount, value: $value)';
  }
}

class ConvertModel {
  Meta? meta;
  ConvertResponse? response;

  ConvertModel({this.meta, this.response});

  ConvertModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta?.fromJson(json['meta']) : null;
    response =
        json['response'] != null ? ConvertResponse?.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meta'] = meta!.toJson();
    data['response'] = response!.toJson();
    return data;
  }

  @override
  String toString() => 'ConvertCurrency(meta: $meta, response: $response)';
}
