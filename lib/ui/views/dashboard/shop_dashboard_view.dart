import 'dart:async';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/shop_details.dart';
import 'package:afriprize/utils/money_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

import '../../../core/data/models/product.dart';
import 'dashboard_viewmodel.dart';

class ShopDashboardView extends StackedView<DashboardViewModel> {
  ShopDashboardView({Key? key}) : super(key: key);


  final PageController _pageController = PageController();

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DB),
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
                child: VideoPlayer(viewModel.controller),
              ),
            ),

            verticalSpaceSmall,
            const Text(
              "Products",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                  fontFamily: "Panchang"
              ),
            ),
            verticalSpaceSmall,

            viewModel.busy(viewModel.productList)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.productList.isEmpty ?
            const Center(child: Text('No products available')) :
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.7,
                ),
                itemCount: viewModel.productList.length,
                itemBuilder: (context, index) {
                  if (viewModel.productList.isEmpty) {
                    return Container();
                  }
                  if (index >= viewModel.productList.length) {
                    return Container();
                  }

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
                                child: ShopDetail(product: product),
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

  @override
  void onDispose(DashboardViewModel viewModel) {
    viewModel.dispose();
  }
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
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //product image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(12)),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0, // Make the loader thinner
                          valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                        ),
                      ),
                      imageUrl: product.pictures?.first.location ?? 'https://via.placeholder.com/150',
                      height: 182,
                      // width: 90,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeOutDuration: const Duration(milliseconds: 300),
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
                                  product.pictures![0].location ?? ''),
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
              Container(
                color: Colors.transparent, // Set the background color to blue
                padding: const EdgeInsets.all(7.0), // Add padding to the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? "",
                      style: const TextStyle(
                          fontSize: 10,

                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      MoneyUtils().formatAmountToDollars(product.productPrice ?? 0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Panchang",
                        fontSize: 13.8,
                        color: kcPrimaryColor, // Set the text color to white
                      ),
                    ),
                  ],
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
