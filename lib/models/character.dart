class Character {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic> thumbnail;
  final Map<String, dynamic> comics;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.comics,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      comics: json['comics'],
    );
  }
}
