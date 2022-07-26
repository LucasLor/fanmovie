class Keyword {
  Keyword({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Keyword.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
