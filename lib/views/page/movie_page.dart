// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fanmovie/helper/date_helper.dart';
import 'package:fanmovie/services/tmdAPI/model/crew.dart';
import 'package:fanmovie/services/tmdAPI/model/movie_details.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';
import 'package:fanmovie/views/components/custom_try_again.dart';
import 'package:flutter/material.dart';
import 'package:fanmovie/helper/intl_helper.dart' as intLHelper;

import '../../model/potrait_carousel_item.dart';
import '../../routes/routes.dart';
import '../../services/tmdAPI/model/cast.dart';
import '../../services/tmdAPI/model/genre.dart';
import '../../services/tmdAPI/model/movie.dart';
import '../components/potrait_carousel.dart';
import 'view_more_page.dart';

class MoviePageScreenArgs {
  final int movieID;
  MoviePageScreenArgs({
    required this.movieID,
  });
}

class MoviePage extends StatefulWidget {

  MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final MovieService ms = MovieService();
  late List<Movie> recommendations;

  Future<MovieDetails> _fetchData(int movieID) async {
    var recommendationsResult = await ms.getRecommendations(movieID);
    recommendations = recommendationsResult.results;
    var detailsResult =  await ms.getDetails(movieID);

    // Caso não tenha um diretor cria um 'default'
    if(!detailsResult.credits!.crew.any((element) => element.job.toLowerCase() == 'director')){
      detailsResult.credits!.crew.add(Crew(adult: false, gender: 0, id: 0, knownForDepartment: '', name: '-', originalName: '', popularity: 0, creditId: '', department: '', job: 'Director'));
    }

    return detailsResult;
  }

  Widget headerBackgroundImage(String backgroundUrl) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(backgroundUrl), fit: BoxFit.fitHeight)),
    );
  }

  Widget headerImageGradientOverlay() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.black.withAlpha(0), AppColors.background],
            ),
          ),
        ),
      ],
    );
  }

  Widget genreTagItem(Genre genre, context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.primary),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(
          genre.name,
          style: TextStyle(fontSize: 15, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget genreTagList(List<Genre> genres) {
    return ListView.builder(
      itemCount: genres.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (coontext, index) => genreTagItem(genres[index], coontext),
    );
  }

  Widget castItem(BuildContext context, Cast item) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all( Radius.circular(1000)),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(item.profilePath), fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              item.name,
              style: TextStyle(fontSize: 16, color: AppColors.primary),
              maxLines: 2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget movieCastList(List<Cast> cast) {  
    return ListView.builder(
      itemCount: cast.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => castItem(context, cast[index]),
    );
  }

  Widget information(String imageUrl, String title, String status, num score, num budget, num revenue, String director ) {
    Widget getInfoItem(String title, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.onBackground, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(color: AppColors.onBackground),
          ),
        ],
      );
    }

    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: AppColors.surface),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.fill)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  getInfoItem("Título Original", title),
                  getInfoItem("Aprovação", '${score.floor()}%'),
                  getInfoItem("Status", status),
                  getInfoItem("Orçamento", intLHelper.getCurrency(budget)),
                  getInfoItem("Receita", intLHelper.getCurrency(revenue)),
                  getInfoItem("Diretor", director),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

   void openMovieDetails(int id, context){
      Navigator.pushNamed(context, Routes.movieDetails, arguments: MoviePageScreenArgs(movieID: id));
   }

  void openCategoryMovies(MovieEndPoints endpoint, String title, int movieId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ViewMore(
              args: ViewMorePageScreenArgs(endpoint: endpoint, title: title, movieId: movieId),
            )));
  }

  Widget _createPotraitCarrousel(String label, List<Movie> items, MovieEndPoints endpoint, BuildContext context, int movieId) {
    return PotraitCarousel(
      items: items
          .map((e) => PotraitCarouselItemList(
              imageUrl: e.posterPath, title: e.title, stars: e.voteAverage, id: e.id))
          .toList(),
      tileTitle: label,
      onItemPressed: (id)=> openMovieDetails(id, context),
      onTilePressed: ()=> openCategoryMovies(endpoint, label, movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    MoviePageScreenArgs args = ModalRoute.of(context)!.settings.arguments as MoviePageScreenArgs;

    return CustomFutureBuilder<MovieDetails>(
      future: _fetchData(args.movieID),
      onComplete: _onComplete,
      onError: (context, error) => CustomTryAgain(onTryAgainPress: refreshPage),
    );
  }

  Scaffold _onComplete(BuildContext context, MovieDetails data) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: headerImageGradientOverlay(),
                background: headerBackgroundImage(data.backdropPath),
                centerTitle: false,
                titlePadding: const EdgeInsets.all(0),
              ),
              backgroundColor: AppColors.background,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * .5,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    children: [
                      Text(
                        intLHelper.formatDAtetiem(data.releaseDate),
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          formatDuration(data.runtime),
                          style: TextStyle(
                            color: AppColors.onBackground,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  data.title,
                  style: TextStyle(
                    color: AppColors.onBackground,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                    height: 30,
                    margin: const EdgeInsets.only(top: 15),
                    child: genreTagList(data.genres)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Sinopse',
                    style: TextStyle(
                      color: AppColors.onBackground,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  data.overview,
                  style: TextStyle(
                    color: AppColors.onBackground,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Elenco Principal',
                    style: TextStyle(
                      color: AppColors.onBackground,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: movieCastList(data.credits!.cast)
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: information(data.posterPath, data.originalTitle, data.status, data.voteAverage *10, data.budget, data.revenue, data.credits!.crew.firstWhere((element) => element.job == 'Director').name)
                ),
                _createPotraitCarrousel('Recomendações', recommendations, MovieEndPoints.recommendations, context, data.id)
              ])
            ),
            )
          ],
        ),
      );
  }

  void refreshPage()  {
      Navigator.of(context).pop();
  }
}
