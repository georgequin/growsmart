import 'package:afriprize/core/data/models/product.dart';

class Ad {
  String? id;
  String? adName;
  String? adDescription;
  bool? featured;
  bool? status;
  String? created;
  String? updated;
  Product? product;
  List<Pictures>? pictures;
  Raffledraw? raffledraw;
  Category? category;

  Ad(
      {this.id,
        this.adName,
        this.adDescription,
        this.featured,
        this.status,
        this.created,
        this.updated,
        this.product,
        this.pictures,
        this.raffledraw,
        this.category});

  Ad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adName = json['ad_name'];
    adDescription = json['ad_description'];
    featured = json['featured'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    raffledraw = json['raffledraw'] != null
        ? Raffledraw.fromJson(json['raffledraw'])
        : null;
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
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
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (raffledraw != null) {
      data['raffledraw'] = raffledraw!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}