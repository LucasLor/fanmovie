import 'package:flutter/material.dart';
import '../../style/app_colors.dart';

class FakeSearchBox extends StatelessWidget {
  final VoidCallback onPress;

  const FakeSearchBox({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero, primary: Colors.transparent),
        onPressed: onPress,
        child: SizedBox(
          height: 61,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: AppColors.surface),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Procurar...',
                      style:
                          TextStyle(color: AppColors.onPrimary, fontSize: 20),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: AppColors.onSurface,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
