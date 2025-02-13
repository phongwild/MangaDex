class ChapterData {
  final String baseUrl;
  final String hash;
  final List<String> data;

  ChapterData({
    required this.baseUrl,
    required this.hash,
    required this.data,
  });

  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      baseUrl: json['baseUrl'] as String,
      hash: json['chapter']['hash'] as String,
      data: List<String>.from(json['chapter']['data'] as List),
    );
  }
}
