import 'dart:async';
import 'dart:ui';

import 'package:afriprize/app/app.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/ad.dart';
import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:afriprize/ui/views/dashboard/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../widget/pagination_list.dart';
import 'dashboard_viewmodel.dart';

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
      appBar: AppBar(
        title: Image.asset(
          "assets/images/afriprize.png",
          width: 150,
          height: 50,
        ),
        actions: [
          userLoggedIn.value == false
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kcPrimaryColor)),
                    onPressed: () {
                      locator<NavigationService>().replaceWithAuthView();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: kcWhiteColor),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.init();
        },
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          children: [
            SizedBox(
              height: 250,
              child: viewModel.busy(viewModel.ads)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: [
                        PageView.builder(
                            controller: _pageController,
                            itemCount: viewModel.ads.length,
                            onPageChanged: viewModel.changeSelected,
                            itemBuilder: (context, index) {
                              Product ad = viewModel.ads[index];
                              print('length of ad list is: ${ad.raffle?.length}');
                              String image =
                                  ad.raffle![0].pictures![0].location!;

                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: kcBlackColor.withOpacity(0.2),
                                        image: ad.raffle == null ||
                                                ad.raffle!.isEmpty
                                            ? null
                                            : DecorationImage(
                                                image: NetworkImage(image),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.9),
                                                    BlendMode.dstATop),
                                              )),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            image: ad.pictures == null ||
                                                    ad.pictures!.isEmpty
                                                ? null
                                                : DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(ad
                                                        .pictures![0]
                                                        .location!)),
                                            color: kcLightGrey,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        verticalSpaceTiny,
                                        SizedBox(
                                          width: 140,
                                          child: FutureBuilder<Color?>(
                                            future: _updateTextColor(image),
                                            builder: (context, snapshot) =>
                                                Text(
                                              "Buy ${ad.productName} and stand a chance to",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: snapshot.data,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        verticalSpaceTiny,
                                        FutureBuilder<Color?>(
                                            future: _updateTextColor(image),
                                            builder: (context, snapshot) {
                                              return Text(
                                                (ad.raffle == null ||
                                                        ad.raffle!.isEmpty)
                                                    ? ""
                                                    : "${ad.raffle![0].ticketName}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: snapshot.data,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: InkWell(
                                      onTap: () {
                                        locator<NavigationService>()
                                            .navigateToProductDetail(
                                                product: ad);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: kcPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            "Win Now",
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: kcWhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Row(
                            children: List.generate(
                                viewModel.ads.length,
                                (index) => _indicator(
                                    viewModel.selectedIndex == index)),
                          ),
                        ),
                      ],
                    ),
            ),
            if(viewModel.sellingFast.isNotEmpty)
              verticalSpaceMedium,
            if(viewModel.sellingFast.isNotEmpty)
              const Text(
              "Selling fast",
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
                                            .navigateToProductDetail(
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
                                      "${product.orders?.where((element) => element["status"] != 1).toList().length} sold out of ${product.stock}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    SizedBox(
                                      width: 100,
                                      child: LinearProgressIndicator(
                                        value: ((product.orders
                                                ?.where((element) =>
                                                    element["status"] != 1)
                                                .toList()
                                                .length)! /
                                            (product.stock!)),
                                        backgroundColor:
                                            kcSecondaryColor.withOpacity(0.3),
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                kcSecondaryColor),
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


            // PaginationList<Product>(
            //   key: paginationListKey,
            //   scrollController: _scrollController,
            //   physics: const NeverScrollableScrollPhysics(),
            //   autoFetch: false,
            //   singlePage: false,
            //   shrinkWrap: true,
            //   separatorWidget: const SizedBox(
            //     height: 15,
            //   ),
            //   itemBuilder: (context, item) {
            //     return InkWell(
            //       onTap: () {
            //         locator<NavigationService>().navigateTo(
            //             Routes.productDetail,
            //             arguments: ProductDetailArguments(product: product));
            //       },
            //       child: ProductRow(
            //         product: product,
            //         viewModel: viewModel,
            //       ),
            //     );
            //   },
            //   onEmpty: const Center(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Icon(
            //           Icons.remove_circle,
            //           color: Colors.amber,
            //           size: 60,
            //         ),
            //         Text(
            //           'No Invoice found',
            //           textScaleFactor: 1.1,
            //         ),
            //       ],
            //     ),
            //   ),
            //   onError: (e) {
            //     print(e);
            //     return const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(
            //             Icons.warning_amber_outlined,
            //             color: Colors.red,
            //             size: 60,
            //           ),
            //           Text(
            //             'Could not complete this request. Check your internet connection.',
            //             textScaleFactor: 1.3,
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            //   onPageLoading: const Center(
            //     child: CircularProgressIndicator()
            //   ),
            //   onLoading: const Center(
            //     child: CircularProgressIndicator()
            //   ),
            //   // pageFetch: (currentSize) {
            //   //   log('data: $endDate');
            //   //   return loadData(
            //   //       category: category,
            //   //       createdAfter: endDate?.toDate(),
            //   //       paymentStatus: paymentStatus,
            //   //       pendingMyReview: pendingMyReview,
            //   //       reviewStatus: reviewStatus,
            //   //       createdBefore: startDate?.toDate(),
            //   //       status: status,
            //   //       offset: currentSize,
            //   //       limit: 10)
            //   //       .then((value) {
            //   //     _totalRecordsStream.add(value.data?.total??0);
            //   //     return value.data?.results?.toList() ??
            //   //         <InvoicePojo>[];
            //   //   });
            //   // },
            // ),
            viewModel.busy(viewModel.productList)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.productList.isEmpty ?
            Center(child: Text('No products available')) :
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
                            // barrierColor: Colors.black.withAlpha(50),
                            // backgroundColor: Colors.transparent,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8, // 70% of the screen's height
                                child: ProductDetail(product: product),
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
    Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= viewModel.ads.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 200),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 300,
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
              Stack(

                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: (product.raffle == null || product.raffle!.isEmpty)
                        ? SizedBox(
                      height: 128,
                      width: MediaQuery.of(context).size.width,
                    )
                        : Image.network(
                      (product.raffle!.isNotEmpty)
                          ? product.raffle![0].pictures![0].location!
                          : '', // Provide a default value or handle the case when pictures are empty
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 130,
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
                                  product.raffle![0].pictures![0].location! : ''),
                              builder: (context, snapshot) {
                                return Text(
                                  (product.reviews == null ||
                                      product.reviews!.isEmpty)
                                      ? "0"
                                      : "${(product.reviews?.map<int>((review) => review['rating'] as int).reduce((value, element) => value + element))! / product.reviews!.length}",
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
              Container(
                color: kcPrimaryColor, // Set the background color to blue
                padding: EdgeInsets.all(7.0), // Add padding to the container
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Expanded(
                            flex: 6, // Allocate 60% of the space to this widget
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
                                      image: NetworkImage(product.pictures![0].location!),
                                    ),
                                    color: kcWhiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(width: 8), // Add some spacing between the image and text
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
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
                            Expanded(
                            flex: 3, // Allocate 60% of the space to this widget
                            child: Row(
                              children: [
                                Text(
                                  " N${product.productPrice}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                            ),


                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${product.orders?.where((element) => element["availability"] != 1).toList().length} sold out of ${product.stock}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),

                              SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  value: ((product.orders
                                      ?.where((element) => element["status"] != 1)
                                      .toList()
                                      .length)! /
                                      (product.stock!)),
                                  backgroundColor: kcSecondaryColor.withOpacity(0.3),
                                  valueColor:
                                  const AlwaysStoppedAnimation(kcSecondaryColor),
                                ),
                              ),

                              Text(
                                (product.raffle == null || product.raffle!.isEmpty)
                                    ? ""
                                    : "Draw Date: ${DateFormat("d MMM").format(DateTime.parse(product.raffle?[0].startDate ?? DateTime.now().toIso8601String()))}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              userLoggedIn.value == false
                                  ? const SizedBox()
                                  : SubmitButton(
                                isLoading: false,
                                label: "Add to cart",
                                submit: () => viewModel.addToCart(product),
                                color: kcSecondaryColor,
                                boldText: true,
                                icon: Icons.shopping_bag_outlined,
                              ),

                            ],
                          ),
                        ),



                      ],
                    ),
                  )
                ],
              )

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
