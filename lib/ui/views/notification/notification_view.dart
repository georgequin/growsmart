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

class Servicesview extends StackedView<ServicesviewModel> {
  const Servicesview({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      ServicesviewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(
        // Uncomment and adjust if you want to add a title or other AppBar elements
        // title: ValueListenableBuilder(
        //   valueListenable: uiMode,
        //   builder: (context, AppUiModes mode, child) {
        //     return SvgPicture.asset(
        //       uiMode.value == AppUiModes.dark
        //           ? "assets/images/dashboard_logo_white.svg" // Dark mode logo
        //           : "assets/images/dashboard_logo.svg",
        //       width: 150,
        //       height: 40,
        //     );
        //   },
        // ),
        // centerTitle: false,
        // actions: _buildAppBarActions(context, viewModel)
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
                    "Services",
                    style: GoogleFonts.redHatDisplay(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
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
                        hintStyle: GoogleFonts.redHatDisplay(
                          textStyle: const TextStyle(),
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
                  // Uncomment and adjust if you want to add a filter button
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
              verticalSpaceSmall,
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Site Suitability Evaluation'),
                            verticalSpaceMassive,
                            Container(
                              alignment: Alignment.bottomRight,
                                child: Text('\$100')),
                          ],
                        ),
                      ),
                    ),
                    // Add more items here as needed
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Text('Panel Cleaning'),
                          verticalSpaceMassive,
                          Container(
                              alignment: Alignment.bottomRight,
                              child: Text('\$100')),
                        ],
                      ),
                    ),
                    // Add more items here as needed
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Text('Inverter Installation'),
                          verticalSpaceMassive,
                          Container(
                              alignment: Alignment.bottomRight,
                              child: Text('\$100')),
                        ],
                      ),
                    ),
                    // Add more items here as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ServicesviewModel viewModelBuilder(BuildContext context) {
    return ServicesviewModel();
  }
}
