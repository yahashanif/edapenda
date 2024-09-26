import 'dart:convert';

import 'package:dapenda/model/data_peserta.dart';
import 'package:dapenda/repository/base_repository.dart';

class DataPesertaRepository extends BaseRepository {
  Future<DataPeserta> getDataPeserta({required String token}) async {
    final response = await get(
      token: token,
      service: 'd_pensiunan/detail',
    );
    print(response.body);
    if (response.statusCode == 200) {
      String jsonString = '''
    {
      "message": "success",
      "data": {
        "d_pensiunan": {
          "nm_penerima_mp": "",
          "no_edu": "196406223993",
          "sts_kel_akhir": "Duda",
          "sts_mp": "Sendiri",
          "alamat":
              "Jl. Karya Bakti No. 37 LK VII Medan Kel. Pangkalan Mansyur Kec. Medan Johor Kota Medan",
          "kd_prop": "1",
          "kode_pos": "20143",
          "no_telp": "082290342356",
          "no_hp": "082290342356",
          "npwp": "1384646464",
          "nik": "13070102030000046",
          "tempat_lahir": "",
          "tgl_lahir": "2006-01-01",
          "nm_bank_peserta": "Bank Mandiri KC Medan Imam Bonjol",
          "no_rek_peserta": "105-00-0435843-2",
          "nm_rek_peserta": "Suparlan",
          "kegiatan_pensiun": "tidur",
          "jns_pensiun": "Pensiun Normal",
          "nip": "20000790",
          "name_kerabat": "hanif",
          "telp_kerabat": "082290342356"
        }
      }
    }
  ''';
      return DataPeserta.fromJson(
          jsonDecode(response.body)['data']['d_pensiunan']);
      // return DataPeserta.fromJson(
      //     jsonDecode(jsonString)['data']['d_pensiunan']);
    } else {
      throw Exception('Failed to load data');
    }
    // return DataPeserta(
    //   nmPenerimaMp: 'Amoorea',
    //   noEdu: '12345678',
    //   stsKelAkhir: '1',
    //   alamat: 'Jl. Jend. Sudirman No. 1',
    //   kdProp: '35',
    //   kodePos: '12345',
    //   noTelp: '081234567890',
    //   noHp: '081234567890',
    //   npwp: '1234567890',
    //   nik: '1234567890',
    //   tempatLahir: 'Jakarta',
    //   tglLahir: DateTime.now(),
    //   nmBankPeserta: 'Bank ABC',
    //   noPesiun: '1234567890',
    //   noRekPeserta: '1234567890',
    //   cabang: 'Jl. Jend. Sudirman',
    //   nmRekPeserta: 'Amoorea',
    //   kegiatanPensiun: 'Pensiun',
    //   jnsPensiun: '1',
    //   nip: '1234567890',
    // );
  }

  Future<bool> updateDataPeserta({
    required String token,
    required String edu,
    required String nik,
    required String kegiatan,
    required String alamat,
    required String telp,
    required String hp,
    required String prop,
    String npwp = '',
    required String pos,
    required String nameKerabat,
    required String telpKerabat,
  }) async {
    final body = {
      'no_edu': edu,
      'kegiatan_pensiun': kegiatan,
      'alamat': alamat,
      'telp': telp,
      'hp': hp,
      'pos': pos,
      'prop': prop,
      'nik': nik,
      'npwp': npwp,
      'name_kerabat': nameKerabat,
      'telp_kerabat': telpKerabat,
    };
    print("body");
    print(body);
    final response =
        await post(service: 'd_pensiunan/update', token: token, body: body);
    print("response.body");
    print(response.statusCode);
    print(response.statusCode != 200);
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
