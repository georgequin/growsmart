import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_view.dart';

class OnboardingViewModel extends BaseViewModel {
  final pageController = PageController();
  List<Widget> pages = const [
    PageOne(),
    PageTwo(),
  ];
  int currentPage = 0;

  void onPageChanged(int i) {
    currentPage = i;
    rebuildUi();
  }

  void lastPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
