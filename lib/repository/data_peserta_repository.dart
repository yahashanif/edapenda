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
      return DataPeserta.fromJson(
          jsonDecode(response.body)['data']['d_pensiunan']);
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
    required String npwp,
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
    print(body);
    final response =
        await post(service: 'd_pensiunan/update', token: token, body: body);
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }
}
