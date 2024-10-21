import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/utils/local_store_dir.dart';
import 'package:afriprize/core/utils/local_stotage.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class OnboardingViewModel extends BaseViewModel {
  final pageController = PageController();

  void init() async {

  }

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
