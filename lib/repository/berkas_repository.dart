import 'dart:convert';
import 'dart:io';

import 'package:dapenda/model/berkas.dart';
import 'package:dapenda/repository/base_repository.dart';

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
    if (response.statusCode == 200) {
      return Berkas.fromJson(
          jsonDecode(response.body)['data']['d_upload_berkas']);
      // return Berkas.fromJson({
      //   "message": "blalalala",
      //   "status": true,
      //   "alasan": "alasan ya pengen aja",
      //   "verified": true,
      //   "data": {
      //     "no_edu": "EDU12345",
      //     "name": "Dewi Lestari",
      //     "penerima": "Agus Pratama",
      //     "nip": "1987654321",
      //     "no_pensiun": "1987654321",
      //     "jenispen": "Pensiun Normal",
      //     'file1':
      //         "https://thumbs.dreamstime.com/z/ktp-card-indonesian-identity-card-soppeng-indonesia-august-ktp-card-indonesian-identity-card-white-background-254032470.jpg",
      //     'file2':
      //         "https://cdn-2.tstatic.net/batam/foto/bank/images/contoh-kk-yang-sudah-menggunakan-tanda-tangan-elektronik-tte.jpg",
      //   }
      // });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> updateBerkas(
      {required String token,
      required List<File> files,
      required List<String> keys}) async {
    final response = await postFiles(
      token: token,
      service: 'd_upload_berkas/add',
      keys: keys,
      files: files,
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
