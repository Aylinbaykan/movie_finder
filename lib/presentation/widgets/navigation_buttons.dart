import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class NavigationButtons extends StatelessWidget {
  final PageController controller;
  final IconData icon;
  final bool isLeft;

  const NavigationButtons(
      {super.key,
      required this.controller,
      required this.icon,
      required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? 20 : null,
      right: isLeft ? null : 20,
      child: GestureDetector(
        onTap: () {
          if (isLeft) {
            controller.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            controller.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        },
        child: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.buttonBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
