// To parse this JSON data, do
//
//     final berkas = berkasFromJson(jsonString);

import 'dart:convert';

Berkas berkasFromJson(String str) => Berkas.fromJson(json.decode(str));

String berkasToJson(Berkas data) => json.encode(data.toJson());

class Berkas {
  final String? ktp;
  final String? kk;
  final String? npwp;
  final String? suratKeteranganBelumMenikah;
  final String? suratKeteranganMasihKuliah;
  final String? suratKeteranganBelumBekerja;
  final int? status;
  final String? alasan;

  Berkas({
    this.ktp,
    this.kk,
    this.npwp,
    this.suratKeteranganBelumMenikah,
    this.suratKeteranganMasihKuliah,
    this.suratKeteranganBelumBekerja,
    this.status,
    this.alasan,
  });

  factory Berkas.fromJson(Map<String, dynamic> json) => Berkas(
        ktp: json["ktp"],
        kk: json["kk"],
        npwp: json["npwp"],
        suratKeteranganBelumMenikah: json["surat_keterangan_belum_menikah"],
        suratKeteranganMasihKuliah: json["surat_keterangan_masih_kuliah"],
        suratKeteranganBelumBekerja: json["surat_keterangan_belum_bekerja"],
        status: json["status"],
        alasan: json["alasan"],
      );

  Map<String, dynamic> toJson() => {
        "ktp": ktp,
        "kk": kk,
        "npwp": npwp,
        "surat_keterangan_belum_menikah": suratKeteranganBelumMenikah,
        "surat_keterangan_masih_kuliah": suratKeteranganMasihKuliah,
        "surat_keterangan_belum_bekerja": suratKeteranganBelumBekerja,
        "status": status,
        "alasan": alasan,
      };
}
