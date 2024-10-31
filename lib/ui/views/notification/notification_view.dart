
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/notification/projectDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:top_bottom_sheet_flutter/top_bottom_sheet_flutter.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/project.dart';
import '../../common/app_colors.dart';
import 'notification_viewmodel.dart';

class NotificationView extends StackedView<NotificationViewModel> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: uiMode,
            builder: (context, AppUiModes mode, child) {
              return SvgPicture.asset(
                uiMode.value == AppUiModes.dark
                    ? "assets/images/dashboard_logo_white.svg" // Dark mode logo
                    : "assets/images/dashboard_logo.svg",
                width: 150,
                height: 40,
              );
            },
          ),
          centerTitle: false,
          actions: _buildAppBarActions(context, viewModel)

      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // viewModel.getDonationsCategories();
          viewModel.getProjects();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
          children: [
          verticalSpaceSmall,
          Row(
            children: [
               Text(
                "Donations",
                style: GoogleFonts.redHatDisplay(
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: viewModel.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.redHatDisplay(
                      textStyle: const TextStyle(
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: uiMode.value == AppUiModes.dark
                        ? Colors.grey[500]!
                        : Colors.grey[100]!,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // const SizedBox(width: 10.0),
              // Container(
              //   padding: const EdgeInsets.all(10.0),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[100],
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: const Icon(Icons.filter_list),
              // ),
            ],
          ),
          verticalSpaceSmall,
          // Wrap Row in SingleChildScrollView to allow horizontal scrolling
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: viewModel.filteredCategories.map((category) {
          //       return _buildCategoryChip(category, viewModel);
          //     }).toList(),
          //   ),
          // ),
          verticalSpaceSmall,
          // Expanded to allow ListView to take remaining screen space
          Expanded(
            child:

            viewModel.isBusy && viewModel.filteredProjectResource.isEmpty
                ? ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            )
                : viewModel.filteredProjectResource.isEmpty
                ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: const EmptyState(
                    animation: "empty_notifications.json",
                    label: "No Donations Yet",
                  ),
                ),
              ],
            ) :




            ListView.builder(
              itemCount: viewModel.filteredProjectResource.length,
              itemBuilder: (context, index) {
                final projectResource = viewModel.filteredProjectResource[index];
                final project = viewModel.filteredProjectResource[index].project;
                final members = viewModel.filteredProjectResource[index].members;
                final imageUrl = project?.media?.isNotEmpty == true
                    ? project?.media![0].url
                    : 'https://via.placeholder.com/150';
                return Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsPage(
                            project: projectResource,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 238, // You can adjust the height here
                      child: Container(
                        decoration: BoxDecoration(
                          color: uiMode.value == AppUiModes.dark ? kcDarkGreyColor : kcWhiteColor,
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
                          color: uiMode.value == AppUiModes.dark ? kcDarkGreyColor : kcWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        imageUrl!,
                                        width: double.infinity,
                                        height: 124, // You can control this height
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                                        child: Text(
                                          project?.projectTitle ?? 'service title',
                                          style: GoogleFonts.redHatDisplay(
                                            textStyle:  TextStyle(
                                              fontSize: 20,
                                              color: uiMode.value == AppUiModes.dark ? kcWhiteColor : kcBlackColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                                        child: Text(
                                          project?.projectDescription ?? '',
                                          style: GoogleFonts.redHatDisplay(
                                            textStyle:  TextStyle(
                                              fontSize: 12,
                                              color: uiMode.value == AppUiModes.dark ? kcWhiteColor : kcBlackColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/partcipant_icon.png",
                                              width: 44,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${members?.length ?? 0} Members',
                                              style: GoogleFonts.redHatDisplay(
                                                textStyle:  TextStyle(
                                                  color: uiMode.value == AppUiModes.dark ? kcLightGrey : kcDarkGreyColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
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
                  ),
                );
              },
            ),
          )
          ],
        ),
        ),
      ),
    );
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();


  @override
  void onViewModelReady(NotificationViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }


  // Widget _buildCategoryChip(Category category, NotificationViewModel viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //     child: ChoiceChip(
  //       label: Text(category.name ?? '', style: GoogleFonts.redHatDisplay(
  //         textStyle: const TextStyle(
  //         ),
  //       ),),
  //       selected: category.id == viewModel.selectedId, // Check if this category is selected
  //       onSelected: (bool selected) {
  //         viewModel.setSelectedCategory(selected ? category.id! : ''); // Update viewModel properly
  //         viewModel.notifyListeners();  // Notify the listeners to rebuild the UI
  //       },
  //       selectedColor: kcSecondaryColor,
  //       backgroundColor: uiMode.value == AppUiModes.dark
  //           ? Colors.grey[500]!
  //           : Colors.grey[100]!,
  //       labelStyle: TextStyle(
  //         color: category.id == viewModel.selectedId ? Colors.white : Colors.black,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide(
  //           color: uiMode.value == AppUiModes.dark
  //               ? Colors.grey[500]!
  //               : Colors.grey[100]!,  // Set the border color to light grey
  //           width: 1.0,                // Set the border width
  //         ),
  //         borderRadius: BorderRadius.circular(30.0), // Reduce the border radius (adjust this value)
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _buildAppBarActions(BuildContext context, NotificationViewModel viewModel) {

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
                      // Container(
                      //   margin: const EdgeInsets.only(right: 0.0),
                      //   padding: const EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     color: kcPrimaryColor.withOpacity(0.1),
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(5.0),
                      //       bottomLeft: Radius.circular(5.0),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     '${profile.value.accountPoints} points',
                      //     style: const TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //       fontFamily: 'Roboto',
                      //     ),
                      //   ),
                      // ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: kcSecondaryColor.withOpacity(0.2), // Capsule background color
                      borderRadius: BorderRadius.circular(10), // Rounded capsule shape
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

  Widget _notificationIcon(int unreadCount, BuildContext context, NotificationViewModel viewModel) {
    print('notif count is $unreadCount');
    return Stack(
      children: [
        IconButton(
            icon: SvgPicture.asset(
              uiMode.value == AppUiModes.dark
                  ? "assets/images/dashboard_otification_white.svg" // Dark mode logo
                  : "assets/images/dashboard_otification.svg", width: 30, height: 30,),
            onPressed: (){_showNotificationSheet(context, viewModel);}
        ),
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

  void _showNotificationSheet(BuildContext context, NotificationViewModel viewModel) {

    TopModalSheet.show(
        context: context,
        isShowCloseButton: true,
        closeButtonRadius: 20.0,
        closeButtonBackgroundColor: kcSecondaryColor,
        child: Container(
          color: uiMode.value == AppUiModes.dark ? kcDarkGreyColor : kcWhiteColor,
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: uiMode.value == AppUiModes.dark ? kcWhiteColor : kcBlackColor)),
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
                          textStyle:  TextStyle(
                            fontSize: 14,
                            color: uiMode.value == AppUiModes.dark ? kcWhiteColor : kcBlackColor,
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
                      trailing: notification.unread ? Icon(Icons.circle, color: Colors.red, size: 10) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }



  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: uiMode.value == AppUiModes.dark
            ? Colors.grey[700]!
            : Colors.grey[300]!,
        highlightColor: uiMode.value == AppUiModes.dark
            ? Colors.grey[300]!
            : Colors.grey[100]!,
        child: Container(
          height: 238, // Card height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer Search Bar
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50, // Search bar height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16.0), // Spacing after the search bar

          // Shimmer Horizontal List of Capsules
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 80, // Capsule width
                    height: 30, // Capsule height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30), // Rounded capsule shape
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }




}
