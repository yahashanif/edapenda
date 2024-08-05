// To parse this JSON data, do
//
//     final dataAuth = dataAuthFromJson(jsonString);

import 'dart:convert';

DataAuth dataAuthFromJson(String str) => DataAuth.fromJson(json.decode(str));

String dataAuthToJson(DataAuth data) => json.encode(data.toJson());

class DataAuth {
  final String? token;
  final User? user;

  DataAuth({
    this.token,
    this.user,
  });

  factory DataAuth.fromJson(Map<String, dynamic> json) => DataAuth(
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}
// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

class User {
  final String? nmPeserta;
  final String? nmPenerimaMp;
  final String? noEdu;
  final String? stsPen;
  final String? ucapan;
  final String? urlFoto;
  final String? berkas1;
  final String? berkas2;

  User({
    this.nmPeserta,
    this.nmPenerimaMp,
    this.noEdu,
    this.stsPen,
    this.ucapan,
    this.urlFoto,
    this.berkas1,
    this.berkas2,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        nmPeserta: json["nm_peserta"],
        nmPenerimaMp: json["nm_penerima_mp"],
        noEdu: json["no_edu"],
        stsPen: json["sts_pen"],
        ucapan: json["ucapan"],
        urlFoto: json["url_foto"],
        berkas1: json["berkas_1"],
        berkas2: json["berkas_2"],
      );

  Map<String, dynamic> toJson() => {
        "nm_peserta": nmPeserta,
        "nm_penerima_mp": nmPenerimaMp,
        "no_edu": noEdu,
        "sts_pen": stsPen,
        "ucapan": ucapan,
        "url_foto": urlFoto,
        "berkas_1": berkas1,
        "berkas_2": berkas2,
      };
}
