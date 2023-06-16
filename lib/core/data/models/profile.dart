class Profile {
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
  Wallet? wallet;

  Profile({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.country,
    this.verified,
    this.status,
    this.role,
    this.created,
    this.updated,
    this.wallet,
  });

  Profile.fromJson(Map<String, dynamic> json) {
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
    data['role'] = role;
    data['created'] = created;
    data['updated'] = updated;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
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
