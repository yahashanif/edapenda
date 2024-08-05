import 'dart:convert';
import 'dart:io';

import 'package:dapenda/model/pendataan_foto.dart';
import 'package:dapenda/model/peserta_foto_matrik.dart';

import 'base_repository.dart';

class PendataanFotoRepository extends BaseRepository {
  Future<bool> pendataanFotoPost(
      {required String token,
      required List<double> matriks,
      required File file}) async {
    final body = {
      'matriks': matriks,
    };
    final response = await postFiles(
        token: token, service: 'd_peserta_foto/add', body: body, files: [file]);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<PendataanFoto> getPendataanFoto({required String token}) async {
    final response = await get(token: token, service: 'd_peserta_foto/all');
    print(response.body);
    if (response.statusCode == 200) {
      return PendataanFoto.fromJson(
          jsonDecode(response.body)['data']['d_peserta_foto'][0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<PendataanFotoMatrik>> getPendataanFotoMatrik(
      {required String token}) async {
    final response = await get(token: token, service: 'peserta-foto-matriks');
    print(response.body);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['data'] as List)
          .map((e) => PendataanFotoMatrik.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
