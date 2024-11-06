import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/notification/projectDetailsPage.dart';
import 'package:flutter/material.dart';
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
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
                    _buildServiceItem(
                      context,
                      'assets/images/siteevaluation.png',
                      'Site Suitability Evaluation',
                      'Assess the suitability of your site for solar panel installation.',
                      '100\$',
                    ),
                    _buildServiceItem(
                      context,
                      'assets/images/Panelcleaning.png',
                      'Panel Cleaning',
                      'Professional solar panel cleaning services.',
                      '100\$',
                    ),
                    _buildServiceItem(
                      context,
                      'assets/images/Inverterinstallation.png',
                      'Inverter Installation',
                      'Expert inverter installation services.',
                      '100\$',
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

  Widget _buildServiceItem(BuildContext context, String imagePath, String title, String description, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 100,
                width: 86,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.redHatDisplay(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: GoogleFonts.redHatDisplay(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.more_vert),
                SizedBox(height: 16.0),
                Text(
                  price,
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  ServicesviewModel viewModelBuilder(BuildContext context) {
    return ServicesviewModel();
  }
}
