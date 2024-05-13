class Comic {
  final int id;
  final String title;
  //final String description;
  final Map<String, dynamic> thumbnail;
  final List urls;

  Comic({
    required this.id,
    required this.title,
    //required this.description,
    required this.thumbnail,
    required this.urls,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['resourceURI'].split('/').last);
    return Comic(
        id: id,
        title: json['title'] ?? '',
        //description: json['description'] ?? '',
        thumbnail: json['thumbnail'] ?? {},
        urls: json['urls']);
  }
}
