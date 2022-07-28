class Video {
  Video({
    required this.iso_639_1,
    required this.iso_3166_1,
    required this.name,
    required this.key,
    required this.publishedAt,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });
  late final String iso_639_1;
  late final String iso_3166_1;
  late final String name;
  late final String key;
  late final String publishedAt;
  late final String site;
  late final int size;
  late final String type;
  late final bool official;
  late final String id;

  Video.fromJson(Map<String, dynamic> json) {
    iso_639_1 = json['iso_639_1'];
    iso_3166_1 = json['iso_3166_1'];
    name = json['name'];
    key = json['key'];
    publishedAt = json['published_at'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
    official = json['official'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['iso_639_1'] = iso_639_1;
    data['iso_3166_1'] = iso_3166_1;
    data['name'] = name;
    data['key'] = key;
    data['published_at'] = publishedAt;
    data['site'] = site;
    data['size'] = size;
    data['type'] = type;
    data['official'] = official;
    data['id'] = id;
    return data;
  }
}
