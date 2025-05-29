String parseCoverArt(String mangaID, String fileName) {
  String baseArt = 'https://uploads.mangadex.org/covers/$mangaID/$fileName';
  return 'https://resizer.f-ck.me/?url=$baseArt';
}
