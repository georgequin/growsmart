import 'package:afriprize/core/data/models/country.dart';
import 'package:afriprize/core/data/models/discount.dart';
import 'package:afriprize/core/data/models/product.dart';

class Profile {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username; // New field
  String? phone;
  Country? country;
  bool? isUserVerified; // Changed from int to bool
  String? status; // Changed from int to String
  String? accountType; // New field
  int? accountPoints; // New field
  String? accountPointsLocal; // New field
  String? createdAt; // Changed field name
  String? updatedAt; // Changed field name
  Wallet? wallet;
  List<Discount>? discounts;
  List<Pictures>? pictures;

  Profile({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.phone,
    this.country,
    this.isUserVerified,
    this.status,
    this.accountType,
    this.accountPoints,
    this.accountPointsLocal,
    this.createdAt,
    this.updatedAt,
    this.wallet,
    this.discounts,
    this.pictures,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Changed from 'id' to '_id'
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    username = json['username']; // New field
    phone = json['phone'];
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    isUserVerified = json['is_user_verified']; // Changed from 'verified' to 'is_user_verified'
    status = json['status']; // Changed from int to String
    accountType = json['account_type']; // New field
    accountPoints = json['account_points']; // New field
    accountPointsLocal = json['account_points_local']; // New field
    createdAt = json['createdAt']; // Changed field name
    updatedAt = json['updatedAt']; // Changed field name
    // Assuming wallet and discounts are not present in the current JSON
    if (json['wallet'] != null) {
      wallet = Wallet.fromJson(json['wallet']);
    }
    if (json['referral'] != null) {
      discounts = <Discount>[];
      json['referral'].forEach((v) {
        discounts!.add(Discount.fromJson(v));
      });
    }
    if (json['picture'] != null) {
      pictures = <Pictures>[];
      if (json['picture'].isNotEmpty) {
        json['picture'].forEach((v) {
          pictures!.add(Pictures.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id; // Changed from 'id' to '_id'
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['username'] = username; // New field
    data['phone'] = phone;
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['is_user_verified'] = isUserVerified; // Changed from 'verified' to 'is_user_verified'
    data['status'] = status; // Changed from int to String
    data['account_type'] = accountType; // New field
    data['account_points'] = accountPoints; // New field
    data['account_points_local'] = accountPointsLocal; // New field
    data['createdAt'] = createdAt; // Changed field name
    data['updatedAt'] = updatedAt; // Changed field name
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (discounts != null) {
      data['referral'] = discounts!.map((v) => v.toJson()).toList();
    }
    if (pictures != null) {
      data['picture'] = pictures!.map((v) => v.toJson()).toList();
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
