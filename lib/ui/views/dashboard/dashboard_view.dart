import 'dart:async';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/raffle_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/project.dart';
import '../../../widget/AdventureDialog.dart';
import 'dashboard_viewmodel.dart';
import 'package:showcaseview/showcaseview.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final GlobalKey walletShowcaseKey = GlobalKey(); // Global key for the showcase
  bool isShowcaseStarted = false; // Track whether the showcase has been started

  @override
  Widget builder(
      BuildContext context,
      DashboardViewModel viewModel,
      Widget? child,
      ) {
    if (viewModel.showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierColor: Colors.black.withOpacity(0.9),
          context: context,
          builder: (BuildContext context) {
            return const AdventureModal(); // Use the separate modal widget
          },
        );
        viewModel.showDialog = false; // Ensure the dialog is shown only once
      });
    }

    // Trigger the showcase after the first frame build, and ensure it's not called multiple times.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isShowcaseStarted) {
        ShowCaseWidget.of(context).startShowCase([walletShowcaseKey]);
        isShowcaseStarted = true; // Avoid calling it again
      }
    });

    return ShowCaseWidget(
      builder: (context) { // Correct function signature here
        return Scaffold(
          appBar: AppBar(
            title: ValueListenableBuilder(
              valueListenable: uiMode,
              builder: (context, AppUiModes mode, child) {
                return SvgPicture.asset(
                  "assets/images/dashboard_logo.svg",
                  width: 150,
                  height: 40,
                );
              },
            ),
            actions: [
              Showcase.withWidget(
                key: walletShowcaseKey,
                container: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: kcWhiteColor, // Background color for the showcase popup
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7, // Example: 90% of the screen width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Your Wallet Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kcSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Donate your points to charitable causes or shop for exciting products in our eCommerce store. Maximize your rewards and make a difference today!',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).dismiss(); // Exit the showcase
                                },
                                child: const Text('Skip'),
                                style: ElevatedButton.styleFrom(),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next(); // Move to the next showcase
                                },
                                child: const Text('Next'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kcSecondaryColor, // Background color of the button
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                disposeOnTap: false, // Dismiss showcase on tap
                onTargetClick: () {
                  // Handle the action when the target is clicked
                  ShowCaseWidget.of(context).dismiss(); // Dismiss the showcase
                },
                height: 500,
                width: 350,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: kcPrimaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    profile.value.wallet?.balance.toString() ?? '₦0.00',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Panchang",
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                "assets/images/dashboard_wallet.svg",
                width: 150,
                height: 40,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await viewModel.refreshData();
            },
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              children: [
                Container(
                  height: 200, // Set a fixed height for the video player
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Apply rounded corners to the container
                  ),
                  clipBehavior: Clip.antiAlias, // This will clip the video player to the border radius
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // You can adjust the aspect ratio to the desired value
                    child: VideoPlayer(viewModel.controller),
                  ),
                ),
                verticalSpaceSmall,
                quickActions(context),
                verticalSpaceMedium,
                doMoreOnAfriprize(context),
                verticalSpaceMedium,
                popularDrawsSlider(context, viewModel.raffleList),
                verticalSpaceMedium,
                donationsSlider(context, viewModel.projectResources),
              ],
            ),
          ),
        );
      },
    );
  }




  Widget quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Panchang"),
        ),
        const SizedBox(height: 10),
        Container(
          height: 60, // Adjust height according to your design
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // First Container
              GestureDetector(
                onTap: () {
                  // Action for the first container
                  print('Raffle clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/raffles.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Second Container
              GestureDetector(
                onTap: () {
                  // Action for the second container
                  print('Donate clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/donations.svg', // Second image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Third Container
              GestureDetector(
                onTap: () {
                  // Action for the third container
                  print('Coming Soon clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 110, // Adjust width according to your design
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/shop.svg', // Third image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget doMoreOnAfriprize(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Do More On Afriprize",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "Panchang"),
        ),
        const SizedBox(height: 10),
        Container(
          height: 55, // Adjust height according to your design
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  // Action for the first container
                  print('Instant Wallet Credit clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Added padding around the content of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Colored Circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                              width:
                                  8), // Space between the circle and the text
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Instant Wallet Credit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      4), // Adjust space between title and description
                              Text(
                                'Value equal to the ticket\'s value!',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // First Container
              GestureDetector(
                onTap: () {
                  // Action for the first container
                  print('Instant Wallet Credit clicked!');
                  // You can navigate or perform other actions here
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    // Added padding around the content of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Colored Circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kcSecondaryColor, // Customize the color
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                              width:
                                  8), // Space between the circle and the text
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Donate to Non-profits',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      4), // Adjust space between title and description
                              Text(
                                'Supported by our partners',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget popularDrawsSlider(BuildContext context, List<Raffle> raffles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Popular Draws Text
            const Text(
              "Popular Draws",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "Panchang",
              ),
            ),
            // Explore Capsule
            InkWell(
              onTap: () {
                // Handle Explore tap
                print('Explore tapped');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kcSecondaryColor
                      .withOpacity(0.2), // Capsule background color
                  borderRadius:
                      BorderRadius.circular(20), // Rounded capsule shape
                ),
                child: const Row(
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(
                        color: kcBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: kcSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300, // Adjust height to match the size of your cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: raffles.length,
            itemBuilder: (context, index) {
              final raffle = raffles[index];
              final imageUrl = raffle.media?.isNotEmpty == true
                  ? raffle.media![0].url
                  : 'https://via.placeholder.com/150';
              // final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss')
              final formattedEndDate = DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(raffle.endDate ?? ''));

              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    // barrierColor: Colors.black.withAlpha(50),
                    // backgroundColor: Colors.transparent,
                    backgroundColor: Colors.black.withOpacity(0.7),
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9, // 70% of the screen's height
                        child: RaffleDetail(raffle: raffle),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Image covering the entire card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl!,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Tint overlay for better readability
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.black.withOpacity(
                                0.6), // Dark semi-transparent overlay
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        // Raffle details positioned on top of the image
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kcWhiteColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              raffle.formattedTicketPrice ?? '',
                              style: const TextStyle(
                                color: kcPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 33,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kcSecondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Ticket Price',
                              style: TextStyle(
                                fontSize: 10,
                                color: kcPrimaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'WIN Prize in $formattedEndDate',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                raffle.name ?? '',
                                style: const TextStyle(
                                  color: kcSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/partcipant_icon.png",
                                    width: 40,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${raffle.participants?.length ?? 0} Participants',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget donationsSlider(BuildContext context, List<ProjectResource> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Popular Draws Text
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Donations",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Panchang",
                  ),
                ),
                Text(
                  "Empower Change with Your Points",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            // Explore Capsule
            InkWell(
              onTap: () {
                // Handle Explore tap
                print('Explore tapped');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kcSecondaryColor
                      .withOpacity(0.2), // Capsule background color
                  borderRadius:
                      BorderRadius.circular(20), // Rounded capsule shape
                ),
                child: const Row(
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(
                        color: kcBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: kcSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 222, // Adjust height to match the size of your cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index].project;
              final members = projects[index].members;
              final imageUrl = project?.media?.isNotEmpty == true
                  ? project?.media![0].url
                  : 'https://via.placeholder.com/150';
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                    //   ),
                    //   backgroundColor: Colors.black.withOpacity(0.7),
                    //   builder: (BuildContext context) {
                    //     return FractionallySizedBox(
                    //       heightFactor: 0.8, // 70% of the screen's height
                    //       child: ServiceDetailsPage(service: service, isModal: true),
                    //     );
                    //   },
                    // );
                  },
                  child: Container(
                    width: 222,
                    decoration: BoxDecoration(
                      color: kcWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: kcWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              // color: kcPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    imageUrl!,
                                    width:
                                        double.infinity, // or specify a width
                                    height: 124, // or specify a height
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    // Add padding to the row
                                    padding: const EdgeInsets.fromLTRB(5.0, 5.0,
                                        5.0, 0), // Adjust padding as needed
                                    child: Text(
                                      project?.projectTitle ?? 'service title',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: kcBlackColor,
                                        fontWeight: FontWeight.w600,
                                        // fontFamily: "Panchang"
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    // Add padding to the row
                                    padding: const EdgeInsets.fromLTRB(8.0, 0,
                                        8.0, 8.0), // Adjust padding as needed
                                    child: Text(
                                      project?.projectDescription ?? '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: kcBlackColor,
                                        // fontFamily: "Panchang"
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/partcipant_icon.png",
                                          width: 40,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${members?.length ?? 0} Participants',
                                          style: const TextStyle(
                                            color: kcDarkGreyColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
    viewModel.initialise();
    Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= viewModel.featuredRaffle.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onDispose(DashboardViewModel viewModel) {
    viewModel.dispose();
    _pageController.dispose();
  }

  Widget _indicator(bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? kcWhiteColor : kcMediumGrey,
      ),
    );
  }

  Future<Color?> _updateTextColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    // Calculate the brightness of the dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;
    final double luminance = dominantColor.computeLuminance();

    // Decide text color based on luminance
    return luminance < 0.1 ? Colors.white : Colors.black;
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}

class RaffleRow extends StatelessWidget {
  final Raffle raffle;
  final DashboardViewModel viewModel;
  final int index;

  const RaffleRow({
    required this.raffle,
    super.key,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.raffleList.isEmpty || index >= viewModel.raffleList.length) {
      return Container();
    }
    CountdownTimerController controller = CountdownTimerController(endTime: 0);
    int remainingStock = 0;
    int remainingDays = 0;
    int endTime = 0;
    // final int stockTotal = raffle.stockTotal ?? 0;
    // final int verifiedSales = raffle.verifiedSales ?? 0;
    // remainingStock = stockTotal - verifiedSales;

    DateTime now = DateTime.now();
    DateTime drawDate = DateFormat("yyyy-MM-dd")
        .parse(raffle.endDate ?? '2024-02-04T00:00:00.000Z');
    // DateTime drawDate = DateFormat("yyyy-MM-dd").parse("2024-02-04T00:00:00.000Z");
    Duration timeDifference = drawDate.difference(now);
    remainingDays = timeDifference.inDays;
// Adding the current time to the timeDifference to get the future end time
    endTime = now.add(timeDifference).millisecondsSinceEpoch;
    controller =
        CountdownTimerController(endTime: endTime, onEnd: viewModel.onEnd);

    // Check conditions to set the color and text
    Color containerColor = Colors.transparent; // Default color
    String bannerText = ''; // Default text
    if (remainingDays <= 5) {
      containerColor = Colors.blue;
      bannerText = 'Coming soon in';
    } else if (remainingStock <= 10) {
      containerColor = Colors.red;
      bannerText = 'Sold out soon \n $remainingStock item left';
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      // height: 400,
      decoration: BoxDecoration(
        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kcSecondaryColor),
        boxShadow: [
          BoxShadow(
            color: kcBlackColor.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Stack(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(12),
              //     ),
              //     child: CachedNetworkImage(
              //       placeholder: (context, url) => const Center(
              //         child: CircularProgressIndicator(
              //           strokeWidth: 2.0, // Make the loader thinner
              //           valueColor: AlwaysStoppedAnimation<Color>(
              //               kcSecondaryColor), // Change the loader color
              //         ),
              //       ),
              //       imageUrl: raffle.pictures?.first.location ??
              //           'https://via.placeholder.com/150',
              //       fit: BoxFit.cover,
              //       height: 182,
              //       width: double.infinity,
              //       errorWidget: (context, url, error) =>
              //           const Icon(Icons.error),
              //       fadeInDuration: const Duration(milliseconds: 500),
              //       fadeOutDuration: const Duration(milliseconds: 300),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Win!!!',
              //         style: TextStyle(
              //             fontSize: 22,
              //             color: uiMode.value == AppUiModes.light
              //                 ? kcSecondaryColor
              //                 : kcWhiteColor,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "Panchang"),
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       Text(
              //         raffle.ticketName ?? 'raffle Name',
              //         style: TextStyle(
              //             fontSize: 20,
              //             color: uiMode.value == AppUiModes.light
              //                 ? kcPrimaryColor
              //                 : kcSecondaryColor,
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "Panchang"),
              //         maxLines: 3,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 11, vertical: 7),
              //             decoration: BoxDecoration(
              //               color: Colors.grey[300]?.withOpacity(0.2),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Text(
              //               'Buy \$5 Afriprize Card',
              //               style: TextStyle(
              //                   color: uiMode.value == AppUiModes.light
              //                       ? kcBlackColor
              //                       : kcWhiteColor,
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 16, vertical: 10),
              //             decoration: BoxDecoration(
              //               color: uiMode.value == AppUiModes.light
              //                   ? kcPrimaryColor
              //                   : kcSecondaryColor,
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: Column(
              //               children: [
              //                 Text(
              //                   'Shopping Card',
              //                   style: TextStyle(
              //                       color: uiMode.value == AppUiModes.light
              //                           ? kcWhiteColor
              //                           : kcBlackColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 10),
              //                 ),
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset(
              //                       'assets/icons/card_icon.svg',
              //                       height: 20, // Icon size
              //                     ),
              //                     horizontalSpaceTiny,
              //                     RichText(
              //                       text: TextSpan(
              //                         children: [
              //                           TextSpan(
              //                             text: '\$5',
              //                             style: TextStyle(
              //                               fontSize:
              //                                   18, // Size for the dollar amount
              //                               fontWeight: FontWeight.bold,
              //                               color:
              //                                   uiMode.value == AppUiModes.light
              //                                       ? kcSecondaryColor
              //                                       : kcBlackColor,
              //                             ),
              //                           ),
              //                           TextSpan(
              //                             text:
              //                                 '.00', // Assuming you want the decimal part smaller
              //                             style: TextStyle(
              //                               fontSize: 13, // Size for the cents
              //                               fontWeight: FontWeight.bold,
              //                               color:
              //                                   uiMode.value == AppUiModes.light
              //                                       ? kcSecondaryColor
              //                                       : kcBlackColor,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Expanded(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     SvgPicture.asset(
              //                       'assets/icons/loader.svg',
              //                       height: 20, // Icon size
              //                     ),
              //                     horizontalSpaceTiny,
              //                     Column(
              //                       children: [
              //                         Text(
              //                           "${raffle.verifiedSales} sold out of ${raffle.stockTotal}",
              //                           overflow: TextOverflow.ellipsis,
              //                           maxLines: 3,
              //                           style: const TextStyle(
              //                             fontSize: 12,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: 95,
              //                           child: LinearProgressIndicator(
              //                             value: (raffle.verifiedSales !=
              //                                         null &&
              //                                     raffle.stockTotal != null &&
              //                                     raffle.stockTotal! > 0)
              //                                 ? raffle.verifiedSales! /
              //                                     raffle.stockTotal!
              //                                 : 0.0, // Default value in case of null or invalid stock
              //                             backgroundColor:
              //                                 kcSecondaryColor.withOpacity(0.3),
              //                             valueColor:
              //                                 const AlwaysStoppedAnimation(
              //                                     kcSecondaryColor),
              //                           ),
              //                         ),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 verticalSpaceTiny,
              //                 Container(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 7, vertical: 4),
              //                   decoration: BoxDecoration(
              //                     color: Colors.grey[300]?.withOpacity(0.2),
              //                     borderRadius: BorderRadius.circular(4),
              //                   ),
              //                   child: Text(
              //                     (raffle == null)
              //                         ? ""
              //                         : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(raffle.endDate ?? DateTime.now().toIso8601String()))}",
              //                     overflow: TextOverflow.ellipsis,
              //                     maxLines: 3,
              //                     style: const TextStyle(
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Column(
              //             // crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               userLoggedIn.value == false
              //                   ? const SizedBox()
              //                   : ValueListenableBuilder<List<RaffleCartItem>>(
              //                       valueListenable: raffleCart,
              //                       builder: (context, value, child) {
              //                         // Determine if raffle is in cart
              //                         bool isInCart = value.any((item) =>
              //                             item.raffle?.id == raffle.id);
              //                         RaffleCartItem? cartItem = isInCart
              //                             ? value.firstWhere((item) =>
              //                                 item.raffle?.id == raffle.id)
              //                             : null;
              //
              //                         return isInCart && cartItem != null
              //                             ? Row(
              //                                 children: [
              //                                   InkWell(
              //                                     onTap: () => viewModel
              //                                         .decreaseRaffleQuantity(
              //                                             cartItem),
              //                                     child: Container(
              //                                       height: 30,
              //                                       width: 30,
              //                                       decoration: BoxDecoration(
              //                                         border: Border.all(
              //                                             color: kcLightGrey),
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 5),
              //                                       ),
              //                                       child: const Center(
              //                                         child: Icon(Icons.remove,
              //                                             size: 18),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   horizontalSpaceSmall,
              //                                   Text("${cartItem.quantity}"),
              //                                   horizontalSpaceSmall,
              //                                   InkWell(
              //                                     onTap: () => viewModel
              //                                         .increaseRaffleQuantity(
              //                                             cartItem),
              //                                     child: Container(
              //                                       height: 30,
              //                                       width: 30,
              //                                       decoration: BoxDecoration(
              //                                         border: Border.all(
              //                                             color: kcLightGrey),
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 5),
              //                                       ),
              //                                       child: const Align(
              //                                         alignment:
              //                                             Alignment.center,
              //                                         child: Icon(Icons.add,
              //                                             size: 18),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               )
              //                             : SizedBox(
              //                                 width:
              //                                     150, // Adjust width to your preference
              //                                 height: 35,
              //                                 child: SubmitButton(
              //                                   isLoading: false,
              //                                   label: "Buy Ticket",
              //                                   submit: () => viewModel
              //                                       .addToRaffleCart(raffle),
              //                                   color: kcSecondaryColor,
              //                                   boldText: true,
              //                                   iconColor: Colors.black,
              //                                   borderRadius: 10.0,
              //                                   textSize: 12,
              //                                   svgFileName: "ticket.svg",
              //                                 ),
              //                               );
              //                       },
              //                     ),
              //             ],
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          if (containerColor != Colors.transparent)
            Positioned(
              top: 0, // Adjust the positioning as you see fit
              left: 22, // Adjust the positioning as you see fit
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                containerColor, // Blue color for the "Closing Soon" banner
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                bannerText,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Panchang",
                                    fontSize: 11),
                              ),
                              if (remainingDays <= 5)
                                CountdownTimer(
                                  controller: controller,
                                  onEnd: viewModel.onEnd,
                                  endTime: endTime,
                                  widgetBuilder:
                                      (_, CurrentRemainingTime? time) {
                                    if (time == null) {
                                      return const Text('in stock');
                                    }

                                    String dayText = '';
                                    if (time.days != null) {
                                      if (time.days! > 0) {
                                        dayText =
                                            '${time.days} ${time.days == 1 ? 'day' : 'days'}, ';
                                      }
                                    }
                                    String formattedHours =
                                        '${time.hours ?? 0}'.padLeft(2, '0');
                                    String formattedMin =
                                        '${time.min ?? 0}'.padLeft(2, '0');
                                    String formattedSec =
                                        '${time.sec ?? 0}'.padLeft(2, '0');

                                    return Text(
                                      '$dayText$formattedHours : $formattedMin : $formattedSec',
                                      style: const TextStyle(
                                          color: kcWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Panchang",
                                          fontSize: 11),
                                    );
                                  },
                                ),
                            ],
                          )),
                    ],
                  )),
            ),
        ],
      ),
    );
  }

  Future<Color?> _updateTextColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );

    // Calculate the brightness of the dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;
    final double luminance = dominantColor.computeLuminance();

    // Decide text color based on luminance
    return luminance < 0.1 ? Colors.white : Colors.black;
  }


}
