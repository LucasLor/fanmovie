// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:fanmovie/style/app_colors.dart';

class CustomTryAgain extends StatelessWidget {
  final void Function() onTryAgainPress;

  const CustomTryAgain({
    Key? key,
    required this.onTryAgainPress,
  }) : super(key: key);
  
 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child:  Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
          Icon(Icons.sentiment_dissatisfied, size: MediaQuery.of(context).size.width * .40, color: AppColors.surface,),
          TextButton(onPressed: onTryAgainPress, child: Text('Algo saiu errado\nTentar Novamente', textAlign: TextAlign.center ,style: TextStyle(color: AppColors.onBackground)))
        ],)
      ),
    );
  }
}
