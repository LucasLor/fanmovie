import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/star_rating.dart';
import '../../services/tmdAPI/model/genre.dart';

class SearchItem2 extends StatelessWidget {
  final String title;
  final double rating;
  final int releaseYear;
  final String imageUrl;
  final String overview;
  final List<Genre> genres;
  final void Function() onPress;
  
  const SearchItem2({
    Key? key,
    required this.title,
    required this.rating,
    required this.releaseYear,
    required this.imageUrl,
    required this.overview,
    required this.genres, required this.onPress,
  }) : super(key: key);

  Widget description() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColors.surface,
      ),
      padding: const EdgeInsets.all(7),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints)  {
          var textStyle = TextStyle(
            fontSize:     16,
            color: AppColors.onSurface,
          );
        return AutoSizeText(
          overview,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: (constraints.maxHeight /18).floor(),
          minFontSize: 14,
        );

      }
      ),
    );
  }

  Widget Conteudo() {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            '$releaseYear',
            style: TextStyle(fontSize: 16, color: AppColors.onBackground),
            textAlign: TextAlign.left,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: AutoSizeText(
              title,
              style: TextStyle(
                fontSize: 25,
                color: AppColors.onBackground,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.clip,
              maxLines: 2,
              minFontSize: 20,
            ),
          ),
          SizedBox(
            width: constraints.maxWidth * .7,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: StarRating(
                color: AppColors.primary,
                rating: rating,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 10),
            child: AutoSizeText(
              genres.map((e) => e.name).join(",  "),
              style: TextStyle(color: AppColors.onBackground, fontSize: 17),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              minFontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPress,
      child: Container(
        height: MediaQuery.of(context).size.width * .7,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: AppColors.background),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.surface),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.fill)),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  
                  children: [
                    Conteudo(),
                    Expanded( child: description()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
