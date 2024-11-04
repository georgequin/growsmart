import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/notification/projectDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  Expanded(
                    child: TextField(
                      onChanged: viewModel.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search on Easy Power',
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
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text(
                    "Services",
                    style: GoogleFonts.redHatDisplay(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              verticalSpaceSmall,
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                        height: 180,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerLeft,
                                        'assets/images/siteevaluation.png'),
                                  ],
                                ),
                                horizontalSpaceLarge,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        'Site Suitability Evaluation'),
                                    verticalSpaceMassive,
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text('\$100')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                        height: 180,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerLeft,
                                        'assets/images/Panelcleaning.png'),
                                  ],
                                ),
                                horizontalSpaceLarge,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        'Panel Cleaning'),
                                    verticalSpaceMassive,
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text('\$100')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                        height: 180,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerLeft,
                                        'assets/images/Inverterinstallation.png'),
                                  ],
                                ),
                                horizontalSpaceLarge,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        'Inverter Installation'),
                                    verticalSpaceMassive,
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text('\$100')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
