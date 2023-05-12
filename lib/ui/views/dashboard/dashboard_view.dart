import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          children: [
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: kcWhiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/logo_light.png"),
                  const Icon(Icons.search)
                ],
              ),
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/car.png"),
                    fit: BoxFit.cover,
                  )),
            ),
            verticalSpaceMedium,
            const Text(
              "Selling fast",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kcMediumGrey,
              ),
            ),
            verticalSpaceSmall,
            SizedBox(
              height: 200,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      margin:
                          const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                      width: 330,
                      decoration: BoxDecoration(
                          color: kcWhiteColor,
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
                                const Text(
                                  "Win Ferrari",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                verticalSpaceTiny,
                                const Text(
                                  "Stand a chance to win 2023 ferrari",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
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
                                        borderRadius: BorderRadius.circular(5),
                                      ))),
                                  onPressed: () {},
                                  child: const Text(
                                    "Learn More",
                                    style: TextStyle(color: kcWhiteColor),
                                  ),
                                ),
                                verticalSpaceTiny,
                                const Text(
                                  "800  sold out of 2000",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                verticalSpaceTiny,
                                SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    value: 0.4,
                                    backgroundColor:
                                        kcSecondaryColor.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation(
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
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/car_alt.png"))),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            verticalSpaceSmall,
            const Text(
              "Recommended",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kcMediumGrey,
              ),
            ),
            verticalSpaceSmall,
            Container(
              height: 230,
              decoration: BoxDecoration(
                  color: kcWhiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kcBlackColor.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    )
                  ]),
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/laptop.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Win Macbook pro 2020",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Buy Flipflop for:",
                                      style: TextStyle(color: kcBlackColor)),
                                  TextSpan(
                                      text: "\$7.50",
                                      style: TextStyle(
                                        color: kcSecondaryColor,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "800  sold out of 2000",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            verticalSpaceTiny,
                            SizedBox(
                              width: 100,
                              child: LinearProgressIndicator(
                                value: 0.4,
                                backgroundColor:
                                    kcSecondaryColor.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation(
                                    kcSecondaryColor),
                              ),
                            ),
                            verticalSpaceSmall,
                            const Text(
                              "Draw date: 26th April",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
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
            ),
            verticalSpaceMedium,
            SubmitButton(
              isLoading: false,
              label: "Add to cart",
              submit: () {},
              color: kcPrimaryColor,
              boldText: true,
              icon: Icons.shopping_cart_outlined,
            )
          ],
        ),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}
