class SubCategory {
  final String name;
  final String desciption;

  SubCategory({required this.name, required this.desciption});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(name: json["name"], desciption: json["description"]);
  }
}
