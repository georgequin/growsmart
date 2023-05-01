import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            ),
            Expanded(
              flex: 10,
              child: viewModel.pages[viewModel.selectedTab],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(color: kcSecondaryColor),
        selectedItemColor: kcSecondaryColor,
        onTap: viewModel.changeSelected,
        currentIndex: viewModel.selectedTab,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/app_home.png",
              color:
                  viewModel.selectedTab == 0 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/draws.png",
              color:
                  viewModel.selectedTab == 1 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Draws",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/cart.png",
              color:
                  viewModel.selectedTab == 2 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/notification.png",
              color:
                  viewModel.selectedTab == 3 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/profile.png",
              color:
                  viewModel.selectedTab == 4 ? kcSecondaryColor : kcBlackColor,
            ),
            label: "Profile",
          )
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
