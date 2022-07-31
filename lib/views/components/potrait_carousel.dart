// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/views/components/custom_list_tile.dart';
import 'package:fanmovie/views/components/potrait_carousel_item.dart';
import 'package:flutter/material.dart';


import '../../model/potrait_carousel_item.dart';
import '../../style/app_colors.dart';

class PotraitCarousel extends StatefulWidget {
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
  State<PotraitCarousel> createState() => _PotraitCarouselState();
}

class _PotraitCarouselState extends State<PotraitCarousel> {
  final _autoSizeTextGroup = AutoSizeGroup(); // Synchronize the font size of multiple AutoSizeText - Recomendation use in statefull widget

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       CustomListTile(onTilePressed: widget.onTilePressed, tileTitle: widget.tileTitle),
        CarouselSlider.builder(
          options: CarouselOptions(
            enableInfiniteScroll: true,
            viewportFraction: .45,
            initialPage: 2,
          ),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return PotraitCarouselItem(item: widget.items[itemIndex], onPress: widget.onItemPressed, autoSizeTextGroup: _autoSizeTextGroup, );
          },
        ),
      ],
    );
  }
}
