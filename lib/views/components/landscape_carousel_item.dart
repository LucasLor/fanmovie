import 'package:fanmovie/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fanmovie/model/landscape_caroseul_item.dart';

class LandscapeCarouselItem extends StatelessWidget {
  final LandscapeCarouselListItems item;
  final int itemCount;
  final int itemIndex;
  final void Function(int) onPress;

  const LandscapeCarouselItem({
    Key? key,
    required this.item,
    required this.itemIndex,
    required this.itemCount,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onPress(item.id),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                image: DecorationImage(
                    image: NetworkImage(item.imageUrl), fit: BoxFit.fill)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
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
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: Text(
                        '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                     Expanded(
                       child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                         child: Text(
                          item.genres.map((e) => e.name).join("  |  "),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: true,
                          ),
                       ),
                     ),
                  ],
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(right: 30, top: 20),
            child: SizedBox(
              width: 55,
              height: 25,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(40))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${itemIndex + 1}',
                      style:  TextStyle(color: AppColors.onPrimary, fontSize: 15),
                    ),
                     Text(
                      '/',
                      style: TextStyle(color: AppColors.onPrimary, fontSize: 15),
                    ),
                    Text(
                      '$itemCount',
                      style:  TextStyle(color: AppColors.onPrimary, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  
}
