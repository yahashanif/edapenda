// To parse this JSON data, do
//
//     final FAQModel = faqFromJson(jsonString);

import 'dart:convert';

FAQModel faqFromJson(String str) => FAQModel.fromJson(json.decode(str));

String faqToJson(FAQModel data) => json.encode(data.toJson());

class FAQModel {
  final String? idFaq;
  final String? tanya;
  final String? jawab;
  final String? status;

  FAQModel({
    this.idFaq,
    this.tanya,
    this.jawab,
    this.status,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
        idFaq: json["id_faq"],
        tanya: json["tanya"],
        jawab: json["jawab"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id_faq": idFaq,
        "tanya": tanya,
        "jawab": jawab,
        "status": status,
      };
}
