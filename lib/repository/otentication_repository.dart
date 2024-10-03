import 'dart:convert';
import 'dart:io';

import 'package:dapenda/repository/base_repository.dart';

import '../model/cek_otentikasi.dart';

class OtenticationRepository extends BaseRepository {
  Future<bool> postOtentication(
      {required String token,
      required bool verified,
      required File file}) async {
    final body = {
      'verified': verified,
    };
    print(body);
    print("BODY");
    final response = await postFiles(
        token: token, service: 'd_otentikasi/add', body: body, files: [file]);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<CekOtentikasi> cekOtentikasi({required String token}) async {
    final response = await get(token: token, service: 'otentikasi-check');
    print("CEK OTENTIKASI");
    print(response.body);
    if (response.statusCode == 200) {
      return CekOtentikasi.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
