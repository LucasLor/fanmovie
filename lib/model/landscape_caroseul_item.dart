import '../services/tmdAPI/model/genre.dart';

class LandscapeCarouselListItems {
  DateTime date;
  String title;
  String imageUrl;
  int id;
  List<Genre> genres;

  LandscapeCarouselListItems({
    required this.date,
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.genres
  });
  
}
