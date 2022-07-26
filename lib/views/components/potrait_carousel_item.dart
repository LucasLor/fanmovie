// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fanmovie/helper/util.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fanmovie/model/landscape_caroseul_item.dart';
import 'package:fanmovie/views/components/potrait_carousel.dart';

import '../../model/potrait_carousel_item.dart';

class PotraitCarouselItemWidget extends StatelessWidget {
  final PotraitCarouselItem item;

  const PotraitCarouselItemWidget({
    Key? key,
    required this.item,    
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  image: NetworkImage(item.imageUrl), fit: BoxFit.fill)),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.black.withAlpha(0),
                Colors.black38,
                Colors.black87
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  StarRating(color: AppColors.primary, rating: convertStars(item.stars))
                ],
              ),
              
            ],
          ),
        ),      
      ],
    );
  }
}
