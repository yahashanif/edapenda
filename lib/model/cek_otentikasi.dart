// To parse this JSON data, do
//
//     final cekOtentikasi = cekOtentikasiFromJson(jsonString);

import 'dart:convert';

CekOtentikasi cekOtentikasiFromJson(String str) =>
    CekOtentikasi.fromJson(json.decode(str));

String cekOtentikasiToJson(CekOtentikasi data) => json.encode(data.toJson());

class CekOtentikasi {
  final bool? otentikasi;
  final int? count;

  CekOtentikasi({
    this.otentikasi,
    this.count,
  });

  factory CekOtentikasi.fromJson(Map<String, dynamic> json) => CekOtentikasi(
        otentikasi: json["otentikasi"] ?? false,
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "otentikasi": otentikasi,
        "count": count,
      };
}
