import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/model/landscape_caroseul_item.dart';
import 'package:fanmovie/views/components/landscape_carousel_item.dart';
import 'package:flutter/material.dart';

class LandscapeCarousel extends StatelessWidget {
  final List<LandscapeCarouselItem> items;
  const LandscapeCarousel({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 1,
        enableInfiniteScroll: true,
        initialPage: 1,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return LandscapeCarouselItemWidget(
            item: items[itemIndex],
            itemIndex: itemIndex,
            itemCount: items.length);
      },
    );
  }
}
