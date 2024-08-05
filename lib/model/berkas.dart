// To parse this JSON data, do
//
//     final berkas = berkasFromJson(jsonString);

import 'dart:convert';

Berkas berkasFromJson(String str) => Berkas.fromJson(json.decode(str));

String berkasToJson(Berkas data) => json.encode(data.toJson());

class Berkas {
  final String? message;
  final String? alasan;
  final bool? status;
  final bool? verified;
  final String? file1;
  final String? file2;
  // final DataBerkas? data;

  Berkas({
    this.message,
    this.alasan,
    this.status,
    this.verified,
    this.file1,
    this.file2,
    // this.data,
  });

  factory Berkas.fromJson(Map<String, dynamic> json) => Berkas(
        message: json["message"],
        alasan: json["alasan"],
        status: json["status"] == "0" ? false : true,
        // status: false,
        verified: json["verified"] == "0" ? false : true,
        file1: json["file_1"] ?? '',
        file2: json["file_2"] ?? '',

        // data: json["data"] == null ? null : DataBerkas.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "alasan": alasan,
        // "status": status,
        "verified": verified,
        // "data": data?.toJson(),
      };
}

class DataBerkas {
  final String? noEdu;
  final String? noPensiun;
  final String? name;
  final String? penerima;
  final String? nip;
  final String? jenispen;
  final String? file1;
  final String? file2;

  DataBerkas({
    this.noEdu,
    this.noPensiun,
    this.name,
    this.penerima,
    this.nip,
    this.jenispen,
    this.file1,
    this.file2,
  });

  factory DataBerkas.fromJson(Map<String, dynamic> json) => DataBerkas(
        noEdu: json["no_edu"],
        noPensiun: json["no_pensiun"],
        name: json["name"],
        penerima: json["penerima"],
        nip: json["nip"],
        jenispen: json["jenispen"],
        file1: json["file1"],
        file2: json["file2"],
      );

  Map<String, dynamic> toJson() => {
        "no_edu": noEdu,
        "no_pensiun": noPensiun,
        "name": name,
        "penerima": penerima,
        "nip": nip,
        "jenispen": jenispen,
        "file1": file1,
        "file2": file2,
      };
}
