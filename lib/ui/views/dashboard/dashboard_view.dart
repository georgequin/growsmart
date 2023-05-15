import 'package:afriprize/app/app.dart';
import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/ui/components/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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
        title: Image.asset("assets/images/logo_light.png"),
        actions: [
          Image.asset("assets/images/search.png"),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                    itemCount: 5,
                    onPageChanged: viewModel.changeSelected,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/car.png"),
                              fit: BoxFit.cover,
                            )),
                      );
                    }),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Row(
                    children: List.generate(
                        5,
                        (index) =>
                            _indicator(viewModel.selectedIndex == index)),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage("assets/images/sh.png")),
                          color: kcWhiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      verticalSpaceTiny,
                      const SizedBox(
                        width: 140,
                        child: Text(
                          "Buy snickers and stand a chance to win",
                          style: TextStyle(
                            fontSize: 12,
                            color: kcWhiteColor,
                          ),
                        ),
                      ),
                      verticalSpaceTiny,
                      const Text(
                        "2023 McLaren",
                        style: TextStyle(
                            fontSize: 16,
                            color: kcWhiteColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        color: kcWhiteColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text(
                        "Win Now",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
                    width: 350,
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
                              Text(
                                "Win Ferrari",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              verticalSpaceTiny,
                              Text(
                                "Stand a chance to win 2023 ferrari",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                ),
                              ),
                              verticalSpaceTiny,
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        kcPrimaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ))),
                                onPressed: () {},
                                child: Text(
                                  "Learn More",
                                  style: GoogleFonts.inter(color: kcWhiteColor),
                                ),
                              ),
                              verticalSpaceTiny,
                              Text(
                                "800  sold out of 2000",
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
                                  image:
                                      AssetImage("assets/images/car_alt.png"))),
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
          InkWell(
            onTap: () {
              locator<NavigationService>().navigateTo(Routes.productDetail);
            },
            child: Container(
              height: 250,
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
                  Stack(
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          "assets/images/laptop.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kcWhiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.star,
                                color: kcStarColor,
                                size: 20,
                              ),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/flip.png")),
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
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Buy Flipflop for: ",
                                      style: GoogleFonts.inter(
                                          color: kcBlackColor, fontSize: 12)),
                                  TextSpan(
                                      text: " \$7.50",
                                      style: GoogleFonts.inter(
                                          color: kcSecondaryColor,
                                          fontSize: 12))
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
    );
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

  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}
