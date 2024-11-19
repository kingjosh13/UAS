class KumparanNews {
  final String creator;
  final String title;
  final String link;
  final String description;
  final String isoDate;
  final String imageUrl;

  KumparanNews({
    required this.creator,
    required this.title,
    required this.link,
    required this.description,
    required this.isoDate,
    required this.imageUrl,
  });

  factory KumparanNews.fromJson(Map<String, dynamic> json) {
    return KumparanNews(
      creator: json['creator'],
      title: json['title'],
      link: json['link'],
      description: json['description'],
      isoDate: json['isoDate'],
      imageUrl: json['image']['large'],
    );
  }
}
