import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../components/empty_state.dart';

class OnboardingView2 extends StatelessWidget {
  const OnboardingView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          title: 'Join the Excitement!',
          video: true,
          description:
          'Every ticket you purchase is your golden ticket to adventure! Imagine the thrill of winning incredible prizes while having fun.',
          imageUrl: "assets/videos/onboarding.mp4",
          bgColor: kcWhiteColor,
        ),
        OnboardingPageModel(
          title: 'Earn Points with Every Ticket!',
          video: false,
          description:
          'Every ticket isn’t just a chance to win; it’s a step towards unlocking exciting rewards! Watch your points stack up as you play.',
          imageUrl: 'second.json',
          bgColor: kcWhiteColor,
        ),
        OnboardingPageModel(
          title: 'Make an Impact!',
          video: false,
          description:
          'Your points hold the power to create change! Team up with fellow adventurers to support noble causes.',
          imageUrl: 'third.json',
          bgColor: kcWhiteColor,
        )
      ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      "assets/videos/onboarding.mp4",
    )..initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
      setState(() {});
    });
    locator<LocalStorage>().save(LocalStorageDir.onboarded, true);
  }

  @override
  void dispose() {
    // Dispose of the video controller to release resources
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              // This section contains the PageView.builder
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 28,
                              color: kcSecondaryColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Panchang",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Panchang",
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (item.video)
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: _controller.value.isInitialized
                                  ? _controller.value.aspectRatio
                                  : 16 / 9,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        else
                          Expanded(
                            child: EmptyState(
                              animation: item.imageUrl,
                              label: "",
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              // Page indicator (counter)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages.map((item) {
                  int index = widget.pages.indexOf(item);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _currentPage == index ? 30 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color:  kcBlackColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  );
                }).toList(),
              ),
              // Bottom buttons
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        widget.onSkip?.call();
                        locator<NavigationService>().clearStackAndShow(Routes.homeView);
                      },
                      child: const Text("Skip", style: TextStyle(color: kcBlackColor),),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          widget.onFinish?.call();
                          locator<NavigationService>().clearStackAndShow(Routes.homeView);
                        } else {
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Finish"
                                : "Next",
                            style: TextStyle(color: kcBlackColor),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == widget.pages.length - 1
                                ? Icons.done
                                : Icons.arrow_forward,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final bool video;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.video,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}













