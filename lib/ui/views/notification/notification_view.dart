
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/notification/projectDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

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
              "assets/images/dashboard_logo.svg",
              width: 150,
              height: 40,
            );
          },
        ),
        actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/dashboard_otification.svg",
                    width: 150,
                    height: 25,
                  ),
                  // Login Button
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(right: 0.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: kcPrimaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0), // Set the radius value you prefer
                        bottomLeft: Radius.circular(5.0),
                      ),
                    ),
                    child: const Text("#0.00",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang")),
                  ),
                  SvgPicture.asset(
                    "assets/images/dashboard_wallet.svg",
                    width: 150,
                    height: 40,
                  ),
                ],
              ),
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.getDonationsCategories();
          viewModel.getProjects();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: viewModel.filteredCategories.isEmpty
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
          ) : Column(
          children: [
          verticalSpaceSmall,
          Row(
            children: [
              const Text(
                "Donations",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
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
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(Icons.filter_list),
              ),
            ],
          ),
          verticalSpaceSmall,
          // Wrap Row in SingleChildScrollView to allow horizontal scrolling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: viewModel.filteredCategories.map((category) {
                return _buildCategoryChip(category, viewModel);
              }).toList(),
            ),
          ),
          verticalSpaceSmall,
          // Expanded to allow ListView to take remaining screen space
          Expanded(
            child: ListView.builder(
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
                          color: kcWhiteColor,
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
                          color: kcWhiteColor,
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
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: kcBlackColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                                        child: Text(
                                          project?.projectDescription ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: kcBlackColor,
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
                                              style: const TextStyle(
                                                color: kcDarkGreyColor,
                                                fontSize: 13,
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


  Widget _buildCategoryChip(Category category, NotificationViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(category.name ?? ''),
        selected: category.id == viewModel.selectedId, // Check if this category is selected
        onSelected: (bool selected) {
          viewModel.setSelectedCategory(selected ? category.id! : ''); // Update viewModel properly
          viewModel.notifyListeners();  // Notify the listeners to rebuild the UI
        },
        selectedColor: kcSecondaryColor,
        backgroundColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: category.id == viewModel.selectedId ? Colors.white : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey[200]!,  // Set the border color to light grey
            width: 1.0,                // Set the border width
          ),
          borderRadius: BorderRadius.circular(30.0), // Reduce the border radius (adjust this value)
        ),
      ),
    );
  }



}
