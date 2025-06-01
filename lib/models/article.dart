class Article {
  final int id;
  final String titre;
  final String contenu;
  
  Article({required this.id, required this.titre, required this.contenu});
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'], titre: json['titre'], contenu: json['contenu']);
  }
}
