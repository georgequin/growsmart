import 'package:afriprize/core/data/models/country.dart';
import 'package:afriprize/core/data/models/discount.dart';
import 'package:afriprize/core/data/models/product.dart';

class Profile {
  String? id;
  String? email;
  String? password;
  String? oauthProvider;
  String? oauthId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? verificationCode;
  String? profilePicture;
  bool? canPayInstallmentally;
  UserStatus? status;
  List<Address>? addresses;  // List to hold multiple addresses

  Profile({
    this.id,
    this.email,
    this.password,
    this.oauthProvider,
    this.oauthId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.verificationCode,
    this.profilePicture,
    this.canPayInstallmentally,
    this.status,
    this.addresses,
  });

  // Constructor for creating Profile object from JSON
  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    oauthProvider = json['oauthProvider'];
    oauthId = json['oauthId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    verificationCode = json['verificationCode'];
    profilePicture = json['profilePicture'];
    canPayInstallmentally = json['canPayInstallmentally'];
    status = json['status'] != null ? UserStatus.values.firstWhere((e) => e.toString() == 'UserStatus.${json['status']}') : null;

    // Parsing addresses from JSON array
    if (json['addresses'] != null) {
      addresses = List<Address>.from(json['addresses'].map((address) => Address.fromJson(address)));
    }
  }

  // Method for converting Profile object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['oauthProvider'] = oauthProvider;
    data['oauthId'] = oauthId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['verificationCode'] = verificationCode;
    data['profilePicture'] = profilePicture;
    data['canPayInstallmentally'] = canPayInstallmentally;
    data['status'] = status?.toString().split('.').last;

    // Serializing addresses to JSON
    if (addresses != null) {
      data['addresses'] = addresses!.map((address) => address.toJson()).toList();
    }

    return data;
  }
}

// Enum for user status
enum UserStatus { Active, Inactive }

// Address model to represent address objects
class Address {
  String? id;
  String? street;
  String? city;
  String? state;
  String? country;
  String? postalCode;

  Address({
    this.id,
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  // Constructor for creating Address object from JSON
  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
  }

  // Method for converting Address object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postalCode'] = postalCode;
    return data;
    }
}

// Model for NotificationPreferences
class NotificationPreferences {
  bool? platformNotifications;
  bool? appNotifications;
  bool? generalNotifications;
  String? id;

  NotificationPreferences({
    this.platformNotifications,
    this.appNotifications,
    this.generalNotifications,
    this.id,
  });

  NotificationPreferences.fromJson(Map<String, dynamic> json) {
    platformNotifications = json['platform_notifications'];
    appNotifications = json['app_notifications'];
    generalNotifications = json['general_notifications'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform_notifications'] = platformNotifications;
    data['app_notifications'] = appNotifications;
    data['general_notifications'] = generalNotifications;
    data['_id'] = id;
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
