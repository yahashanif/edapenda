// To parse this JSON data, do
//
//     final pendataanFoto = pendataanFotoFromJson(jsonString);

import 'dart:convert';

PendataanFoto pendataanFotoFromJson(String str) =>
    PendataanFoto.fromJson(json.decode(str));

String pendataanFotoToJson(PendataanFoto data) => json.encode(data.toJson());

class PendataanFoto {
  final bool? status;
  final bool? verified;
  final String? foto;

  PendataanFoto({
    this.status,
    this.verified,
    this.foto,
  });

  factory PendataanFoto.fromJson(Map<String, dynamic> json) => PendataanFoto(
        status: json["status"] == "0"? false : true,
        verified: json["verified"] == "false" ? false : true,
        foto: json["foto"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "verified": verified,
        "foto": foto,
      };
}
