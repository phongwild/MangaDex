import 'dart:convert';

String parseCoverArt(String mangaID, String fileName) {
  final url = 'https://uploads.mangadex.org/covers/$mangaID/$fileName.256.jpg';
  final encoded = base64Encode(utf8.encode(url));
  final proxyUrl = 'https://services.f-ck.me/v1/image/$encoded';
  return proxyUrl;
}
