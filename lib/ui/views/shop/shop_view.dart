import 'dart:async';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/productcard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/models/category.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../widget/AdventureDialog.dart';
import 'shop_viewmodel.dart';

/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

class ShopView extends StackedView<ShopViewModel> {
  ShopView({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget builder(
    BuildContext context,
    ShopViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.onboarded == false &&
        viewModel.showDialog &&
        !viewModel.modalShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.modalShown =
            true; // Set this to true to prevent showing the modal again
        showDialog(
          barrierColor: Colors.black.withOpacity(0.9),
          context: context,
          builder: (BuildContext context) {
            return const AdventureModal();
          },
        ).then((_) {
          // Once the modal is dismissed, update the onboarded status
          locator<LocalStorage>().save(LocalStorageDir.onboarded, true);
          viewModel.showDialog = false;
          viewModel.modalShown =
              false; // Reset it in case the user reopens the view later
        });
      });
    }

    final List<Map<String, String>> slides = [
    {
      'image': 'assets/images/shop_solar.jpeg',
      'title': 'Solar Energy Systems',
      'description': 'explore',
      'username': 'Paul Martine',
      'userType': 'Premium',
    },
    {
      'image': 'assets/images/shop_light.jpeg',
      'title': 'Electronics',
      'description': 'Get the best deals',
      'username': 'Alice Jones',
      'userType': 'Gold Member',
    },
    {
      'image': 'assets/images/shop_light2.jpeg',
      'title': 'lighting',
      'description': 'Light up your world',
      'username': 'John Doe',
      'userType': 'Elite',
    },
  ];

    // return SafeArea(
    //   child: Scaffold(
    //     body: NestedScrollView(
    //       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //         return [
    //           SliverOverlapAbsorber(
    //             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //             sliver: SliverAppBar(
    //               expandedHeight: 300.0,
    //               pinned: true,
    //               floating: true,
    //               flexibleSpace:  FlexibleSpaceBar(
    //                 background: CarouselSlider.builder(
    //                   options: CarouselOptions(
    //                     height: 300,
    //                     viewportFraction: 1.0,
    //                     autoPlay: true,
    //                   ),
    //                   itemCount: slides.length,
    //                   itemBuilder: (BuildContext context, int index, int pageIndex) {
    //                     final slide = slides[index];
    //                     return Stack(
    //                       fit: StackFit.expand,
    //                       children: [
    //                         Image.asset(
    //                           slide['image']!,
    //                           fit: BoxFit.cover,
    //                         ),
    //                         Container(
    //                           color: Colors.black.withOpacity(0.3),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.all(20.0),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.end,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Spacer(),
    //                               Text(
    //                                 slide['title']!,
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontSize: 28,
    //                                   fontWeight: FontWeight.bold,
    //                                 ),
    //                               ),
    //                               Text(
    //                                 slide['description']!,
    //                                 style: TextStyle(
    //                                   color: Colors.white70,
    //                                   fontSize: 18,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     );
    //                   },
    //                 ),
    //               ),
    //               actions: [
    //                 Autocomplete<Product>(
    //
    //                   optionsBuilder: (TextEditingValue productTextEditingValue) {
    //
    //                     // if user is input nothing
    //                     if (productTextEditingValue.text == '') {
    //                       return const Iterable<Product>.empty();
    //                     }
    //
    //                     // if user is input something the build
    //                     // suggestion based on the user input
    //                     return viewModel.filteredProductList.where((Product product) {
    //                       final query = productTextEditingValue.text.toLowerCase();
    //                       return (product.productName != null && product.productName!.toLowerCase().contains(query)) ||
    //                           (product.brandName != null && product.brandName!.toLowerCase().contains(query));
    //                     });
    //
    //                   },
    //                   displayStringForOption: (Product product) => product.productName ?? '',
    //
    //                   // when user click on the suggested
    //                   // item this function calls
    //                   onSelected: (Product value) {
    //                     debugPrint('You just selected $value.productName');
    //                     showModalBottomSheet(
    //                       context: context,
    //                       isScrollControlled: true,
    //                       isDismissible: true,
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.only(
    //                             topLeft: Radius.circular(25.0),
    //                             topRight: Radius.circular(25.0)),
    //                       ),
    //                       // barrierColor: Colors.black.withAlpha(50),
    //                       // backgroundColor: Colors.transparent,
    //                       backgroundColor: Colors.black.withOpacity(0.7),
    //                       builder: (BuildContext context) {
    //                         return ProductCard(product: value);
    //                       },
    //                     );
    //                   },
    //                     fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    //                       return Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //                         child: ConstrainedBox(
    //                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // Set a maximum width constraint
    //                           child: Container(
    //                             padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //                             decoration: BoxDecoration(
    //                               border: Border.all(color: const Color(0xFFEBE4E4)), // Grey border around the search bar
    //                               borderRadius: BorderRadius.circular(8.0), // Rounded corners
    //                             ),
    //                             child: Row(
    //                               mainAxisSize: MainAxisSize.min, // Prevents the Row from expanding infinitely
    //                               children: [
    //                                 Flexible( // Use Flexible instead of Expanded
    //                                   fit: FlexFit.loose,
    //                                   child: TextField(
    //                                     controller: textEditingController,
    //                                     focusNode: focusNode,
    //                                     decoration: InputDecoration(
    //                                       hintText: 'Search product...',
    //                                       border: InputBorder.none, // Removes the default border
    //                                       contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Adjust padding
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 IconButton(
    //                                   icon: Icon(Icons.search), // Search icon outside the text field
    //                                   onPressed: () {
    //                                     // Optionally handle search button press here
    //                                   },
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     }
    //
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ];
    //       },
    //       body: Builder(
    //         builder: (BuildContext context) {
    //           return CustomScrollView(
    //             slivers: [
    //               SliverOverlapInjector(
    //                 handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //               ),
    //               SliverToBoxAdapter(
    //                 child: Transform.translate(
    //                   offset: Offset(0, -20),
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //                     child:  Column(
    //                       children: [
    //                         SingleChildScrollView(
    //                           scrollDirection: Axis.horizontal,
    //                           child: Row(
    //                             children: viewModel.filteredCategories.map((category) {
    //                               return _buildCategoryChip(category, viewModel);
    //                             }).toList(),
    //                           ),
    //                         ),
    //                         popularDrawsSlider(context, viewModel),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //
    //             ],
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true, // This line makes the app bar extend behind the body.
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  expandedHeight: 300.0,
                  pinned: true,
                  floating: true,
                  collapsedHeight: 80.0,
                  backgroundColor: Colors.transparent, // Transparent background for blending
                  elevation: 0, // Remove shadow for a smooth look
                  flexibleSpace: FlexibleSpaceBar(
                    background: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 1.0,
                        autoPlay: true,
                      ),
                      itemCount: slides.length,
                      itemBuilder: (BuildContext context, int index, int pageIndex) {
                        final slide = slides[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              slide['image']!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text(
                                    slide['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    slide['description']!,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    Autocomplete<Product>(

                        optionsBuilder: (TextEditingValue productTextEditingValue) {

                          // if user is input nothing
                          if (productTextEditingValue.text == '') {
                            return const Iterable<Product>.empty();
                          }

                          // if user is input something the build
                          // suggestion based on the user input
                          return viewModel.filteredProductList.where((Product product) {
                            final query = productTextEditingValue.text.toLowerCase();
                            return (product.productName != null && product.productName!.toLowerCase().contains(query)) ||
                                (product.brandName != null && product.brandName!.toLowerCase().contains(query));
                          });

                        },
                        displayStringForOption: (Product product) => product.productName ?? '',

                        // when user click on the suggested
                        // item this function calls
                        onSelected: (Product value) {
                          debugPrint('You just selected $value.productName');
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0)),
                            ),
                            // barrierColor: Colors.black.withAlpha(50),
                            // backgroundColor: Colors.transparent,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            builder: (BuildContext context) {
                              return ProductCard(product: value);
                            },
                          );
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // Set a maximum width constraint
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFEBE4E4)), // Grey border around the search bar
                                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Prevents the Row from expanding infinitely
                                  children: [
                                    Flexible( // Use Flexible instead of Expanded
                                      fit: FlexFit.loose,
                                      child: TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          hintText: 'Search product...',
                                          border: InputBorder.none, // Removes the default border
                                          contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Adjust padding
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.search), // Search icon outside the text field
                                      onPressed: () {
                                        // Optionally handle search button press here
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                    ),
                  ],
                ),
              ),
            ];
          },
          body: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, -0), // Shift the grid upwards
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: viewModel.filteredCategories.map((category) {
                                  return _buildCategoryChip(category, viewModel);
                                }).toList(),
                              ),
                            ),
                            popularDrawsSlider(context, viewModel),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );






  }


  Widget popularDrawsSlider(
      BuildContext context, ShopViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8,
          ),
          itemCount: viewModel.filteredProductList.length,
          itemBuilder: (context, index) {
            final item = viewModel.filteredProductList[index];
            return InkWell(
              onTap: (){
                showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0)),
                                ),
                                // barrierColor: Colors.black.withAlpha(50),
                                // backgroundColor: Colors.transparent,
                                backgroundColor: Colors.black.withOpacity(0.7),
                                builder: (BuildContext context) {
                                  return ProductCard(product: item);
                                },
                              );
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Colors.purple[50]
                      : Colors.pink[50], // Alternating background colors
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with "NEW" badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kcSecondaryColor),
                              ),
                            ),
                            imageUrl: (item.images != null && item.images!.isNotEmpty)
                                ? item.images!.first
                                : 'https://via.placeholder.com/120',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                        // "NEW" badge
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Rating stars
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            Icons.star,
                            color: starIndex < item.rating!.toInt()
                                ? kcStarColor
                                : Colors.grey,
                            size: 16,
                          );
                        }),
                      ),
                    ),

                    // Product title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.productName ?? 'Product name',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Price and Cart icon
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child:
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '₦${item.price}' ?? "\$0",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'roboto',
                                  color: kcPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // To prevent overflow
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                RaffleCartItem newItem = RaffleCartItem(
                                    raffle: item,
                                    quantity: 1);
                                viewModel.addToRaffleCart(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                    8.0), // Padding around the icon
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: kcSecondaryColor,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildShimmerOrContent(
      BuildContext context, ShopViewModel viewModel) {
    if (viewModel.filteredProductList.isEmpty && viewModel.isBusy) {
      return Column(
        children: [
          _buildShimmerContainer(), // shimmer for video player placeholder
          verticalSpaceSmall,
          _buildShimmerQuickActions(), // shimmer for quick actions
          verticalSpaceMedium,
          _buildShimmerQuickActions(), // shimmer for quick actions
          verticalSpaceMedium,
          _buildShimmerSlider(), // shimmer for raffle list
          verticalSpaceMedium,
          _buildShimmerSlider(), // shimmer for donations
        ],
      );
    } else {
      return Column(
        children: [
          Autocomplete<Product>(

            optionsBuilder: (TextEditingValue productTextEditingValue) {

              // if user is input nothing
              if (productTextEditingValue.text == '') {
                return const Iterable<Product>.empty();
              }

              // if user is input something the build
              // suggestion based on the user input
              return viewModel.filteredProductList.where((Product product) {
                final query = productTextEditingValue.text.toLowerCase();
                return (product.productName != null && product.productName!.toLowerCase().contains(query)) ||
                    (product.brandName != null && product.brandName!.toLowerCase().contains(query));
              });

            },
            displayStringForOption: (Product product) => product.productName ?? '',

            // when user click on the suggested
            // item this function calls
            onSelected: (Product value) {
              debugPrint('You just selected $value.productName');
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                // barrierColor: Colors.black.withAlpha(50),
                // backgroundColor: Colors.transparent,
                backgroundColor: Colors.black.withOpacity(0.7),
                builder: (BuildContext context) {
                  return ProductCard(product: value);
                },
              );
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEBE4E4)), // Grey border around the search bar
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Search product...',
                            border: InputBorder.none, // Removes the default border
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Adjust padding
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search), // Search icon outside the text field
                        onPressed: () {
                          // Optionally handle search button press here
                        },
                      ),
                    ],
                  ),
                ),
              );
            },

          ),
          verticalSpaceSmall,

          // quickActions(context),
          verticalSpaceMedium,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: viewModel.filteredCategories.map((category) {
                return _buildCategoryChip(category, viewModel);
              }).toList(),
            ),
          ),
          verticalSpaceMedium,
          popularDrawsSlider(context, viewModel),
          verticalSpaceSmall,
        ],
      );
    }
  }


  Widget _buildShimmerContainer() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: kcSecondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildShimmerQuickActions() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildShimmerSlider() {
    return Shimmer.fromColors(
      baseColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: uiMode.value == AppUiModes.dark
          ? Colors.grey[300]!
          : Colors.grey[100]!,
      child: Container(
        height: 300, // Adjust the height as per your design
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(Category category, ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(
          category.name ?? '',
          style: GoogleFonts.redHatDisplay(
            textStyle: const TextStyle(),
          ),
        ),
        selected: category.id ==
            viewModel.selectedId, // Check if this category is selected
        onSelected: (bool selected) {
          viewModel.setSelectedCategory(
              selected ? category.id : 0); // Update viewModel properly
          viewModel.notifyListeners(); // Notify the listeners to rebuild the UI
        },
        selectedColor: kcSecondaryColor,
        backgroundColor: uiMode.value == AppUiModes.dark
            ? Colors.grey[500]!
            : Colors.grey[100]!,
        labelStyle: TextStyle(
          color:
              category.id == viewModel.selectedId ? Colors.white : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: uiMode.value == AppUiModes.dark
                ? Colors.grey[500]!
                : Colors.grey[100]!, // Set the border color to light grey
            width: 1.0, // Set the border width
          ),
          borderRadius: BorderRadius.circular(
              30.0), // Reduce the border radius (adjust this value)
        ),
      ),
    );
  }

  @override
  void onViewModelReady(ShopViewModel viewModel) {
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
  void onDispose(ShopViewModel viewModel) {
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
  ShopViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ShopViewModel();
}

class RaffleRow extends StatelessWidget {
  final Raffle raffle;
  final ShopViewModel viewModel;
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
            children: [],
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


//
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class ShopView extends StatelessWidget {
//   final List<Map<String, String>> slides = [
//     {
//       'image': 'https://via.placeholder.com/120',
//       'title': 'The Ultimate Collection',
//       'description': 'Step into style',
//       'username': 'Paul Martine',
//       'userType': 'Premium',
//     },
//     {
//       'image': 'https://via.placeholder.com/120',
//       'title': 'Exclusive Offer',
//       'description': 'Get the best deals',
//       'username': 'Alice Jones',
//       'userType': 'Gold Member',
//     },
//     {
//       'image': 'https://via.placeholder.com/120',
//       'title': 'New Arrivals',
//       'description': 'Fresh styles for you',
//       'username': 'John Doe',
//       'userType': 'Elite',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverOverlapAbsorber(
//               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//               sliver: SliverAppBar(
//                 expandedHeight: 300.0,
//                 pinned: true,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: CarouselSlider.builder(
//                     options: CarouselOptions(
//                       height: 300,
//                       viewportFraction: 1.0,
//                       autoPlay: true,
//                     ),
//                     itemCount: slides.length,
//                     itemBuilder: (BuildContext context, int index, int pageIndex) {
//                       final slide = slides[index];
//                       return Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.network(
//                             slide['image']!,
//                             fit: BoxFit.cover,
//                           ),
//                           Container(
//                             color: Colors.black.withOpacity(0.3),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 CircleAvatar(
//                                   backgroundImage: AssetImage(
//                                       "assets/images/binance.png"), // Replace with actual image
//                                   radius: 24,
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   slide['username']!,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   slide['userType']!,
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   slide['title']!,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   slide['description']!,
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: Icon(Icons.favorite),
//                     onPressed: () {},
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.shopping_cart),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ];
//         },
//         body: Builder(
//           builder: (BuildContext context) {
//             return CustomScrollView(
//               slivers: [
//                 SliverOverlapInjector(
//                   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Transform.translate(
//                     offset: Offset(0, -30), // Shift the grid upwards
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2, // Number of columns in the grid
//                           mainAxisSpacing: 10.0,
//                           crossAxisSpacing: 10.0,
//                           childAspectRatio: 0.7,
//                         ),
//                         itemCount: 10,
//                         itemBuilder: (context, index) => ProductCardShop(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCardShop extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 1,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 'https://via.placeholder.com/120',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('\$34.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text(
//                   'Stripe Details Jersey Track Top',
//                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   "Men's shoes",
//                   style: TextStyle(fontSize: 12, color: Colors.black38),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
