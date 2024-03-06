import 'package:afriprize/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/app_colors.dart';

import 'home_viewmodel.dart';
import 'module_switch.dart';

/**
 * @author George David
 * email: georgequin19@gmail.com
 * Feb, 2024
 **/


class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    viewModel.checkForUpdates(context);
    // You can use ValueListenableBuilder to react to changes in currentModuleNotifier
    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier, // Your ValueNotifier
      builder: (context, currentModule, child) {
        bool showModuleSwitch = currentModule == AppModules.raffle
            ? viewModel.selectedRafflesTab == 0
            : viewModel.selectedShopTab == 0;
        return Scaffold(
          backgroundColor: currentModuleNotifier.value == AppModules.shop ? Color(0xFFFFF3DB) : null,
          appBar: AppBar(
            backgroundColor: currentModule == AppModules.shop && uiMode.value == AppUiModes.light
                ? Color(0xFFFFF3DB)
                : uiMode.value == AppUiModes.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
            title: showModuleSwitch ? ModuleSwitch(
              isRafflesSelected: currentModule == AppModules.raffle,
              onToggle: (isRafflesSelected) {
                viewModel.toggleModule(isRafflesSelected);
              },
            ) : Text(currentModule == AppModules.raffle ? 'Raffles' : 'Shop'),
            actions: const [
              // IconButton(
              //   icon: Icon(Icons.swap_horiz),
              //   onPressed: () {
              //     viewModel.toggleModule();
              //   },
              // ),
            ],
          ),
          body: viewModel.currentPage, // Assuming you have separate getters for pages in your viewModel
          bottomNavigationBar: BottomNavBar(viewModel: viewModel),
        );
      },
    );
  }


  @override
  HomeViewModel viewModelBuilder(
      BuildContext context,
      ) =>
      HomeViewModel();
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier,
      builder: (context, currentModule, _) {
        return ValueListenableBuilder<AppUiModes>(
          valueListenable: uiMode,
          builder: (context, mode, _) {
            Color iconColor = mode == AppUiModes.dark ? Colors.white : Colors.grey;
            Color selectedColor = mode == AppUiModes.dark ? Colors.white : kcSecondaryColor;
            ValueListenable<List<dynamic>> filteredNotifications = ValueNotifier(
                notifications.value.where((notification) => notification.status != 1).toList());

            List<BottomNavigationBarItem> items = (currentModule == AppModules.raffle)
                ? _rafflesItems(iconColor, selectedColor, filteredNotifications)
                : _shopItems(iconColor, selectedColor, filteredNotifications);

            int currentIndex = (currentModule == AppModules.raffle)
                ? viewModel.selectedRafflesTab
                : viewModel.selectedShopTab;

            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: currentModule == AppModules.shop && mode == AppUiModes.light
                  ? Color(0xFFFFF3DB)
                  : mode == AppUiModes.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
              selectedLabelStyle: TextStyle(color: selectedColor),
              selectedItemColor: selectedColor,
              unselectedItemColor: iconColor,
              onTap: (index) => viewModel.changeSelected(index, currentModule),
              currentIndex: currentIndex,
              items: items,
            );
          },
        );
      },
    );
  }

  List<BottomNavigationBarItem> _rafflesItems(Color iconColor, Color selectedColor, ValueListenable<List<dynamic>> filteredNotifications) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home.svg', viewModel.selectedRafflesTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home_ticket.svg',  viewModel.selectedRafflesTab == 1, iconColor),
        label: "Draws",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter('buy.svg', viewModel.selectedRafflesTab == 2, raffleCart, iconColor),
        label: "Cart",
      ),
      //TODO : MAKE SURE TO CHECK WHY THE VALUE ISNT CORRECT
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter('notification.svg', viewModel.selectedRafflesTab == 3, filteredNotifications, iconColor),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('menu.svg', viewModel.selectedRafflesTab == 4, iconColor),
        label: "Menu",
      ),
    ];
  }

  List<BottomNavigationBarItem> _shopItems(Color iconColor, Color selectedColor, ValueListenable<List<dynamic>> filteredNotifications) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home.svg',  viewModel.selectedShopTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('home_ticket.svg', viewModel.selectedShopTab == 1, iconColor),
        label: "Draws",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter('buy.svg', currentModuleNotifier.value == AppModules.shop ? viewModel.selectedShopTab == 2 : viewModel.selectedRafflesTab == 2, currentModuleNotifier.value == AppModules.raffle ? raffleCart : shopCart, iconColor),
        label: "Cart",
      ),
      //TODO : MAKE SURE TO CHECK WHY THE VALUE ISNT CORRECT
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter('notification.svg', viewModel.selectedShopTab == 3, filteredNotifications, iconColor),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon('menu.svg', viewModel.selectedShopTab == 4, iconColor),
        label: "Menu",
      ),
    ];
  }

  Widget _navBarItemIcon(String iconData, bool isSelected, Color iconColor) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? kcSecondaryColor.withOpacity(0.2) : Colors.transparent,
        ),
        child: SvgPicture.asset(
          'assets/icons/$iconData',
          height: 16, // Icon size
          color: isSelected ? kcSecondaryColor : iconColor,
        ),


        // Icon(
        //   iconData,
        //   color: isSelected ? kcSecondaryColor : iconColor,
        // )
    );
  }

  Widget _navBarItemWithCounter(String icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: counterListenable,
      builder: (context, value, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _navBarItemIcon(icon,  isSelected, color),
            if (value.isNotEmpty)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${value.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }


}

