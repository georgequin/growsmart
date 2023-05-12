import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'draws_viewmodel.dart';

class DrawsView extends StackedView<DrawsViewModel> {
  const DrawsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DrawsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Draws",
          style: TextStyle(color: kcBlackColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 30, right: 30),
        children: [
          Image.asset(
            "assets/images/raffle.png",
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: kcPrimaryColor),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prize:",
                    style: TextStyle(color: kcWhiteColor, fontSize: 18),
                  ),
                  verticalSpaceSmall,
                  const Text(
                    "Range Rover Sports",
                    style: TextStyle(
                        color: kcWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  verticalSpaceMedium,
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: kcWhiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      horizontalSpaceMedium,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Ticket No.",
                            style: TextStyle(color: kcWhiteColor, fontSize: 18),
                          ),
                          Text(
                            "001234456790",
                            style: TextStyle(
                                color: kcWhiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          verticalSpaceLarge,
          const Text(
            "Start time:",
            style: TextStyle(
              color: kcMediumGrey,
              fontSize: 20,
            ),
          ),
          const Text(
            "20th April 2023",
            style: TextStyle(
              color: kcMediumGrey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          verticalSpaceLarge,
          const Text(
            "End time:",
            style: TextStyle(
              color: kcMediumGrey,
              fontSize: 20,
            ),
          ),
          const Text(
            "29th April 2023",
            style: TextStyle(
              color: kcMediumGrey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  DrawsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DrawsViewModel();
}
