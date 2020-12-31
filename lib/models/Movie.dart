class Movie {
  String id;
  String title;
  String image;
  String titleType;
  int year;
  int runningTimeInMinutes;
  String releaseDate;
  double rating;
  List<String> genres;
  String summary;
  double userRating = 0.0;

  Movie({
    this.id,
    this.title,
    this.image,
    this.titleType,
    this.year,
    this.runningTimeInMinutes,
    this.releaseDate,
    this.rating,
    this.genres,
    this.summary,

  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title']['title'] as String,
      image: json['title']['image']['url'] as String,
      titleType: json['title']['titleType'] as String,
      releaseDate: json['releaseDate'] as String,
      year: json['title']['year'] as int,
      runningTimeInMinutes: json['title']['runningTimeInMinutes'] as int,
      rating: json['ratings']['rating'] as double,
      summary: json.containsKey('plotOutline') ? json['plotOutline']['text'] as String : "Sorry, got no description for this!",
      genres: List.from(json['genres'])
      //email: json['email'] as String,
    );
  }
}