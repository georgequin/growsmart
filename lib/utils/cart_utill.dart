import 'package:afriprize/core/data/models/raffle_cart_item.dart';

import '../core/data/models/cart_item.dart';

int getShopSubTotal(List<CartItem> cart) {
  int total = 0;

  for (var element in cart) {
    total = total + (element.product!.productPrice! * element.quantity!);
  }

  return total;
}

int getRaffleSubTotal(List<RaffleCartItem> cart) {
  int total = 0;

  // for (var element in cart) {
  //   total = total + (element.raffle!.rafflePrice! * element.quantity!);
  // }

  return total;
}

int getDeliveryFee(List<CartItem> cart) {
  int total = 0;

  for (var element in cart) {
    total = total + (element.product!.shippingFee!);
  }

  return total;
}

int getTotalShopItems(List<CartItem> cart) {
  int quantity = 0;
  for (var element in cart) {
    quantity = quantity + element.quantity!;
  }

  return quantity;
}

int getTotalRaffleItems(List<RaffleCartItem> cart) {
  int quantity = 0;
  for (var element in cart) {
    quantity = quantity + element.quantity!;
  }

  return quantity;
}