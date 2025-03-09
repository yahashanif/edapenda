import 'dart:convert';
<<<<<<< HEAD
import 'dart:developer';
=======
>>>>>>> 9f51bdf (commit lagi)
import 'dart:io';

import 'package:http/http.dart' as http;

import '../app/url.dart';

class BaseRepository {
  Future<http.Response> post({
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    required String service,
    String? token,
  }) async {
    try {
      // log("baseUrl");
      print(baseUrl);
      print(service);
      // log(service);
      // log(jsonEncode(body));
      // log(body.toString());
      // Log(body);
<<<<<<< HEAD
      final url = param != null
          ? Uri.https(baseUrl, "/angkasa/api/${service}", param)
          : Uri.https(baseUrl, "/angkasa/api/${service}");
=======
      service = "/edapenda/api/$service";
      final url = param != null
          ? Uri.https(baseUrl, service, param)
          : Uri.https(baseUrl, service);
>>>>>>> 9f51bdf (commit lagi)
      // print(createHeader(token: token!, url: service, method: "POST"));
      // print(createHeaderWithoutToken(url: service, method: 'POST'));
      print("url");
      print(url);
      final response = await http.post(url,
          body: body != null ? jsonEncode(body) : null,
          headers: token != null
              ? createHeader(
                  token: token,
                )
              : createHeaderWithoutToken());
      print(response.body);
      return response;
    } catch (e) {
      // Log(e);
      throw Exception(e.toString());
    }
  }

  Future<http.Response> postFiles({
    required String service,
    required List<File> files,
    List<String>? keys,
    Map<String, dynamic>? body,
    Map<String, dynamic>? param,
    String? token,
  }) async {
<<<<<<< HEAD
    try {
      final url = param != null
          ? Uri.https(baseUrl, "/angkasa/api/$service", param)
          : Uri.https(baseUrl, "/angkasa/api/$service");
=======
    service = "/edapenda/api/$service";

    try {
      final url = param != null
          ? Uri.https(baseUrl, service, param)
          : Uri.https(baseUrl, service);
>>>>>>> 9f51bdf (commit lagi)

      // Prepare multipart request
      var request = http.MultipartRequest('POST', url);

      // Add files to multipart
      for (var i = 0; i < files.length; i++) {
        var file = files[i];
        //  final mimeType =
        //   lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])!.split('/');
        print(file.path);
        if (keys != null) {
          request.files.add(
            await http.MultipartFile.fromPath(keys[i], file.path),
          );
        }
        request.files.add(
          await http.MultipartFile.fromPath('foto', file.path),
        );
      }

      // Add headers
      request.headers.addAll(token != null
          ? createHeaderMultiPart(token: token)
          : createHeaderWithoutTokenMultiPart());

      // Add other fields in the body if needed
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      print(request.fields);

      // Send request
      var streamedResponse = await request.send();

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<http.Response> get({
    bool isParse = false,
    Map<String, dynamic>? param,
    required String service,
    String? token,
  }) async {
<<<<<<< HEAD
    try {
      // Log("service");
      print(service);
      print(Uri.https(baseUrl, service, param));
      final url = param != null
          ? Uri.https(baseUrl, "/angkasa/api/${service}", param)
          : Uri.https(baseUrl, "/angkasa/api/${service}");
=======
    service = "/edapenda/api/$service";

    try {
      // Log("service");
      print(service);

      print(Uri.https(baseUrl, service, param));
      final url = param != null
          ? Uri.https(baseUrl, service, param)
          : Uri.https(baseUrl, service);
>>>>>>> 9f51bdf (commit lagi)
      print(url.toString());
      final response = await http.get(isParse ? Uri.parse(service) : url,
          headers: token != null
              ? createHeader(
                  token: token,
                )
              : createHeaderWithoutToken());

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> put({
    Map<String, dynamic>? body,
    required String service,
    String? token,
  }) async {
<<<<<<< HEAD
=======
    service = "/edapenda/api/$service";

>>>>>>> 9f51bdf (commit lagi)
    try {
      final url = Uri.https(baseUrl, service, {'_method': 'PUT'});

      //  Uri url = Uri.https(
      //     baseUrl, '$apiVersion/invoices/$invoiceId', {'_method': 'PUT'});
      // Log(url);
      // Map<String, String> headers = createHeader(user.token);

      // Log('body invoice update $body');

      final response = await http.post(url,
          body: body != null ? jsonEncode(body) : null,
          headers: token != null
              ? createHeader(
                  token: token,
                )
              : createHeaderWithoutToken());

      // log(response.body);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> delete({
    Map<String, dynamic>? param,
    required String service,
    String? token,
  }) async {
<<<<<<< HEAD
=======
    service = "/edapenda/api/$service";

>>>>>>> 9f51bdf (commit lagi)
    try {
      // Log("Delete");
      // Log(Uri.https(baseUrl, service, param));
      final url = param != null
          ? Uri.https(baseUrl, service, param)
          : Uri.https(baseUrl, service);
      final response = await http.delete(url,
          headers: token != null
              ? createHeader(
                  token: token,
                )
              : createHeaderWithoutToken());

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
