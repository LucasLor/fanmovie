// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/views/components/custom_list_tile.dart';
import 'package:fanmovie/views/components/potrait_carousel_item.dart';
import 'package:flutter/material.dart';


import '../../model/potrait_carousel_item.dart';
import '../../style/app_colors.dart';

class PotraitCarousel extends StatelessWidget {
  final List<PotraitCarouselItemList> items;
  final String tileTitle;
  final VoidCallback onTilePressed;
  final void Function(int) onItemPressed;

  const PotraitCarousel({
    Key? key,
    required this.items,
    required this.tileTitle,
    required this.onTilePressed,
    required this.onItemPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       CustomListTile(onTilePressed: onTilePressed, tileTitle: tileTitle),
        CarouselSlider.builder(
          options: CarouselOptions(
            enableInfiniteScroll: true,
            viewportFraction: .45,
            initialPage: 2,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return PotraitCarouselItem(item: items[itemIndex], onPress: onItemPressed, );
          },
        ),
      ],
    );
  }
}
