class Chapter {
  final String id;
  final String? volume;
  final String? chapter;
  final String? title;
  final String translatedLanguage;
  final String? externalUrl;
  final DateTime publishAt;
  final DateTime readableAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int pages;
  final int version;

  Chapter({
    required this.id,
    this.volume,
    this.chapter,
    this.title,
    required this.translatedLanguage,
    this.externalUrl,
    required this.publishAt,
    required this.readableAt,
    required this.createdAt,
    required this.updatedAt,
    required this.pages,
    required this.version,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      volume: json['attributes']['volume'],
      chapter: json['attributes']['chapter'],
      title: json['attributes']['title'],
      translatedLanguage: json['attributes']['translatedLanguage'],
      externalUrl: json['attributes']['externalUrl'],
      publishAt: DateTime.parse(json['attributes']['publishAt']),
      readableAt: DateTime.parse(json['attributes']['readableAt']),
      createdAt: DateTime.parse(json['attributes']['createdAt']),
      updatedAt: DateTime.parse(json['attributes']['updatedAt']),
      pages: json['attributes']['pages'],
      version: json['attributes']['version'],
    );
  }

  static List<Chapter> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Chapter.fromJson(json)).toList();
  }
}
