import 'dart:async';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/dashboard/raffle_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import '../../../core/data/models/product.dart';
import 'dashboard_viewmodel.dart';

/**
 * @author George David
 * email: georgequin19@gmail.com
 * Feb, 2024
 **/

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);


  final PageController _pageController = PageController();


  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      // appBar: AppBar(
      //   title: ValueListenableBuilder(
      //   valueListenable: uiMode,
      //   builder: (context, AppUiModes mode, child) {
      //     return Image.asset(
      //       mode == AppUiModes.dark ? "assets/images/afriprize_light.png" : "assets/images/afriprize.png",
      //       width: 150,
      //       height: 50,
      //     );
      //   },
      // ),
      //   actions: [
      //     userLoggedIn.value == false
      //         ? Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: TextButton(
      //               style: ButtonStyle(
      //                   backgroundColor:
      //                       MaterialStateProperty.all(kcPrimaryColor)),
      //               onPressed: () {
      //                 locator<NavigationService>().replaceWithAuthView();
      //               },
      //               child: const Text(
      //                 "Login",
      //                 style: TextStyle(color: kcWhiteColor),
      //               ),
      //             ),
      //           )
      //         : const SizedBox()
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          children: [
            Container(
              height: 250, // Set a fixed height for the video player
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Apply rounded corners to the container
              ),
              clipBehavior: Clip.antiAlias, // This will clip the video player to the border radius
              child: AspectRatio(
                aspectRatio: 16 / 9, // You can adjust the aspect ratio to the desired value
                child: VideoPlayer(viewModel.controller),
              ),
            ),
            if(viewModel.featuredRaffle.isNotEmpty)
              verticalSpaceMedium,
            if(viewModel.featuredRaffle.isNotEmpty)
              const Text(
              "Selling fast",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                  fontFamily: "Panchang"
              ),
            ),
            if(viewModel.featuredRaffle.isNotEmpty)
              SizedBox(
                 height: 170,
                child: viewModel.busy(viewModel.featuredRaffle)
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.featuredRaffle.length,
                  itemBuilder: (context, index) {
                    Raffle raffle = viewModel.featuredRaffle[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 15, top: 10),
                      width: 260,
                      decoration: BoxDecoration(
                        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: kcBlackColor.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0, // Make the loader thinner
                                  valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                ),
                              ),
                              imageUrl: raffle.pictures?[0].location ?? 'https://via.placeholder.com/120',
                              height: 140,
                              width: 90,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration: const Duration(milliseconds: 300),
                            ),
                          ),

                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  raffle.ticketName ?? 'raffle Name',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Panchang"
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                verticalSpaceSmall,
                                Text(
                                  'Buy \$5 Afriprize Card',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                  ),
                                ),
                                verticalSpaceSmall,
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    userLoggedIn.value == false
                                        ? const SizedBox()
                                        : ValueListenableBuilder<List<RaffleCartItem>>(
                                      valueListenable: raffleCart,
                                      builder: (context, value, child) {
                                        // Determine if raffle is in cart
                                        bool isInCart = value.any((item) => item.raffle?.id == raffle.id);
                                        RaffleCartItem? cartItem = isInCart
                                            ? value.firstWhere((item) => item.raffle?.id == raffle.id)
                                            : null;

                                        return isInCart && cartItem != null
                                            ? Row(
                                          children: [
                                            InkWell(
                                              onTap: () => viewModel.decreaseRaffleQuantity(cartItem),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: kcLightGrey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: const Center(
                                                  child: Icon(Icons.remove, size: 18),
                                                ),
                                              ),
                                            ),
                                            horizontalSpaceSmall,
                                            Text("${cartItem.quantity}"),
                                            horizontalSpaceSmall,
                                            InkWell(
                                              onTap: () => viewModel.increaseRaffleQuantity(cartItem),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: kcLightGrey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.add, size: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                            : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: kcPrimaryColor, // Button background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            viewModel.addToRaffleCart(raffle);
                                          },
                                          child:
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/ticket.svg',
                                                height: 20,
                                                color: kcPrimaryColor,
                                              ),
                                              const SizedBox(width: 8), // Space between icon and text
                                              Text(
                                                "Buy Ticket",
                                                style: GoogleFonts.inter(color: kcWhiteColor),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),
            verticalSpaceSmall,
            const Text(
              "Upcoming Draws",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Panchang"
              ),
            ),
            verticalSpaceSmall,
            viewModel.busy(viewModel.raffleList)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.raffleList.isEmpty ?
            const Center(child: Text('No raffle available')) :
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.raffleList.length,
                itemBuilder: (context, index) {
                  if (viewModel.raffleList.isEmpty) {
                    return Container(); // or SizedBox.shrink()
                  }

                  if (index >= viewModel.raffleList.length) {
                    return Container(); // or SizedBox.shrink()
                  }

                  Raffle raffle = viewModel.raffleList.elementAt(index);
                 return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                            ),
                            // barrierColor: Colors.black.withAlpha(50),
                            // backgroundColor: Colors.transparent,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8, // 70% of the screen's height
                                child: RaffleDetail(raffle: raffle),
                              );
                            },
                          );
                        },
                        child: RaffleRow(
                          raffle: raffle,
                          viewModel: viewModel,
                          index: index
                        ),
                      ),
                      verticalSpaceMedium
                    ],
                  );
                }),
          ],
        ),
      ),
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
    super.key, required this.viewModel, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.raffleList.isEmpty || index >= viewModel.raffleList.length) {
      return Container();
    }
    CountdownTimerController controller = CountdownTimerController(endTime: 0);;
    int remainingStock = 0;
    int remainingDays = 0;
    int endTime = 0;
    final int stockTotal = raffle.stockTotal ?? 0;
    final int verifiedSales = raffle.verifiedSales ?? 0;
    remainingStock = stockTotal - verifiedSales;

    DateTime now = DateTime.now();
    DateTime drawDate = DateFormat("yyyy-MM-dd").parse(raffle.endDate ?? '2024-02-04T00:00:00.000Z');
    // DateTime drawDate = DateFormat("yyyy-MM-dd").parse("2024-02-04T00:00:00.000Z");
    Duration timeDifference = drawDate.difference(now);
    remainingDays = timeDifference.inDays;
// Adding the current time to the timeDifference to get the future end time
    endTime = now.add(timeDifference).millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: viewModel.onEnd);


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
    return
    Container(
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                margin: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0, // Make the loader thinner
                        valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                      ),
                    ),
                    imageUrl: raffle.pictures?.first.location ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    height: 182,
                    width: double.infinity,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeOutDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Win!!!',
                      style: TextStyle(
                          fontSize: 22,
                          color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Panchang"
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      raffle.ticketName ?? 'raffle Name',
                      style:  TextStyle(
                          fontSize: 20,
                          color: uiMode.value == AppUiModes.light ? kcPrimaryColor : kcSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Panchang"
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey[300]?.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Buy \$5 Afriprize Card',
                            style: TextStyle(
                                color: uiMode.value == AppUiModes.light ? kcBlackColor : kcWhiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: uiMode.value == AppUiModes.light ? kcPrimaryColor : kcSecondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Shopping Card',
                                style: TextStyle(
                                    color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/card_icon.svg',
                                    height: 20, // Icon size
                                  ),
                                  horizontalSpaceTiny,
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '\$5',
                                          style: TextStyle(
                                            fontSize: 18, // Size for the dollar amount
                                            fontWeight: FontWeight.bold,
                                            color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcBlackColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '.00', // Assuming you want the decimal part smaller
                                          style: TextStyle(
                                            fontSize: 13, // Size for the cents
                                            fontWeight: FontWeight.bold,
                                            color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/loader.svg',
                                    height: 20, // Icon size
                                  ),
                                  horizontalSpaceTiny,
                                  Column(
                                    children: [
                                      Text(
                                        "${raffle.verifiedSales} sold out of ${raffle.stockTotal}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 95,
                                        child: LinearProgressIndicator(
                                          value: (raffle.verifiedSales != null && raffle.stockTotal != null && raffle.stockTotal! > 0)
                                              ? raffle.verifiedSales! / raffle.stockTotal!
                                              : 0.0, // Default value in case of null or invalid stock
                                          backgroundColor: kcSecondaryColor.withOpacity(0.3),
                                          valueColor: const AlwaysStoppedAnimation(kcSecondaryColor),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              verticalSpaceTiny,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]?.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (raffle == null)
                                      ? ""
                                      : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(raffle.endDate ?? DateTime.now().toIso8601String()))}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            userLoggedIn.value == false
                                ? const SizedBox()
                                : ValueListenableBuilder<List<RaffleCartItem>>(
                              valueListenable: raffleCart,
                              builder: (context, value, child) {
                                // Determine if raffle is in cart
                                bool isInCart = value.any((item) => item.raffle?.id == raffle.id);
                                RaffleCartItem? cartItem = isInCart
                                    ? value.firstWhere((item) => item.raffle?.id == raffle.id)
                                    : null;

                                return isInCart && cartItem != null
                                    ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () => viewModel.decreaseRaffleQuantity(cartItem),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: kcLightGrey),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.remove, size: 18),
                                        ),
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Text("${cartItem.quantity}"),
                                    horizontalSpaceSmall,
                                    InkWell(
                                      onTap: () => viewModel.increaseRaffleQuantity(cartItem),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: kcLightGrey),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Icon(Icons.add, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : SizedBox(
                                  width: 150, // Adjust width to your preference
                                  height: 35,
                                  child: SubmitButton(
                                    isLoading: false,
                                    label: "Buy Ticket",
                                    submit: () => viewModel.addToRaffleCart(raffle),
                                    color: kcSecondaryColor,
                                    boldText: true,
                                    iconColor: Colors.black,
                                    borderRadius: 10.0,
                                    textSize: 12,
                                    svgFileName: "ticket.svg",
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),

                  ],
                ),
              ),

            ],
          ),
          if (containerColor != Colors.transparent)
            Positioned(
            top: 0, // Adjust the positioning as you see fit
            left: 22, // Adjust the positioning as you see fit
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              ),
              child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: containerColor, // Blue color for the "Closing Soon" banner
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
                              fontSize: 11
                          ),
                        ),
                        if (remainingDays <= 5)
                          CountdownTimer(
                            controller: controller,
                            onEnd: viewModel.onEnd,
                            endTime: endTime,
                            widgetBuilder: (_, CurrentRemainingTime? time) {
                              if (time == null) {
                                return const Text('in stock');
                              }

                              String dayText = '';
                              if (time.days != null) {
                                if (time.days! > 0) {
                                  dayText = '${time.days} ${time.days == 1 ? 'day' : 'days'}, ';
                                }
                              }
                              String formattedHours = '${time.hours ?? 0}'.padLeft(2, '0');
                              String formattedMin = '${time.min ?? 0}'.padLeft(2, '0');
                              String formattedSec = '${time.sec ?? 0}'.padLeft(2, '0');

                              return Text(
                                '$dayText$formattedHours : $formattedMin : $formattedSec',
                                style: const TextStyle(
                                    color: kcWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Panchang",
                                    fontSize: 11
                                ),
                              );
                            },
                          ),
                      ],
                    )

                ),
              ],
              )
            ),
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
