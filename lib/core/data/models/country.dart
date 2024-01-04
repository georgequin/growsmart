

class Country {
  String? id;
  String? name;
  String? currency;
  String? capital;
  String? continent;
  String? code;
  String? code3;
  int? phone;
  int? shippingFee;
  String? created;
  String? updated;

  Country(
      {this.id,
        this.name,
        this.currency,
        this.capital,
        this.continent,
        this.code,
        this.code3,
        this.phone,
        this.shippingFee,
        this.created,
        this.updated});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    currency = json['currency'];
    capital = json['capital'];
    shippingFee = json['shipping_fee'];
    continent = json['continent'];
    code = json['code'];
    code3 = json['code3'];
    phone = json['phone'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['currency'] = currency;
    data['capital'] = capital;
    data['shipping_fee'] = shippingFee;
    data['continent'] = continent;
    data['code'] = code;
    data['code3'] = code3;
    data['phone'] = phone;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}
