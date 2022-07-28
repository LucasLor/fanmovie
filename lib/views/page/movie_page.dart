// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fanmovie/helper/date_helper.dart';
import 'package:fanmovie/services/tmdAPI/model/movie_details.dart';
import 'package:fanmovie/services/tmdAPI/movie_services.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/custom_future_builder.dart';
import 'package:flutter/material.dart';

import '../../services/tmdAPI/model/cast.dart';
import '../../services/tmdAPI/model/genre.dart';

class ScreenArgs {
  final int movieID;
  ScreenArgs({
    required this.movieID,
  });
}

class MoviePage extends StatelessWidget {
  MoviePage({Key? key}) : super(key: key);

  final MovieService ms = MovieService();

  Future<MovieDetails> _fetchData(int movieID) async {
    return await ms.getDetails(movieID);
  }

  Widget HeaderBackgroundImage(String backgroundUrl) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(backgroundUrl), fit: BoxFit.fitHeight)),
    );
  }

  Widget HeaderFadeBackgroundImage() {
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

  Widget ListGenresItem(Genre genre, context){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Center(
          child: Text(
            genre.name,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.primary
            ),  
          ),
        ),
      );
  }

  Widget Genres(List<Genre> genres) {
    return ListView.builder(
      itemCount: genres.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (coontext, index)=> ListGenresItem(genres[index], coontext) ,
    );
  }

  Widget castItem(BuildContext context, Cast item){
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1000)),
                image: DecorationImage(
                    image: NetworkImage(item.profilePath), fit: BoxFit.cover),
                ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
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

  Widget movieCastList (List<Cast> cast){
    return ListView.builder(
      itemCount: cast.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => castItem(context, cast[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenArgs args = ScreenArgs(
        movieID:
            1771); // ModalRoute.of(context)!.settings.arguments as ScreenArgs ;

    return CustomFutureBuilder<MovieDetails>(
      future: _fetchData(args.movieID),
      onComplete: (context, data) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: HeaderFadeBackgroundImage(),
                  background: HeaderBackgroundImage(data.backdropPath),
                  centerTitle: false,
                  titlePadding: EdgeInsets.all(0),
                ),
                backgroundColor: AppColors.background,
                pinned: true,
                expandedHeight: 500,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([

                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Text(
                          data.releaseDate,
                          style: TextStyle(
                            color: AppColors.onBackground,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
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

                  
                  Container(height: 40, margin: EdgeInsets.only(top: 15), child: Genres(data.genres)),


                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        color: AppColors.onBackground,
                        fontSize: 30,
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
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Crew',
                      style: TextStyle(
                        color: AppColors.onBackground,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    height: 300,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: movieCastList(data.credits.cast),
                  ),












                  Container(
                    width: 1000,
                    height: 1000,
                    color: AppColors.background,
                  ),
                  Container(
                    width: 1000,
                    height: 1000,
                    color: Colors.green,
                  ),
                  Container(
                    width: 1000,
                    height: 1000,
                    color: Colors.black,
                  ),
                ])),
              )
            ],
          ),
        );
      },
    );
  }
}
