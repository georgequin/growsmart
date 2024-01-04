import '../core/data/models/cart_item.dart';

int getSubTotal(List<CartItem> cart) {
  int total = 0;

  for (var element in cart) {
    total = total + (element.product!.productPrice! * element.quantity!);
  }

  return total;
}

int getDeliveryFee(List<CartItem> cart) {
  int total = 0;

  for (var element in cart) {
    total = total + (element.product!.shippingFee!);
  }

  return total;
}

int getTotalItems(List<CartItem> cart) {
  int quantity = 0;
  for (var element in cart) {
    quantity = quantity + element.quantity!;
  }

  return quantity;
}