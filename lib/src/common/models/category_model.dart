class Category {
  final String name;
  final String emoji;

  Category({required this.name, required this.emoji});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"], emoji: json["emoji"]);
  }
}
