// import 'package:afriprize/core/data/models/raffle_ticket.dart';
// import 'package:afriprize/ui/common/app_colors.dart';
// import 'package:afriprize/ui/common/ui_helpers.dart';
// import 'package:afriprize/ui/components/empty_state.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:stacked/stacked.dart';
//
// import 'draws_viewmodel.dart';
//
// class DrawsView extends StackedView<DrawsViewModel> {
//   const DrawsView({Key? key}) : super(key: key);
//
//   @override
//   Widget builder(
//     BuildContext context,
//     DrawsViewModel viewModel,
//     Widget? child,
//   ) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Draws",
//         ),
//       ),
//       body: viewModel.busy(viewModel.raffle)
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : viewModel.raffle.isEmpty
//               ? ListView(
//                   children: [
//                     const EmptyState(
//                         animation: "casino.json",
//                         label: "You're yet to participate in a draw"),
//                     verticalSpaceMedium,
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: rulesColumn(),
//                     )
//                   ],
//                 )
//               : Stack(
//                   children: [
//                     PageView.builder(
//                         itemCount: viewModel.raffle.length,
//                         onPageChanged: viewModel.onPageChanged,
//                         itemBuilder: (context, index) {
//                           RaffleTicket ticket = viewModel.raffle[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 30, right: 30, top: 20),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   "assets/images/raffle.png",
//                                 ),
//                                 verticalSpaceMedium,
//                                 Container(
//                                   height: 210,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color: kcPrimaryColor),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 30.0, horizontal: 50),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           "Prize:",
//                                           style: TextStyle(
//                                               color: kcWhiteColor,
//                                               fontSize: 18),
//                                         ),
//                                         verticalSpaceSmall,
//                                         Text(
//                                           ticket.ticketName ?? "",
//                                           style: const TextStyle(
//                                               color: kcWhiteColor,
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         verticalSpaceMedium,
//                                         Row(
//                                           children: [
//                                             Container(
//                                               height: 60,
//                                               width: 60,
//                                               decoration: BoxDecoration(
//                                                 image: (ticket.pictures ==
//                                                             null ||
//                                                         ticket
//                                                             .pictures!.isEmpty)
//                                                     ? null
//                                                     : DecorationImage(
//                                                         fit: BoxFit.cover,
//                                                         image: NetworkImage(
//                                                             ticket.pictures![0]
//                                                                 .location!)),
//                                                 color: kcWhiteColor,
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                               ),
//                                             ),
//                                             horizontalSpaceMedium,
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Text(
//                                                   "Ticket No.",
//                                                   style: TextStyle(
//                                                       color: kcWhiteColor,
//                                                       fontSize: 18),
//                                                 ),
//                                                 Text(
//                                                   ticket.ticketTracking ?? "",
//                                                   style: const TextStyle(
//                                                       color: kcWhiteColor,
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 verticalSpaceMedium,
//                                 const Text(
//                                   "Start time:",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat("d MMM y").format(
//                                       DateTime.parse(ticket.startDate!)),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 verticalSpaceMedium,
//                                 const Text(
//                                   "End time:",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat("d MMM y")
//                                       .format(DateTime.parse(ticket.endDate!)),
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 verticalSpaceMedium,
//                                 Expanded(
//                                   child: rulesColumn(),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 20.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                               viewModel.raffle.length,
//                               (index) =>
//                                   _indicator(viewModel.selectedIndex == index)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
//
//   Widget rulesColumn() {
//     return const SingleChildScrollView( // Wrap with SingleChildScrollView
//         child:
//       Column(
//       children: [
//         Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Rules:",
//               style: TextStyle(decoration: TextDecoration.underline),
//             )),
//         Text(
//           "1. In order to be eligible for a draw, you have to purchase a product to gain entry.\n2. Each product gives you an entry and so on.\n3. Your registered name must match your government name.\n4. Winner will be contacted directly via email and sms",
//           style: TextStyle(fontSize: 12),
//         ),
//         verticalSpaceSmall,
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Note:",
//               style:
//                   TextStyle(decoration: TextDecoration.underline, fontSize: 12),
//             ),
//             horizontalSpaceSmall,
//             Expanded(
//               child: Text(
//                 "Apple is not a sponsor or involved in any way with the draws.",
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ],
//     )
//     );
//   }
//
//   Widget _indicator(bool selected) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       height: 8,
//       width: 8,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: selected ? kcPrimaryColor : kcLightGrey,
//       ),
//     );
//   }
//
//   @override
//   void onViewModelReady(DrawsViewModel viewModel) {
//     viewModel.listRaffle();
//     super.onViewModelReady(viewModel);
//   }
//
//   @override
//   DrawsViewModel viewModelBuilder(
//     BuildContext context,
//   ) =>
//       DrawsViewModel();
// }

import 'package:afriprize/core/utils/config.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../state.dart';
import 'draws_viewmodel.dart';
import 'empty_tab_content.dart';

class DrawsView extends StatelessWidget {
  const DrawsView({super.key});


  // @override
  // Widget build(BuildContext context) {
  //   return ViewModelBuilder<DrawsViewModel>.reactive(
  //     viewModelBuilder: () => DrawsViewModel(),
  //     onModelReady: (viewModel) => viewModel.init(),
  //     builder: (context, viewModel, child) => DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           title: Text("Draws"),
  //         ),
  //         body: RefreshIndicator(
  //           onRefresh: () async {
  //             await viewModel.refreshData();
  //           },
  //           child: Column(
  //           children: [
  //             // Live Draws Section
  //             // viewModel.isBusy
  //             //     ? CircularProgressIndicator()
  //             //     : viewModel.pastDraws.isEmpty
  //             //     ? SizedBox()
  //             //     : Container(
  //             //   height: 100, // Adjust as necessary
  //             //   child: ListView.builder(
  //             //     scrollDirection: Axis.horizontal,
  //             //     itemCount: viewModel.pastDraws.length,
  //             //     itemBuilder: (context, index) {
  //             //       // Replace with your LiveDrawCard Widget
  //             //       return Card(
  //             //         child: Center(
  //             //           child: Text(viewModel.pastDraws[index].ticketName ?? 'ticket-name'),
  //             //         ),
  //             //       );
  //             //     },
  //             //   ),
  //             // ),
  //             // Tabs Section
  //             PreferredSize(
  //               preferredSize: Size.fromHeight(30),
  //               child: Align(
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   margin: EdgeInsets.all(10),
  //                   padding: EdgeInsets.all(4),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300]?.withOpacity(0.9), // Tab bar background color
  //                     borderRadius: BorderRadius.circular(
  //                       10.0, // Rounded corners
  //                     ),
  //                   ),
  //                   child: TabBar(
  //                     indicator: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(
  //                         10.0, // Rounded corners
  //                       ),
  //                       color: kcSecondaryColor, // Tab indicator color
  //                     ),
  //                     labelColor: Colors.black, // Selected tab label color
  //                     unselectedLabelColor: Colors.black26,
  //                     labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),// Unselected tab label color
  //                     tabs: [
  //                       Tab(text: "SoldOut Draws"),
  //                       Tab(text: "Winners"),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: TabBarView(
  //                 children: [
  //                   // SoldOut Draws Page
  //                   viewModel.isBusy
  //                       ? CircularProgressIndicator()
  //                       : viewModel.soldOutDraws.isEmpty
  //                       ? const EmptyTabContent(
  //                     title: 'No raffles are sold out at the moment.',
  //                     description: '',
  //                     rules: [
  //                       'Entry Eligibility: Secure your spot in the draw with an Afriprize card purchase of \$5. Each card is your ticket to potential victory.',
  //                       'Draw Participation: Keep your ticket handy and mark your calendar for the draw date. Join us on Instagram Live to witness the winning moment.',
  //                       'Bonus Credit: Enjoy a \$5 Afriprize credit with every card purchase, redeemable for a variety of items on our AfriShop.',
  //                       'Shop and Win: Experience the best of both worlds at Afriprize — where each draw brings you closer to unbelievable wins, and our shop offers an array of amazing products.',
  //                       'Apple is not a sponsor or involved in any way with the draws.'
  //                     ],
  //                   )
  //                       : ListView.builder(
  //                     itemCount: viewModel.soldOutDraws.length,
  //                     itemBuilder: (context, index) {
  //                       Raffle raffle = viewModel.soldOutDraws.elementAt(index);
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                         child: DrawsCard(
  //                           raffle: raffle,
  //                           viewModel: viewModel,
  //                           index: index,
  //                           isWinner: false,
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                   // Winners Page
  //                   viewModel.isBusy
  //                       ? CircularProgressIndicator()
  //                       : viewModel.winners.isEmpty
  //                       ? const EmptyTabContent(
  //                     title: 'No raffles are sold out at the moment.',
  //                     description: '',
  //                     rules: [
  //                       'Entry Eligibility: Secure your spot in the draw with an Afriprize card purchase of \$5. Each card is your ticket to potential victory.',
  //                       'Draw Participation: Keep your ticket handy and mark your calendar for the draw date. Join us on Instagram Live to witness the winning moment.',
  //                       'Bonus Credit: Enjoy a \$5 Afriprize credit with every card purchase, redeemable for a variety of items on our AfriShop.',
  //                       'Shop and Win: Experience the best of both worlds at Afriprize — where each draw brings you closer to unbelievable wins, and our shop offers an array of amazing products.',
  //                       'Apple is not a sponsor or involved in any way with the draws.'
  //                     ],
  //                   )
  //                       : ListView.builder(
  //                     itemCount: viewModel.winners.length,
  //                     itemBuilder: (context, index) {
  //                       // Replace with your WinnerCard Widget
  //                       Winner winner = viewModel.winners.elementAt(index);
  //                       return DrawsCard(
  //                         raffle: winner.raffle,
  //                         viewModel: viewModel,
  //                         index: index, isWinner: true,
  //                         winner: winner,
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawsViewModel>.reactive(
      viewModelBuilder: () => DrawsViewModel(),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Draws"),
            bottom:  PreferredSize(
                  preferredSize: Size.fromHeight(30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.9), // Tab bar background color
                        borderRadius: BorderRadius.circular(
                          10.0, // Rounded corners
                        ),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.0, // Rounded corners
                          ),
                          color: kcSecondaryColor, // Tab indicator color
                        ),
                        labelColor: Colors.black, // Selected tab label color
                        unselectedLabelColor: Colors.black26,
                        labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),// Unselected tab label color
                        tabs: [
                          Tab(text: "SoldOut Draws"),
                          Tab(text: "Winners"),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshData();
                },
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.soldOutDraws.isEmpty
                    ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(), // Ensure the ListView is always scrollable
                  children: const [
                    EmptyTabContent(
                  title: 'No raffles are sold out at the moment.',
                  description: '',
                  rules: [
                    'Entry Eligibility: Secure your spot in the draw with an Afriprize card purchase of \$5. Each card is your ticket to potential victory.',
                    'Draw Participation: Keep your ticket handy and mark your calendar for the draw date. Join us on Instagram Live to witness the winning moment.',
                    'Bonus Credit: Enjoy a \$5 Afriprize credit with every card purchase, redeemable for a variety of items on our AfriShop.',
                    'Shop and Win: Experience the best of both worlds at Afriprize — where each draw brings you closer to unbelievable wins, and our shop offers an array of amazing products.',
                    'Apple is not a sponsor or involved in any way with the draws.'
                  ],
                )
                      ]) : ListView.builder(
                  itemCount: viewModel.soldOutDraws.length,
                  itemBuilder: (context, index) {
                    Raffle raffle = viewModel.soldOutDraws.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DrawsCard(
                        raffle: raffle,
                        viewModel: viewModel,
                        index: index,
                        isWinner: false,
                      ),
                    );
                  },
                ),
              ),
              // Second Tab: Winners
              RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshData();
                },
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.winners.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(), // Ensure the ListView is always scrollable
                        children: const [
                           EmptyTabContent(
                  title: 'No raffles are sold out at the moment.',
                  description: '',
                  rules: [
                    'Entry Eligibility: Secure your spot in the draw with an Afriprize card purchase of \$5. Each card is your ticket to potential victory.',
                    'Draw Participation: Keep your ticket handy and mark your calendar for the draw date. Join us on Instagram Live to witness the winning moment.',
                    'Bonus Credit: Enjoy a \$5 Afriprize credit with every card purchase, redeemable for a variety of items on our AfriShop.',
                    'Shop and Win: Experience the best of both worlds at Afriprize — where each draw brings you closer to unbelievable wins, and our shop offers an array of amazing products.',
                    'Apple is not a sponsor or involved in any way with the draws.'
                  ],
                )
                        ])
                    : ListView.builder(
                  itemCount: viewModel.winners.length,
                  itemBuilder: (context, index) {
                    // Replace with your WinnerCard Widget
                    Winner winner = viewModel.winners.elementAt(index);
                    return DrawsCard(
                      raffle: winner.raffle!,
                      viewModel: viewModel,
                      index: index, isWinner: true,
                      winner: winner,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}


class DrawsCard extends StatelessWidget {
  final Raffle raffle;
  final DrawsViewModel viewModel;
  final Winner? winner;
  final int index;
  final bool isWinner;

  const DrawsCard({
    required this.raffle,
    super.key, required this.viewModel, required this.index, required this.isWinner, this.winner,
  });

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      children: [
                        CachedNetworkImage(
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
                        Container(
                          // width: screenWidth, // Set the width to the screen width
                          height: 40.0,
                          color: kcSecondaryColor, // Set the background color to blue
                          padding: const EdgeInsets.all(7.0),
                          child: Marquee(
                            text: isWinner ?  'SOLD OUT SOLD OUT SOLD OUT' : 'WINNER WINNER WINNER WINNER', // Your text here
                            style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 19, fontFamily: "Panchang"),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: Duration(milliseconds: 50),
                            startPadding: 10.0,
                            accelerationDuration: Duration(seconds: 2),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,

                          ),
                        ),
                      ],
                    )


                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0,4.0,16.0,16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!isWinner)
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
                      if(!isWinner)
                        Text(
                        raffle.ticketName ?? 'Product Name',
                        style:  TextStyle(
                            fontSize: 20,
                            color: uiMode.value == AppUiModes.light ? kcPrimaryColor : kcSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if(isWinner)
                        Text(
                          '${winner?.user?.firstname} ${winner?.user?.lastname}' ?? 'Product Name',
                          style:  TextStyle(
                              fontSize: 20,
                              color: uiMode.value == AppUiModes.light ? kcPrimaryColor : kcSecondaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Panchang"
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    const url = AppConfig.youtubeOfficial;
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                    } else {
                                    throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/youtube.svg',
                                      height: 20, // Icon size
                                    ),
                                  ),
                                ),
                                horizontalSpaceTiny,
                                InkWell(
                                  onTap: () async {
                                    const url = AppConfig.instagramOfficial;
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/instagram.svg',
                                      height: 20, // Icon size
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      if(!isWinner)
                        Text('Raffle dates subject to change. Follow us on s'
                            'ocial media for updates and live draw events. '
                            'Your big win awaits!',
                          style: TextStyle(fontSize: 10),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,)

                    ],
                  ),
                ),

              ],
            ),

          ],
        ),

      );
  }
}



