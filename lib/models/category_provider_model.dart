class CategoryProviderDatum {
  CategoryProviderDatum({
    required this.id,
    required this.name,
  });

  int id;

  String name;

  factory CategoryProviderDatum.fromJson(Map<String, dynamic> json) => CategoryProviderDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  @override
  bool operator ==(Object other) => identical(this, other) || other is CategoryProviderDatum && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
