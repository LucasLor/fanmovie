import 'package:flutter/material.dart';
import '../../style/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final String tileTitle;
  final VoidCallback onTilePressed;
  
  const CustomListTile({Key? key, required this.onTilePressed, required this.tileTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return ListTile(          
          onTap: onTilePressed,
          contentPadding: const EdgeInsets.only(left: 0, bottom: 10, top: 10, right: 20),
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
        );
  }
}