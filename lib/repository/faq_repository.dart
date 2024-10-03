import 'dart:convert';

import 'package:dapenda/model/faq.dart';
import 'package:dapenda/repository/base_repository.dart';

class FAQRepository extends BaseRepository {
  Future<List<FAQModel>> getFAQ({required String token}) async {
    final response = await get(
      token: token,
      service: 'd_faq/all',
    );
    print(response.body);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['data']['d_faq'] as List)
          .map((e) => FAQModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
