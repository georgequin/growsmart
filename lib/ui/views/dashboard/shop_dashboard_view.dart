import 'dart:async';
import 'dart:ui';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/dashboard/raffle_detail.dart';
import 'package:afriprize/utils/money_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/data/models/product.dart';
import 'dashboard_viewmodel.dart';

class ShopDashboardView extends StackedView<DashboardViewModel> {
  ShopDashboardView({Key? key}) : super(key: key);


  final PageController _pageController = PageController();
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(
      "assets/videos/dashboard.mp4",
    )..initialize().then((_) {
      // Ensure the first frame is shown and set the video to loop.
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    _controller = VideoPlayerController.asset(
      "assets/videos/dashboard.mp4",
    )..initialize().then((_) {
      // Ensure the first frame is shown and set the video to loop.
      _controller.setLooping(true);
      _controller.play();
    });
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.refreshData();
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
                child: VideoPlayer(_controller),
              ),
            ),


            // SizedBox(
            //   height: 250,
            //   child: viewModel.busy(viewModel.ads)
            //       ? const Center(
            //           child: CircularProgressIndicator(),
            //         )
            //       : Stack(
            //           children: [
            //             PageView.builder(
            //                 controller: _pageController,
            //                 itemCount: viewModel.ads.length,
            //                 onPageChanged: viewModel.changeSelected,
            //                 itemBuilder: (context, index) {
            //                   Product ad = viewModel.ads[index];
            //
            //                   String? image = (ad.raffle != null && ad.raffle!.isNotEmpty &&
            //                       ad.raffle![0].pictures != null && ad.raffle![0].pictures!.isNotEmpty)
            //                       ? ad.raffle![0].pictures![0].location
            //                       : '';
            //
            //                   // String image =
            //                   //     ad.raffle![0].pictures![0].location!;
            //
            //                   return Stack(
            //                     children: [
            //                       Container(
            //                         decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(12),
            //                           color: kcBlackColor.withOpacity(0.2),
            //                           image: (ad.raffle != null && ad.raffle!.isNotEmpty &&
            //                               ad.raffle![0].pictures != null && ad.raffle![0].pictures!.isNotEmpty)
            //                               ? DecorationImage(
            //                             image: NetworkImage(ad.raffle![0].pictures![0].location!),
            //                             fit: BoxFit.cover,
            //                             colorFilter: ColorFilter.mode(
            //                               Colors.black.withOpacity(0.9),
            //                               BlendMode.dstATop,
            //                             ),
            //                           )
            //                               : null,
            //                         ),
            //                       ),
            //                       Positioned(
            //                         bottom: 20,
            //                         left: 20,
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             Container(
            //                               height: 70,
            //                               width: 70,
            //                               decoration: BoxDecoration(
            //                                 image:  (ad.pictures != null && ad.pictures!.isNotEmpty)
            //                                     ? DecorationImage(
            //                                   fit: BoxFit.cover,
            //                                   image: NetworkImage(ad.pictures![0].location!),
            //                                 )
            //                                     : null,
            //                                 color: kcLightGrey,
            //                                 borderRadius:
            //                                     BorderRadius.circular(12),
            //                               ),
            //                             ),
            //                             verticalSpaceTiny,
            //                             SizedBox(
            //                               width: 140,
            //                               child: FutureBuilder<Color?>(
            //                                 future: image != null ? _updateTextColor(image) : Future.value(null),
            //                                 builder: (context, snapshot) {
            //                                   // Determine the text color - either from the snapshot or a default color
            //                                   Color textColor = snapshot.data ?? Colors.black; // Default color if snapshot.data is null
            //
            //                                   return Text(
            //                                     "Buy ${ad.productName} and stand a chance to",
            //                                     style: TextStyle(
            //                                         fontSize: 14,
            //                                         color: textColor, // Use the determined color
            //                                         fontWeight: FontWeight.bold
            //                                     ),
            //                                   );
            //                                 },
            //                               ),
            //                             ),
            //
            //                             verticalSpaceTiny,
            //                             FutureBuilder<Color?>(
            //                               future: image != null ? _updateTextColor(image) : Future.value(null),
            //                               builder: (context, snapshot) {
            //                                 // Determine the text color - either from the snapshot or a default color
            //                                 Color textColor = snapshot.data ?? Colors.black; // Default color if snapshot.data is null
            //
            //                                 return Text(
            //                                   (ad.raffle == null || ad.raffle!.isEmpty) ? "" : "${ad.raffle![0].ticketName}",
            //                                   style: TextStyle(
            //                                     fontSize: 16,
            //                                     color: textColor, // Use the determined color
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                                 );
            //                               },
            //                             )
            //
            //                           ],
            //                         ),
            //                       ),
            //                       Positioned(
            //                         right: 20,
            //                         bottom: 20,
            //                         child: InkWell(
            //                           onTap: () {
            //                             locator<NavigationService>()
            //                                 .navigateToProductDetail(
            //                                     product: ad);
            //                           },
            //                           child: Container(
            //                             height: 40,
            //                             width: 100,
            //                             decoration: BoxDecoration(
            //                                 color: kcPrimaryColor,
            //                                 borderRadius:
            //                                     BorderRadius.circular(4)),
            //                             child: Center(
            //                               child: Text(
            //                                 "Win Now",
            //                                 style: GoogleFonts.inter(
            //                                   fontSize: 12,
            //                                   color: kcWhiteColor,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   );
            //                 }),
            //             Positioned(
            //               top: 20,
            //               right: 20,
            //               child: Row(
            //                 children: List.generate(
            //                     viewModel.ads.length,
            //                     (index) => _indicator(
            //                         viewModel.selectedIndex == index)),
            //               ),
            //             ),
            //           ],
            //         ),
            // ),
            if(viewModel.sellingFast.isNotEmpty)
              verticalSpaceMedium,
            if(viewModel.sellingFast.isNotEmpty)
              const Text(
              "Selling fast shop",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(viewModel.sellingFast.isNotEmpty)
              SizedBox(
              height: 250,
              child: viewModel.busy(viewModel.sellingFast)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.sellingFast.length,
                      itemBuilder: (context, index) {
                        Product product = viewModel.sellingFast[index];
                        return Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(
                              right: 15, top: 10, bottom: 10),
                          width: 350,
                          decoration: BoxDecoration(
                              color: uiMode.value == AppUiModes.light
                                  ? kcWhiteColor
                                  : kcBlackColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: kcBlackColor.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                )
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${product.raffle?[0].ticketName}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Text(
                                      "${product.raffle?[0].ticketDescription}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  kcPrimaryColor),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ))),
                                      onPressed: () {
                                        locator<NavigationService>()
                                            .navigateToShopDetail(
                                                product: product);
                                      },
                                      child: Text(
                                        "Learn More",
                                        style: GoogleFonts.inter(
                                            color: kcWhiteColor),
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Text(
                                      "${product.verifiedSales} sold out of ${product.stockTotal}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    SizedBox(
                                      width: 100,
                                      child: SizedBox(
                                        width: 100,
                                        child: LinearProgressIndicator(
                                          value: (product.verifiedSales != null && product.stockTotal != null && product.stockTotal! > 0)
                                              ? product.verifiedSales! / product.stockTotal!
                                              : 0.0, // Default value in case of null or invalid stock
                                          backgroundColor: kcSecondaryColor.withOpacity(0.3),
                                          valueColor: const AlwaysStoppedAnimation(kcSecondaryColor),
                                        ),
                                      ),

                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: product.raffle?[0].pictures == null ||
                                          product.raffle![0].pictures!.isEmpty
                                      ? null
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            product.raffle![0].pictures![0]
                                                .location!,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
            ),
              verticalSpaceSmall,
            const Text(
              "Upcoming Draws",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceSmall,

            viewModel.busy(viewModel.productList)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.productList.isEmpty ?
            const Center(child: Text('No products available')) :
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.productList.length,
                itemBuilder: (context, index) {
                  if (viewModel.productList.isEmpty) {
                    // Return a placeholder or an empty container
                    return Container(); // or SizedBox.shrink()
                  }

                  if (index >= viewModel.productList.length) {
                    return Container(); // or SizedBox.shrink()
                  }

                  // if (index > viewModel.productList.length+1) {
                  //   print('$index');
                  //   print('${viewModel.productList.length}');
                  //
                  //   return null;
                  // }

                  Product product = viewModel.productList.elementAt(index);
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
                                child: RaffleDetail(product: product),
                              );
                            },
                          );
                        },
                        child: ProductRow(
                          product: product,
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
    Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= viewModel.ads.length) {
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

class ProductRow extends StatelessWidget {
  final Product product;
  final DashboardViewModel viewModel;
  final int index;

  const ProductRow({
    required this.product,
    super.key, required this.viewModel, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.productList.isEmpty || index >= viewModel.productList.length) {
      return Container();
    }
    return
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 365,
      decoration: BoxDecoration(
        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kcBlackColor.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child:
          Column(
            children: [
              //product image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: (product.raffle == null ||
                            product.raffle!.isEmpty ||
                            product.raffle![0].pictures == null ||
                            product.raffle![0].pictures!.isEmpty)
                        ? SizedBox(
                            height: 182,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Image.network(
                            (product.raffle![0].pictures!.isNotEmpty)
                                ? product.raffle![0].pictures![0].location ??
                                    '' // Use ?? to provide a default value if location is null
                                : '',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 182,
                          ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: kcStarColor,
                            size: 20,
                          ),
                          FutureBuilder<Color?>(
                              future: _updateTextColor(
                                  product.raffle!.isNotEmpty ?
                                  product.raffle![0].pictures![0].location ?? '' : ''),
                              builder: (context, snapshot) {
                                return Text(
                                  (product.reviews == null ||
                                      product.reviews!.isEmpty)
                                      ? "0"
                                      : "${(product.reviews?.map<int>((review) => review.rating as int).reduce((value, element) => value + element))! / product.reviews!.length}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: snapshot.data,
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //Ticket name
              Container(
                color: kcPrimaryColor, // Set the background color to blue
                padding: const EdgeInsets.all(7.0), // Add padding to the container
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child:  Text(
                      (product.raffle == null || product.raffle!.isEmpty)
                          ? ""
                          : product.raffle?[0].ticketName ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white, // Set the text color to white
                      ),
                    ),),
                  ],
                ),
              ),

              Padding(
               padding: const EdgeInsets.symmetric(horizontal: 6.0), // This adds horizontal padding
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 6,
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      image: product.pictures!.isEmpty
                                          ? null
                                          : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(product.pictures!.firstWhere(
                                              (picture) => picture.front == true,
                                          orElse: () => product.pictures!.first,
                                        ).location ?? ''),
                                      ),
                                      color: kcWhiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(width: 8), // spacing between the image and text
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Text(
                                          product.productName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),

                          //product prize
                          Expanded(
                            flex: 4, // Allocate 40% of the space to this widget, adjust this as needed
                            child: Container(
                              alignment: Alignment.centerRight, // Align the text to the right
                              child: Text(
                                MoneyUtils().formatAmount(product.productPrice!),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "satoshi",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${product.verifiedSales} sold out of ${product.stockTotal}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    value: (product.verifiedSales != null && product.stockTotal != null && product.stockTotal! > 0)
                                        ? product.verifiedSales! / product.stockTotal!
                                        : 0.0, // Default value in case of null or invalid stock
                                    backgroundColor: kcSecondaryColor.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation(kcSecondaryColor),
                                  ),
                                ),

                                Text(
                                  (product.raffle == null || product.raffle!.isEmpty)
                                      ? ""
                                      : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(product.raffle?[0].endDate ?? DateTime.now().toIso8601String()))}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 12,
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
                                    : ValueListenableBuilder<List<CartItem>>(
                                  valueListenable: raffleCart,
                                  builder: (context, value, child) {
                                    // Determine if product is in cart
                                    bool isInCart = value.any((item) => item.product?.id == product.id);
                                    CartItem? cartItem = isInCart
                                        ? value.firstWhere((item) => item.product?.id == product.id)
                                        : null;

                                    return isInCart && cartItem != null
                                        ? Row(
                                      children: [
                                        InkWell(
                                          onTap: () => viewModel.decreaseQuantity(cartItem),
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
                                          onTap: () => viewModel.increaseQuantity(cartItem),
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
                                      width: 180, // Adjust width to your preference
                                      height: 45,
                                      child: SubmitButton(
                                        isLoading: false,
                                        label: "Add to cart",
                                        submit: () => viewModel.addToCart(product),
                                        color: kcSecondaryColor,
                                        boldText: true,
                                        icon: Icons.shopping_bag_outlined,
                                        iconColor: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )




                        ],
                      ),
                    )
                  ],
                )
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
