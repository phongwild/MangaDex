class CoverArt {
  final String id;
  final String fileName;

  CoverArt({required this.id, required this.fileName});

  factory CoverArt.fromJson(Map<String, dynamic> json) {
    return CoverArt(
      id: json['id'],
      fileName: json['attributes']['fileName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
    };
  }
}