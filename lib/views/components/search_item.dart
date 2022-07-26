// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/star_rating.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final double rating;
  final int releaseYear;
  final String imageUrl;
  final String overview;

  const SearchItem({
    Key? key,
    required this.title,
    required this.rating,
    required this.releaseYear,
    required this.imageUrl,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: AppColors.surface),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Container(
            width: 130,
            margin: EdgeInsets.only(right: 12),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
               border: Border.all(width: 1.5, color: AppColors.surface),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.fitWidth)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '$releaseYear',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.onBackground                    
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.bold                           
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                StarRating(color: AppColors.primary, rating: rating,),
                Text(
                  overview,
                  style: TextStyle(fontSize: 22, color: AppColors.onBackground),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
