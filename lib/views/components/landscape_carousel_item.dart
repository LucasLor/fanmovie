// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fanmovie/model/landscape_caroseul_item.dart';

class LandscapeCarouselItemWidget extends StatelessWidget {
  final LandscapeCarouselItem item;
  final int itemCount;
  final int itemIndex;

  const LandscapeCarouselItemWidget({
    Key? key,
    required this.item,
    required this.itemIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  const Text(
                    'ação | aventura | romance',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.left,
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
              decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${itemIndex + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const Text(
                    '/',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    '$itemCount',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
