class WifiModel {
  int index;
  String value;
  WifiModel({
    required this.index,
    required this.value,
  });
  factory WifiModel.fromJson(Map<String, dynamic> json) {
    return WifiModel(
        index: json['index'] ?? 0, value: json["value"] ?? "no data");
  }
  Map<dynamic, dynamic> toJson() => {
        'index': index,
        'value': value,
      };
}
