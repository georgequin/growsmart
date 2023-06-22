import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final String animation;
  final String label;

  const EmptyState({
    required this.animation,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/$animation"),
          verticalSpaceMedium,
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
