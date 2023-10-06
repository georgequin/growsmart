import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'onboarding_viewmodel.dart';

class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              viewModel.currentPage == 0
                  ? InkWell(
                      onTap: () {
                        locator<NavigationService>().navigateToHomeView();
                      },
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Skip",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              viewModel.currentPage == 1
                  ? InkWell(
                      onTap: () {
                        viewModel.pageController.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear);
                        if (kDebugMode) {
                          print("clicked back button");
                        }
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: PageView(
                  controller: viewModel.pageController,
                  onPageChanged: viewModel.onPageChanged,
                  children: viewModel.pages,
                ),
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: SubmitButton(
                      isLoading: false,
                      label:
                          viewModel.currentPage == 0 ? "Next" : "Get Started",
                      submit: () {
                        if (viewModel.currentPage == 0) {
                          viewModel.pageController.nextPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.linear);
                        } else {
                          locator<NavigationService>().navigateToHomeView();
                        }
                      },
                      color: kcPrimaryColor,
                      boldText: true,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          viewModel.pages.length,
                          (index) =>
                              _indicator(viewModel.currentPage == index)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(OnboardingViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  OnboardingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnboardingViewModel();

  Widget _indicator(bool selected) {
    return Container(
      margin: const EdgeInsets.all(3),
      height: selected ? 5 : 8,
      width: selected ? 20 : 8,
      decoration: BoxDecoration(
        color: selected ? kcPrimaryColor : kcLightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/on1.png"),
          verticalSpaceLarge,
          const Text(
            "The best of both worlds",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          const Text(
            "Enjoy convenient shopping and the thrill of winning big!",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/on2.png"),
          verticalSpaceLarge,
          const Text(
            "but that’s not all!",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          const Text(
            "with every purchase, you'll also receive a unique lottery number that gives you the chance to win exciting prizes.",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
