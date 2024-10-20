import 'package:easy_power/core/data/models/app_notification.dart';
import 'package:easy_power/core/data/models/raffle_cart_item.dart';
import 'package:flutter/material.dart';

import 'core/data/models/cart_item.dart';
import 'core/data/models/product.dart';
import 'core/data/models/profile.dart';

enum AppUiModes { dark, light }

ValueNotifier<List<Product>> ads = ValueNotifier([]);
ValueNotifier<Profile> profile = ValueNotifier(Profile());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<int> dollarRate = ValueNotifier(1500);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);


