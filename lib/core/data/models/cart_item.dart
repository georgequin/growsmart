import 'package:growsmart/core/data/models/product.dart';

class CartItem {
  Product? product;
  int? quantity;

  CartItem({this.product, this.quantity});

  CartItem.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    return data;
  }
}
