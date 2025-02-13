class Tag {
  final String id;
  final _TagAttributes attributes;

  Tag({
    required this.id,
    required this.attributes,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String? ?? 'unknown_id',
      attributes: _TagAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class _TagAttributes {
  final String name;
  final String group;

  _TagAttributes({
    required this.name,
    required this.group,
  });

  factory _TagAttributes.fromJson(Map<String, dynamic> json) {
    return _TagAttributes(
      name: (json['name'] as Map<String, dynamic>?)?['en'] ?? "No name",
      group: json['group'] ?? "Unknown",
    );
  }
}
