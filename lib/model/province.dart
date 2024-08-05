// To parse this JSON data, do
//
//     final province = provinceFromJson(jsonString);

import 'dart:convert';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  final String? nmProp;
  final String? kdProp;

  Province({
    this.nmProp,
    this.kdProp,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        nmProp: json["nm_prop"],
        kdProp: json["kd_prop"],
      );

  Map<String, dynamic> toJson() => {
        "nm_prop": nmProp,
        "kd_prop": kdProp,
      };
}
