import 'package:afriprize/core/data/models/app_notification.dart';
import 'package:flutter/material.dart';

import 'core/data/models/cart_item.dart';
import 'core/data/models/product.dart';
import 'core/data/models/profile.dart';

enum AppUiModes { dark, light }
enum AppModules { raffle, shop }

ValueNotifier<List<Product>> ads = ValueNotifier([]);
ValueNotifier<List<CartItem>> raffleCart = ValueNotifier([]);
ValueNotifier<List<CartItem>> shopCart = ValueNotifier([]);
ValueNotifier<Profile> profile = ValueNotifier(Profile());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
ValueNotifier<AppModules> currentModuleNotifier = ValueNotifier(AppModules.raffle);


void switchModule(AppModules module) {
  currentModuleNotifier.value = module;
}
