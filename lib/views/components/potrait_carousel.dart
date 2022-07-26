// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fanmovie/views/components/potrait_carousel_item.dart';
import 'package:flutter/material.dart';


import '../../model/potrait_carousel_item.dart';
import '../../style/app_colors.dart';

class PotraitCarousel extends StatelessWidget {
  final List<PotraitCarouselItem> items;
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
        ListTile(          
          onTap: onTilePressed,
          contentPadding: EdgeInsets.only(left: 0, bottom: 10, top: 10, right: 20),
          trailing: Icon(
            Icons.chevron_right_rounded,
            size: 40,
            color: AppColors.onBackground,
          ),
          title: Text(
            tileTitle,
            style: TextStyle(color: AppColors.onBackground, fontSize: 22),
            textAlign: TextAlign.left,
          ),
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            enableInfiniteScroll: true,
            viewportFraction: .45,
            initialPage: 2,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return PotraitCarouselItemWidget(item: items[itemIndex],);
          },
        ),
      ],
    );
  }
}
