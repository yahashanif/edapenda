import 'dart:convert';

import 'package:dapenda/model/province.dart';
import 'base_repository.dart';

class ProvinceRepository extends BaseRepository {
  Future<List<Province>> getProvince({required String token}) async {
    final response = await get(
      token: token,
      service: 'd_propinsi/all',
    );
    print("response.body");
    print(response.body);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Province.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
