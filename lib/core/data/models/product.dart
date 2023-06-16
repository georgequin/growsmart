class Product {
  String? id;
  String? productName;
  String? productDescription;
  int? productPrice;
  bool? featured;
  String? created;
  String? updated;
  Category? category;
  List<Pictures>? pictures;
  List<RaffleAd>? raffleAd;

  Product({
    this.id,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.featured,
    this.created,
    this.updated,
    this.category,
    this.pictures,
    this.raffleAd,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    featured = json['featured'];
    created = json['created'];
    updated = json['updated'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    if (json['raffleAd'] != null) {
      raffleAd = <RaffleAd>[];
      json['raffleAd'].forEach((v) {
        raffleAd!.add(RaffleAd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice;
    data['featured'] = featured;
    data['created'] = created;
    data['updated'] = updated;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (raffleAd != null) {
      data['raffleAd'] = raffleAd!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? description;
  bool? status;
  String? created;
  String? updated;

  Category(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.created,
      this.updated});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Pictures {
  String? id;
  String? token;
  String? location;
  String? create;
  String? updated;

  Pictures({this.id, this.token, this.location, this.create, this.updated});

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    location = json['location'];
    create = json['create'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['location'] = location;
    data['create'] = create;
    data['updated'] = updated;
    return data;
  }
}

class RaffleAd {
  String? id;
  String? adName;
  String? adDescription;
  bool? featured;
  bool? status;
  String? created;
  String? updated;

  RaffleAd(
      {this.id,
      this.adName,
      this.adDescription,
      this.featured,
      this.status,
      this.created,
      this.updated});

  RaffleAd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adName = json['ad_name'];
    adDescription = json['ad_description'];
    featured = json['featured'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ad_name'] = adName;
    data['ad_description'] = adDescription;
    data['featured'] = featured;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}
