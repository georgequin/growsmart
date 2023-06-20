import 'package:afriprize/core/data/models/product.dart';

class OrderItem {
  String? id;
  int? quantity;
  int? status;
  String? created;
  String? updated;
  User? user;
  Product? product;
  Tracking? tracking;
  List<Transaction>? transaction;

  OrderItem({
    this.id,
    this.quantity,
    this.status,
    this.created,
    this.updated,
    this.user,
    this.product,
    this.tracking,
    this.transaction,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    tracking =
        json['tracking'] != null ? Tracking.fromJson(json['tracking']) : null;
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (tracking != null) {
      data['tracking'] = tracking!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? country;
  int? verified;
  int? status;
  int? role;
  String? created;
  String? updated;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.country,
      this.verified,
      this.status,
      this.role,
      this.created,
      this.updated});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    verified = json['verified'];
    status = json['status'];
    role = json['role'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['country'] = country;
    data['verified'] = verified;
    data['status'] = status;
    data['role'] = role;
    data['created'] = created;
    data['updated'] = updated;
    return data;
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

  Transaction(
      {this.id,
      this.status,
      this.amount,
      this.reference,
      this.meta,
      this.type,
      this.created,
      this.updated});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
    reference = json['reference'];
    meta = json['meta'];
    type = json['type'];
    created = json['created'];
    updated = json['updated'];
  }

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
    return data;
  }
}