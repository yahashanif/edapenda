// To parse this JSON data, do
//
//     final pendataanFotoMatrik = pendataanFotoMatrikFromJson(jsonString);

import 'dart:convert';

PendataanFotoMatrik pendataanFotoMatrikFromJson(String str) =>
    PendataanFotoMatrik.fromJson(json.decode(str));

String pendataanFotoMatrikToJson(PendataanFotoMatrik data) =>
    json.encode(data.toJson());

class PendataanFotoMatrik {
  final String? idPesertaFoto;
  final String? noEdu;
  final String? foto;
  final String? matriks;
  final DateTime? createDate;
  final String? status;
  final String? verified;
  final String? verifiedBy;
  final String? verifiedDate;

  PendataanFotoMatrik({
    this.idPesertaFoto,
    this.noEdu,
    this.foto,
    this.matriks,
    this.createDate,
    this.status,
    this.verified,
    this.verifiedBy,
    this.verifiedDate,
  });

  factory PendataanFotoMatrik.fromJson(Map<String, dynamic> json) =>
      PendataanFotoMatrik(
        idPesertaFoto: json["id_peserta_foto"],
        noEdu: json["no_edu"],
        foto: json["foto"],
        matriks: json["matriks"],
        createDate: json["create_date"] == null
            ? null
            : DateTime.parse(json["create_date"]),
        status: json["status"],
        verified: json["verified"],
        verifiedBy: json["verified_by"],
        verifiedDate: json["verified_date"],
      );

  Map<String, dynamic> toJson() => {
        "id_peserta_foto": idPesertaFoto,
        "no_edu": noEdu,
        "foto": foto,
        "matriks": matriks,
        "create_date": createDate?.toIso8601String(),
        "status": status,
        "verified": verified,
        "verified_by": verifiedBy,
        "verified_date": verifiedDate,
      };
}
