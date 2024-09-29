import 'package:afriprize/core/data/models/country.dart';
import 'package:afriprize/core/data/models/discount.dart';
import 'package:afriprize/core/data/models/product.dart';

class Profile {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? phone;
  Country? country;
  bool? isUserVerified;
  String? status;
  String? accountType;
  int? accountPoints;
  String? accountPointsLocal;
  String? createdAt;
  String? updatedAt;
  Wallet? wallet; // Assuming this exists
  List<Discount>? discounts; // Assuming this exists
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
    id = json['_id']; // Match API response key for id
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];

    // Checking if 'country' object is not null and assigning it
    country = json['country'] != null ? Country.fromJson(json['country']) : null;

    // Boolean field directly from the API
    isUserVerified = json['is_user_verified'];

    // Status field changed to String in API response
    status = json['status'];

    // New fields from API
    accountType = json['account_type'];
    accountPoints = json['account_points'];
    accountPointsLocal = json['account_points_local'];

    // Timestamp fields
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    // Handle 'wallet' field if present in the response
    if (json['wallet'] != null) {
      wallet = Wallet.fromJson(json['wallet']);
    }

    // Handle 'referral' as discounts
    if (json['referral'] != null) {
      discounts = <Discount>[];
      json['referral'].forEach((v) {
        discounts!.add(Discount.fromJson(v));
      });
    }

    // Handle 'picture' as pictures list
    if (json['picture'] != null) {
      pictures = <Pictures>[];
      json['picture'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;

    // Handle country serialization
    if (country != null) {
      data['country'] = country!.toJson();
    }

    data['is_user_verified'] = isUserVerified;
    data['status'] = status;
    data['account_type'] = accountType;
    data['account_points'] = accountPoints;
    data['account_points_local'] = accountPointsLocal;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    // Handle wallet serialization
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }

    // Serialize referral as discounts
    if (discounts != null) {
      data['referral'] = discounts!.map((v) => v.toJson()).toList();
    }

    // Serialize pictures list
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
