// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fanmovie/helper/util.dart';
import 'package:fanmovie/style/app_colors.dart';
import 'package:fanmovie/views/components/star_rating.dart';
import 'package:flutter/material.dart';
import '../../model/potrait_carousel_item.dart';

class PotraitCarouselItem extends StatelessWidget {
  final PotraitCarouselItemList item;
  final void Function(int) onPress;
  final AutoSizeGroup autoSizeTextGroup;

  const PotraitCarouselItem(
      {Key? key, required this.item, required this.onPress, required this.autoSizeTextGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(item.id),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: NetworkImage(item.imageUrl), fit: BoxFit.fill)),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: AutoSizeText(
                    item.title,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    group: autoSizeTextGroup,
                  ),
                ),
                FittedBox(
                  child: StarRating(
                      color: AppColors.primary,
                      rating: convertStars(item.stars)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
