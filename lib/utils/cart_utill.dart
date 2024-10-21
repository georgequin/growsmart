import 'package:afriprize/core/data/models/raffle_cart_item.dart';

import '../core/data/models/cart_item.dart';



int getRaffleSubTotal(List<RaffleCartItem> cart) {
  int total = 0;

  for (var element in cart) {
    total = total + (element.raffle!.ticketPrice! * element.quantity!);
  }

  return total;
}





int getTotalRaffleItems(List<RaffleCartItem> cart) {
  int quantity = 0;
  for (var element in cart) {
    quantity = quantity + element.quantity!;
  }

  return quantity;
}