import 'package:flutter/material.dart';

import '../common/app_colors.dart';


/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///


class Background extends StatelessWidget {
  final List<Widget> children;

  const Background({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kcPrimaryColor,
        ),
        Image.asset(
          "assets/images/bg.png",
          fit: BoxFit.cover,
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        ...children
      ],
    );
  }
}
