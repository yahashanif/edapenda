import 'dart:convert';
import 'dart:io';

import 'package:dapenda/model/berkas.dart';
import 'package:dapenda/repository/base_repository.dart';
import 'package:intl/intl.dart';

class BerkasRepository extends BaseRepository {
  Future<Berkas> getBerkas({required String token}) async {
    // final param = {
    //   'no_edu': edu,
    // };
    final response = await get(
      token: token,
      // param: param,
      service: 'd_upload_berkas/detail',
    );
    print("BERKAS DETAIK");
    print(response.body);
    if (response.statusCode == 200) {
      return Berkas.fromJson(
          jsonDecode(response.body)['data']['d_upload_berkas']);
      // return Berkas.fromJson({
      //   "status": 2,
      //   "file_1": "",
      //   "file_2": "",
      //   "alasan": "file ktp tidak jelas dan kk juga buram dan bla bla bla"
      // });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> updateBerkas(
      {required String token,
      required List<File> files,
      required List<String> keys}) async {
    DateTime dateTime = DateTime.now();

    // Format tanggal ke "yyyy-MM-dd"
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    print(formattedDate); // O
    final response = await postFiles(
      token: token,
      service: 'd_upload_berkas/add',
      body: {
        'date': formattedDate
      },
      keys: keys,
      files: files,
    );
    print("RESPONSE FILE");
    print(files);
    print(keys);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
