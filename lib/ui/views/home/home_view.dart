import 'package:afriprize/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:afriprize/ui/common/app_colors.dart';

import 'home_viewmodel.dart';
import 'module_switch.dart';



class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    // You can use ValueListenableBuilder to react to changes in currentModuleNotifier
    return ValueListenableBuilder<AppModules>(
      valueListenable: currentModuleNotifier, // Your ValueNotifier
      builder: (context, currentModule, child) {
        bool showModuleSwitch = currentModule == AppModules.raffle
            ? viewModel.selectedRafflesTab == 0
            : viewModel.selectedShopTab == 0;
        return Scaffold(
          appBar: AppBar(
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
            Color iconColor = mode == AppUiModes.dark ? Colors.white : Colors.black;
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
              backgroundColor: mode == AppUiModes.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
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
        icon: _navBarItemIcon(Icons.home_outlined, "Home", viewModel.selectedRafflesTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon(Icons.bar_chart_outlined, "Draws", viewModel.selectedRafflesTab == 1, iconColor),
        label: "Draws",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter(Icons.shopping_cart_outlined, viewModel.selectedRafflesTab == 2, raffleCart, iconColor),
        label: "Cart",
      ),
      //TODO : MAKE SURE TO CHECK WHY THE VALUE ISNT CORRECT
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter(Icons.notifications_none, viewModel.selectedRafflesTab == 3, filteredNotifications, iconColor),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon(Icons.person_outline, "Profile", viewModel.selectedRafflesTab == 4, iconColor),
        label: "Profile",
      ),
    ];
  }

  List<BottomNavigationBarItem> _shopItems(Color iconColor, Color selectedColor, ValueListenable<List<dynamic>> filteredNotifications) {
    return [
      BottomNavigationBarItem(
        icon: _navBarItemIcon(Icons.home_outlined, "Home", viewModel.selectedShopTab == 0, iconColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon(Icons.bar_chart_outlined, "Draws", viewModel.selectedShopTab == 1, iconColor),
        label: "Draws",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter(Icons.shopping_cart_outlined, viewModel.selectedShopTab == 2, raffleCart, iconColor),
        label: "Cart",
      ),
      //TODO : MAKE SURE TO CHECK WHY THE VALUE ISNT CORRECT
      BottomNavigationBarItem(
        icon: _navBarItemWithCounter(Icons.notifications_none, viewModel.selectedShopTab == 3, filteredNotifications, iconColor),
        label: "Notifications",
      ),
      BottomNavigationBarItem(
        icon: _navBarItemIcon(Icons.menu_outlined, "Profile", viewModel.selectedShopTab == 4, iconColor),
        label: "Menu",
      ),
    ];
  }

  Widget _navBarItemIcon(IconData iconData, String label, bool isSelected, Color iconColor) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? kcSecondaryColor.withOpacity(0.2) : Colors.transparent,
        ),
        child: Icon(
          iconData,
          color: isSelected ? kcSecondaryColor : iconColor,
        )
    );
  }

  Widget _navBarItemWithCounter(IconData icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: counterListenable,
      builder: (context, value, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _navBarItemIcon(icon, '', isSelected, color),
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

