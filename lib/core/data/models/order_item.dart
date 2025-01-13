import 'package:afriprize/core/data/models/product.dart';
import 'package:afriprize/core/data/models/profile.dart';
import 'package:afriprize/core/data/models/raffle_ticket.dart';


class Order {
  final String id;
  final int quantity;
  final String orderType;
  final int shippingFee;
  final bool installmentPayment;
  final String userId;
  final String trackingNumber;
  final String orderNumber;
  final String status;
  final int totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.quantity,
    required this.orderType,
    required this.shippingFee,
    required this.installmentPayment,
    required this.userId,
    required this.trackingNumber,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      quantity: json['quantity'],
      orderType: json['orderType'],
      shippingFee: json['shippingFee'],
      installmentPayment: json['installmentPayment'],
      userId: json['userId'],
      trackingNumber: json['trackingNumber'],
      orderNumber: json['orderNumber'],
      status: json['status'],
      totalPrice: json['totalPrice'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Tracking {
  String? id;
  int? status;
  String? location;
  String? trackingNumber;
  String? comment;
  String? created;
  String? updated;

  Tracking(
      {this.id,
      this.status,
      this.location,
      this.trackingNumber,
      this.comment,
      this.created,
      this.updated});

  Tracking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    location = json['location'];
    trackingNumber = json['tracking_number'];
    comment = json['comment'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['location'] = location;
    data['tracking_number'] = trackingNumber;
    data['comment'] = comment;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Transaction {
  String? id;
  int? status;
  int? amount;
  String? reference;
  dynamic meta;
  int? type;
  String? created;
  String? updated;
  Shipping? shipping;
  // OrderItem? order;

  Transaction(
      {this.id,
      this.status,
      this.amount,
      this.reference,
      this.meta,
      this.type,
      this.created,
      this.updated,
      this.shipping,
      // this.order,
     });

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        amount = json['amount'],
        reference = json['reference'],
        meta = json['meta'],
        type = json['type'],
        created = json['created'],
        updated = json['updated'],
        shipping = json['shipping'];
        // order = (json['order']);

  // Transaction.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   status = json['status'];
  //   amount = json['amount'];
  //   reference = json['reference'];
  //   meta = json['meta'];
  //   type = json['type'];
  //   created = json['created'];
  //   updated = json['updated'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['amount'] = amount;
    data['reference'] = reference;
    data['meta'] = meta;
    data['type'] = type;
    data['created'] = created;
    data['updated'] = updated;
    data['shipping'] = shipping;
    return data;
  }
}

class Receipt {
  Transaction? transaction;
  RaffleTicket? ticket;

  Receipt(
      {
        this.transaction,
        this.ticket});

  Receipt.fromJson(Map<String, dynamic> json) {
    transaction = json['transaction'];
    ticket = json['ticket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction'] = transaction;
    data['ticket'] = ticket;
    return data;
  }
}
