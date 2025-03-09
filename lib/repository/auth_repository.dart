import 'dart:convert';

import 'package:dapenda/repository/base_repository.dart';

import 'package:hive/hive.dart';

import '../model/data_auth.dart';

class AuthRepository extends BaseRepository {
  Future<User> login({required String edu, required String tokenFcm}) async {
    print("TOKEN");
    final body = {
      'email': 'appflutter@amoorea.id',
      'password': 'password',
      'no_edu': edu,
      "no_fcm": tokenFcm
    };
<<<<<<< HEAD
=======
    print("body");
>>>>>>> 9f51bdf (commit lagi)
    print(body);
    Box tokenBox = Hive.box('token');
    final response = await post(
      body: body,
      service: 'd_login/detail',
    );
    print(response.body);
    if (response.statusCode == 200) {
      tokenBox.put('token', jsonDecode(response.body)['data']['token']);
      return User.fromJson(jsonDecode(response.body)['data']['user']);
      // tokenBox.put('token', dataAuthFromJson(response.body).token!);
      // return dataAuthFromJson(response.body).user!;
    } else {
      throw Exception('Failed to load data');
    }
    // print(edu);
    // if (edu == "193301270001") {
    //   User user = User(
    //     nmPeserta: 'Amoorea',
    //     nmPenerimaMp: 'Amoorea',
    //     noEdu: '12345678',
    //     stsPen: '1',
    //     otentikasiStatus: true,
    //     ucapan: 'Selamat Datang',
    //     urlFoto:
    //         'https://www.gabrielgorgi.com/wp-content/uploads/2019/12/01-1536x1024.jpg',
    //   );
    //   return user;
    // } else {
    //   throw Exception('Failed to load data');
    // }
  }

  Future<User> syncAkun({
    required String token,
  }) async {
    final response = await get(
      token: token,
      service: 'sync',
    );
    print(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']['user']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
