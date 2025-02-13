class Relationship {
  String? id;
  String? type;
  Attribute? attributes;

  Relationship({this.id, this.type, this.attributes});

  Relationship.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? Attribute.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }
}

class Attribute {
  String? description;
  String? volume;
  String? fileName;
  String? locale;
  String? createdAt;
  String? updatedAt;
  int? version;

  Attribute(
      {this.description,
      this.volume,
      this.fileName,
      this.locale,
      this.createdAt,
      this.updatedAt,
      this.version});

  Attribute.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    volume = json['volume'];
    fileName = json['fileName'];
    locale = json['locale'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['volume'] = volume;
    data['fileName'] = fileName;
    data['locale'] = locale;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['version'] = version;
    return data;
  }
}
