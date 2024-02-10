import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

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
      body: Container(
        color: Colors.white, // Set the background color to white
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: viewModel.pageController,
                  onPageChanged: viewModel.onPageChanged,
                  children: viewModel.pages,
                ),
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: SubmitButton(
                      isLoading: false,
                      label:
                          "Get Started",
                      submit: () {
                          locator<NavigationService>().clearStackAndShow(Routes.homeView);
                      },
                      color: kcPrimaryColor,
                      boldText: true,
                    ),
                  ),
                  // Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: List.generate(
                  //         viewModel.pages.length,
                  //         (index) =>
                  //             _indicator(viewModel.currentPage == index)),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
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

  Widget indicator(bool selected) {
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

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  PageOneState createState() => PageOneState();
}

class PageOneState extends State<PageOne> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      "assets/videos/onboarding.mp4",
    )..initialize().then((_) {
      // Ensure the first frame is shown and set the video to loop.
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller), // Use VideoPlayer widget
          ),
          verticalSpaceLarge,
          Image.asset("assets/images/onboarding1.png"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


// @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Image.asset("assets/images/on1.png"),
  //         verticalSpaceLarge,
  //         const Text(
  //           "The best of both worlds",
  //           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //         ),
  //         verticalSpaceSmall,
  //         const Text(
  //           "Enjoy convenient shopping and the thrill of winning big!",
  //           style: TextStyle(fontSize: 16),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

// class PageTwo extends StatelessWidget {
//   const PageTwo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset("assets/images/on2.png"),
//           verticalSpaceLarge,
//           const Text(
//             "but that’s not all!",
//             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//           ),
//           verticalSpaceSmall,
//           const Text(
//             "with every purchase, you'll also receive a unique lottery number that gives you the chance to win exciting prizes.",
//             style: TextStyle(fontSize: 16),
//           )
//         ],
//       ),
//     );
//   }
// }
