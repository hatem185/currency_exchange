/// code : 200
/// disclaimer : "Usage subject to terms: https://currencybeacon.com/terms"

class Meta {
  int? code;
  String? disclaimer;

  Meta({this.code, this.disclaimer});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    disclaimer = json['disclaimer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['disclaimer'] = disclaimer;
    return data;
  }

  @override
  String toString() => 'Meta(code: $code, disclaimer: $disclaimer)';
}