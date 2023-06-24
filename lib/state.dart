import 'package:afriprize/core/data/models/product.dart';
import 'package:flutter/material.dart';

import 'core/data/models/cart_item.dart';
import 'core/data/models/profile.dart';

ValueNotifier<List<CartItem>> cart = ValueNotifier([]);
ValueNotifier<Profile> profile = ValueNotifier(Profile());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);

