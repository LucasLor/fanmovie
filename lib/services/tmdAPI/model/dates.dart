class Dates {
  Dates({
    required this.maximum,
    required this.minimum,
  });
  late final String maximum;
  late final String minimum;

  Dates.fromJson(Map<String, dynamic> json) {
    maximum = json['maximum'];
    minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['maximum'] = maximum;
    data['minimum'] = minimum;
    return data;
  }
}
