import 'package:afriprize/core/data/models/product.dart';

class RaffleCartItem {
  Product? raffle;
  int? quantity;

  RaffleCartItem({this.raffle, this.quantity});

  RaffleCartItem.fromJson(Map<String, dynamic> json) {
    raffle =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (raffle != null) {
      data['product'] = raffle!.toJson();
    }
    data['quantity'] = quantity;
    return data;
  }
}
