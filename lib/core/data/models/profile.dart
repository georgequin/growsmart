import 'package:afriprize/core/data/models/product.dart';

class Profile {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? country;
  int? verified;
  int? status;

  // dynamic role;
  List<Shipping>? shipping;
  String? created;
  String? updated;
  Wallet? wallet;
  List<Pictures>? pictures;

  Profile(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.country,
      this.verified,
      this.status,
      // this.role,
      this.created,
      this.updated,
      this.wallet,
      this.shipping,
      this.pictures});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    country = json['country'];
    verified = json['verified'];
    status = json['status'];
    // role = json['role'];
    if (json['picture'] != null) {
      pictures = <Pictures>[];
      json['picture'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    if (json['shipping'] != null) {
      shipping = <Shipping>[];
      json['shipping'].forEach((v) {
        shipping!.add(Shipping.fromJson(v));
      });
    }
    created = json['created'];
    updated = json['updated'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
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
    // data['role'] = role;
    data['created'] = created;
    data['updated'] = updated;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (pictures != null) {
      data['picture'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (shipping != null) {
      data['shipping'] = shipping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wallet {
  String? id;
  int? balance;
  String? created;
  String? updated;

  Wallet({this.id, this.balance, this.created, this.updated});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['balance'] = balance;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Shipping {
  String? id;
  String? shippingFirstname;
  String? shippingLastname;
  String? shippingPhone;
  String? shippingAdditionalPhone;
  String? shippingAddress;
  String? shippingAdditionalAddress;
  String? shippingState;
  String? shippingCity;
  int? shippingZipCode;
  bool? isDefault;

  Shipping(
      {this.id,
      this.shippingFirstname,
      this.shippingLastname,
      this.shippingPhone,
      this.shippingAdditionalPhone,
      this.shippingAddress,
      this.shippingAdditionalAddress,
      this.shippingState,
      this.isDefault,
      this.shippingCity,
      this.shippingZipCode});

  Shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingFirstname = json['shipping_firstname'];
    shippingLastname = json['shipping_lastname'];
    shippingPhone = json['shipping_phone'];
    shippingAdditionalPhone = json['shipping_additional_phone'];
    shippingAddress = json['shipping_address'];
    isDefault = json['default'];
    shippingAdditionalAddress = json['shipping_additional_address'];
    shippingState = json['shipping_state'];
    shippingCity = json['shipping_city'];
    shippingZipCode = json['shipping_zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipping_firstname'] = shippingFirstname;
    data['shipping_lastname'] = shippingLastname;
    data['shipping_phone'] = shippingPhone;
    data['shipping_additional_phone'] = shippingAdditionalPhone;
    data['shipping_address'] = shippingAddress;
    data['default'] = isDefault;
    data['shipping_additional_address'] = shippingAdditionalAddress;
    data['shipping_state'] = shippingState;
    data['shipping_city'] = shippingCity;
    data['shipping_zip_code'] = shippingZipCode;
    return data;
  }
}
