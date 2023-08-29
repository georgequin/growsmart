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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import 'dashboard_viewmodel.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

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
                            itemCount: viewModel.ads.length,
                            onPageChanged: viewModel.changeSelected,
                            itemBuilder: (context, index) {
                              Product ad = viewModel.ads[index];
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
            verticalSpaceMedium,
            const Text(
              "Selling fast",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceSmall,
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
              "Products",
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
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.productList.length,
                    itemBuilder: (context, index) {
                      Product product = viewModel.productList[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              locator<NavigationService>().navigateTo(
                                  Routes.productDetail,
                                  arguments:
                                      ProductDetailArguments(product: product));
                            },
                            child: ProductRow(
                              product: product,
                            ),
                          ),
                          verticalSpaceMedium,
                          userLoggedIn.value == false
                              ? const SizedBox()
                              : SubmitButton(
                                  isLoading: false,
                                  label: "Add to cart",
                                  submit: () => viewModel.addToCart(product),
                                  color: kcPrimaryColor,
                                  boldText: true,
                                  icon: Icons.shopping_cart_outlined,
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

  const ProductRow({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 250,
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
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: (product.raffle == null || product.raffle!.isEmpty)
                    ? SizedBox(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.network(
                        product.raffle![0].pictures![0].location!,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                      ),
              ),
              Positioned(
                top: 20,
                left: 20,
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
                              product.raffle![0].pictures![0].location!),
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
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    image: product.pictures!.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(product.pictures![0].location!)),
                    color: kcWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (product.raffle == null || product.raffle!.isEmpty)
                            ? ""
                            : product.raffle?[0].ticketName ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Buy ${product.productName} for: ",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: uiMode.value == AppUiModes.light
                                      ? kcBlackColor
                                      : kcWhiteColor,
                                )),
                            TextSpan(
                                text: " N${product.productPrice}",
                                style: GoogleFonts.inter(
                                    color: kcSecondaryColor, fontSize: 12))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${product.orders?.where((element) => element["status"] != 1).toList().length} sold out of ${product.stock}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    verticalSpaceTiny,
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
                    verticalSpaceSmall,
                    Text(
                      (product.raffle == null || product.raffle!.isEmpty)
                          ? ""
                          : "Draw date: ${DateFormat("d MMM").format(DateTime.parse(product.raffle?[0].startDate ?? DateTime.now().toIso8601String()))}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
