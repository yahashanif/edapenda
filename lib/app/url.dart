bool isDev = true;
// https://api-dev-awb.sismedika.online/api/v1
<<<<<<< HEAD
String baseUrl = isDev ? 'edapenda.mhmfajar.my.id' : 'api-awb.sismedika.online';

String baseUrlImage =
    'https://edapenda.mhmfajar.my.id/uploads/d-upload-berkas/';
=======
// https://e-dapenda.dapenda.co.id/edapenda-api/
// https://e-dapenda.dapenda.co.id/edapenda-api/edapenda-admin/angkasa/api/d_login/detail
String baseUrl = "m.dapenda.co.id";

String baseUrlImage = 'https://m.dapenda.co.id/uploads/d-upload-berkas/';
>>>>>>> 9f51bdf (commit lagi)

Map<String, String> createHeader({
  required String token,
}) {
  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Api-Key': "76D4D15FEBCA5392A57AE7D0C3E35D37",
  };
}

Map<String, String> createHeaderMultiPart({
  required String token,
}) {
  return {
    'Authorization': 'Bearer $token',
    'Content-Type': "multipart/form-data",
    'Accept': 'application/json',
    'X-Api-Key': "76D4D15FEBCA5392A57AE7D0C3E35D37",
  };
}

Map<String, String> createHeaderWithoutTokenMultiPart() {
  return {
    'Content-Type': "multipart/form-data",
    'Accept': 'application/json',
    'X-Api-Key': "76D4D15FEBCA5392A57AE7D0C3E35D37",
  };
}

Map<String, String> createHeaderWithoutToken() {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Api-Key': "76D4D15FEBCA5392A57AE7D0C3E35D37",
  };
}
