import 'dart:async';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/views/dashboard/productcard.dart';
import 'package:afriprize/ui/views/dashboard/raffle_detail.dart';
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
import 'package:slide_countdown/slide_countdown.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_bottom_sheet_flutter/top_bottom_sheet_flutter.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/models/category.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/project.dart';
import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../widget/AdventureDialog.dart';
import '../draws/draws_viewmodel.dart';
import '../notification/projectDetailsPage.dart';
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

    return Scaffold(
      appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: uiMode,
            builder: (context, AppUiModes mode, child) {
              return SvgPicture.asset(
                "assets/images/easy_power_logo.svg",
                width: 150,
                height: 40,
              );
            },
          ),
          centerTitle: false,
          actions:
          _buildAppBarActions(context, viewModel.appBarLoading, viewModel)),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
          children: [
            _buildShimmerOrContent(context, viewModel),
          ],
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
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0, // Added space between items
            childAspectRatio: 0.8, // Adjust height relative to width
          ),
          itemCount: viewModel.productList.length,
          itemBuilder: (context, index) {
            final item = viewModel.productList[index];
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

  Widget buildParticipantsAvatars(List<Participant> participants) {
    return SizedBox(
      height: 25, // Adjust the size to match the avatar size
      child: Stack(
        children: participants.asMap().entries.map((entry) {
          int index = entry.key;
          Participant participant = entry.value;
          double overlapOffset = 20.0; // Control the overlap amount
          return Positioned(
            left: index * overlapOffset,
            child: participant.profilePic?.url != null
                ? ClipOval(
                    child: Image.network(
                      participant.profilePic!.url!,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  )
                : _buildInitialsCircle(
                    participant), // Show initials if no image
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInitialsCircle(Participant participant) {
    String initials = _getInitials(participant);
    return CircleAvatar(
      radius: 12, // Adjust the size if needed
      backgroundColor: kcSecondaryColor, // Customize background color
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white, // Text color for initials
          fontSize: 12, // Adjust the font size if needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(Participant participant) {
    String firstName =
        participant.firstname?.isNotEmpty == true ? participant.firstname! : '';
    String lastName =
        participant.lastname?.isNotEmpty == true ? participant.lastname! : '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  Widget donationsSlider(BuildContext context, List<ProjectResource> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Popular Draws Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Donations",
                  style: GoogleFonts.bricolageGrotesque(
                    textStyle: TextStyle(
                      fontSize: 16, // Custom font size
                      fontWeight: FontWeight.w700, // Custom font weight
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.white // Dark mode logo
                          : Colors.black, // Custom text color (optional)
                    ),
                  ),
                ),
                Text(
                  "Empower Change with Your Points",
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.white // Dark mode logo
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Explore Capsule
            InkWell(
              onTap: () {
                locator<NavigationService>().navigateToNotificationView();
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
          height: 250, // Adjust height to match the size of your cards
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailsPage(
                          project: projects[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 222,
                    decoration: BoxDecoration(
                      color: uiMode.value == AppUiModes.dark
                          ? Colors.transparent // Dark mode logo
                          : kcWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: uiMode.value == AppUiModes.dark
                          ? kcDarkGreyColor // Dark mode logo
                          : kcWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              imageUrl!,
                              width: double.infinity, // or specify a width
                              height: 124, // or specify a height
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                            child: Text(
                              project?.projectTitle ?? 'service title',
                              style: GoogleFonts.redHatDisplay(
                                fontSize: 16,
                                color: uiMode.value == AppUiModes.dark
                                    ? kcWhiteColor // Dark mode logo
                                    : kcBlackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0, 8.0, 8.0),
                            child: Text(
                              project?.projectDescription ?? '',
                              style: GoogleFonts.redHatDisplay(
                                fontSize: 12,
                                color: uiMode.value == AppUiModes.dark
                                    ? kcWhiteColor // Dark mode logo
                                    : kcBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: buildMembersAvatars(members ?? []),
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

  Widget buildMembersAvatars(List<Member> participants) {
    double avatarSize = 20.0;
    double overlapOffset = 15.0; // Adjust the overlap amount

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Constrain the Stack with a specific width
        SizedBox(
          height: avatarSize,
          width: participants.length * overlapOffset +
              avatarSize, // Ensure a finite width
          child: Stack(
            children: participants.asMap().entries.map((entry) {
              int index = entry.key;
              Member participant = entry.value;

              return Positioned(
                left: index * overlapOffset,
                child: ClipOval(
                  child: participant.profilePic?.url != null
                      ? Image.network(
                          participant.profilePic!.url!,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                        )
                      : _buildMembersInitialsCircle(participant),
                ),
              );
            }).toList(),
          ),
        ),
        Text(
          ' ${participants.length} Participants',
          style: GoogleFonts.redHatDisplay(
            fontSize: 10,
            color: uiMode.value == AppUiModes.dark
                ? kcWhiteColor // Dark mode logo
                : kcBlackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMembersInitialsCircle(Member participant) {
    String initials = _getMemberInitials(participant);
    return CircleAvatar(
      radius: 10, // Adjust the size if needed
      backgroundColor: kcSecondaryColor, // Customize background color
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white, // Text color for initials
          fontSize: 10, // Adjust the font size if needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getMemberInitials(Member participant) {
    String firstName =
        participant.firstname?.isNotEmpty == true ? participant.firstname! : '';
    String lastName =
        participant.lastname?.isNotEmpty == true ? participant.lastname! : '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  Widget _buildShimmerOrContent(
      BuildContext context, ShopViewModel viewModel) {
    if (viewModel.raffleList.isEmpty && viewModel.isBusy) {
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 8.0),
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: TextField(
          //             decoration: InputDecoration(
          //               hintText: 'Search',
          //               border: InputBorder.none,
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           icon: Icon(Icons.search),
          //           onPressed: () {
          //             // Handle search button press
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Autocomplete<Product>(

            optionsBuilder: (TextEditingValue productTextEditingValue) {

              // if user is input nothing
              if (productTextEditingValue.text == '') {
                return const Iterable<Product>.empty();
              }

              // if user is input something the build
              // suggestion based on the user input
              return viewModel.productList.where((Product product) {
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
                    border: Border.all(color: Colors.grey), // Grey border around the search bar
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

  Widget _buildVideContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: kcSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _notificationIcon(
      int unreadCount, BuildContext context, ShopViewModel viewModel) {
    print('notif count is $unreadCount');
    return Stack(
      children: [
        IconButton(
            icon: SvgPicture.asset(
              uiMode.value == AppUiModes.dark
                  ? "assets/images/dashboard_otification_white.svg" // Dark mode logo
                  : "assets/images/dashboard_otification.svg",
              width: 30,
              height: 30,
            ),
            onPressed: () {
              _showNotificationSheet(context, viewModel);
            }),
        if (unreadCount > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: BoxConstraints(minWidth: 10, minHeight: 10),
              child: Text(
                unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 6),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationSheet(
      BuildContext context, ShopViewModel viewModel) {
    // viewModel.markAllNotificationsAsRead();

    TopModalSheet.show(
        context: context,
        isShowCloseButton: true,
        closeButtonRadius: 20.0,
        closeButtonBackgroundColor: kcSecondaryColor,
        child: Container(
          color: kcWhiteColor,
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text("Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.value.length,
                  itemBuilder: (context, index) {
                    final notification = notifications.value[index];
                    return ListTile(
                      minLeadingWidth: 10,
                      leading: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: SvgPicture.asset(
                          'assets/icons/ticket_out.svg',
                          height: 28,
                        ),
                      ),
                      title: Text(
                        notification.subject,
                        style: GoogleFonts.redHatDisplay(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        notification.message,
                        style: GoogleFonts.redHatDisplay(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: kcDarkGreyColor,
                          ),
                        ),
                      ),
                      trailing: notification.unread
                          ? Icon(Icons.circle, color: Colors.red, size: 10)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
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

  List<Widget> _buildAppBarActions(
      BuildContext context, bool isLoading, ShopViewModel viewModel) {
    if (isLoading) {
      // Display the shimmer effect while loading
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 0.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      width: 80, // Adjust width for the shimmer
                      height: 20, // Adjust height for the shimmer
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ];
    } else {
      // Normal display when data is loaded
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (userLoggedIn.value == true) ...[
                _notificationIcon(unreadCount.value, context, viewModel),
                const SizedBox(width: 3),
                InkWell(
                  onTap: () {
                    locator<NavigationService>().navigateTo(Routes.wallet);
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 0.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: kcPrimaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          '${profile.value.accountPoints} points',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/dashboard_wallet.svg",
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                InkWell(
                  onTap: () {
                    locator<NavigationService>().navigateTo(Routes.authView);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: kcSecondaryColor
                          .withOpacity(0.2), // Capsule background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded capsule shape
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: kcBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
      ];
    }
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
