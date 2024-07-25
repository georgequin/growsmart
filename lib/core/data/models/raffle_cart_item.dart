import 'package:growsmart/core/data/models/product.dart';

class RaffleCartItem {
  Raffle? raffle;
  int? quantity;

  RaffleCartItem({this.raffle, this.quantity});

  RaffleCartItem.fromJson(Map<String, dynamic> json) {
    raffle =
        json['raffle'] != null ? Raffle.fromJson(json['raffle']) : null;
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (raffle != null) {
      data['raffle'] = raffle!.toJson();
    }
    data['quantity'] = quantity;
    return data;
  }
}
