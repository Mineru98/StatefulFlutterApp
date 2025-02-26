class WebtoonEpisodeModel {
  late final String title, rating, id, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      rating = json['rating'],
      date = json['date'];

  WebtoonEpisodeModel(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    rating = json['rating'];
    date = json['date'];
  }
}
