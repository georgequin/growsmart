import 'package:afriprize/core/data/models/app_notification.dart';
import 'package:afriprize/core/data/models/raffle_cart_item.dart';
import 'package:flutter/material.dart';

import 'core/data/models/cart_item.dart';
import 'core/data/models/product.dart';
import 'core/data/models/profile.dart';

enum AppUiModes { dark, light }
enum AppModules { raffle, shop }
enum PaymentMethod { wallet, payStack, binancePay, flutterWave, applePay }

ValueNotifier<List<Product>> ads = ValueNotifier([]);
ValueNotifier<List<RaffleCartItem>> raffleCart = ValueNotifier([]);
ValueNotifier<List<CartItem>> shopCart = ValueNotifier([]);
ValueNotifier<Profile> profile = ValueNotifier(Profile());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<int> dollarRate = ValueNotifier(1500);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
ValueNotifier<AppModules> currentModuleNotifier = ValueNotifier(AppModules.raffle);


void switchModule(AppModules module) {
  currentModuleNotifier.value = module;
}
