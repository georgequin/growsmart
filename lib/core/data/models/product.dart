import 'package:growsmart/core/data/models/order_item.dart';

class Product {
  String? id;
  String? productName;
  String? productDescription;
  int? price;
  double? rating;
  int? availability;
  int? stock;
  bool? ad;
  bool? featured;
  bool? lowStockAlert;
  int? categoryId;
  int? verifiedSales;
  String? brandName;
  int? modelNumber;
  String? createdAt;
  String? updatedAt;
  List<String>? reviews;
  List<String>? images;

  Product({
    this.id,
    this.productName,
    this.productDescription,
    this.price,
    this.rating,
    this.availability,
    this.stock,
    this.ad,
    this.featured,
    this.lowStockAlert,
    this.categoryId,
    this.verifiedSales,
    this.brandName,
    this.modelNumber,
    this.createdAt,
    this.updatedAt,
    this.reviews,
    this.images,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    price = int.tryParse(json['price']?.toString() ?? '0'); // Convert price to int
    rating = double.tryParse(json['rating']?.toString() ?? '0.0');
    availability = json['availability'];
    stock = json['stock'];
    ad = json['ad'];
    featured = json['featured'];
    lowStockAlert = json['lowStockAlert'];
    categoryId = json['categoryId'] is int ? json['categoryId'] : int.tryParse(json['categoryId']?.toString() ?? '0'); // Convert categoryId to int
    verifiedSales = json['verifiedSale'];
    brandName = json['brandName'];
    modelNumber = json['modelNumber'] is int ? json['modelNumber'] : int.tryParse(json['modelNumber']?.toString() ?? '0'); // Convert modelNumber to int
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    reviews = json['reviews'] != null ? List<String>.from(json['reviews']) : null;
    images = json['images'] != null ? List<String>.from(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['price'] = price;
    data['rating'] = rating;
    data['availability'] = availability;
    data['stock'] = stock;
    data['ad'] = ad;
    data['featured'] = featured;
    data['lowStockAlert'] = lowStockAlert;
    data['categoryId'] = categoryId;
    data['verifiedSale'] = verifiedSales;
    data['brandName'] = brandName;
    data['modelNumber'] = modelNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (reviews != null) {
      data['reviews'] = reviews;
    }
    if (images != null) {
      data['images'] = images;
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

  Category({
    this.id,
    this.name,
    this.description,
    this.status,
    this.created,
    this.updated,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = (json['status'].runtimeType == int)
        ? json["status"] == 1
            ? true
            : false
        : json['status'];

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
  int? type;
  bool? isPopup;
  bool? front;
  String? create;
  String? updated;

  Pictures(
      {this.id,
      this.token,
      this.location,
      this.type,
      this.isPopup,
      this.front,
      this.create,
      this.updated});

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    location = json['location'];
    type = json['type'];
    isPopup = json['isPopup'];
    front = json['front'];
    create = json['create'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['location'] = location;
    data['type'] = type;
    data['isPopup'] = isPopup;
    data['front'] = front;
    data['create'] = create;
    data['updated'] = updated;
    return data;
  }
}

class Raffle {
  String? id;
  String? ticketName;
  String? ticketDescription;
  String? ticketTracking;
  bool? featured;
  int? status;
  String? startDate;
  String? endDate;
  String? created;
  String? updated;
  Category? category;
  List<Pictures>? pictures;
  Product? product;
  int? rafflePrice;
  int? verifiedSales;
  int? stockTotal;
  Raffle({
    this.id,
    this.ticketName,
    this.ticketDescription,
    this.ticketTracking,
    this.featured,
    this.status,
    this.startDate,
    this.endDate,
    this.created,
    this.updated,
    this.category,
    this.pictures,
    this.product,
    this.rafflePrice,
    this.verifiedSales,
    this.stockTotal,
  });

  Raffle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketName = json['ticket_name'];
    ticketDescription = json['ticket_description'];
    ticketTracking = json['ticket_tracking'];
    featured = json['featured'];
    rafflePrice = json['raffle_price'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    created = json['created'];
    updated = json['updated'];
    verifiedSales = json['verified_sales'];
    stockTotal = json['stock_total'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_name'] = ticketName;
    data['ticket_description'] = ticketDescription;
    data['ticket_tracking'] = ticketTracking;
    data['featured'] = featured;
    data['raffle_price'] = rafflePrice;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created'] = created;
    data['updated'] = updated;
    data['verified_sales'] = verifiedSales;
    data['stock_total'] = stockTotal;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Review {
  String? id;
  String? comment;
  int? rating;
  String? created;
  String? updated;
  Product? product;
  User? user;

  Review({
    this.id,
    this.comment,
    this.rating,
    this.created,
    this.updated,
    this.product,
    this.user,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    created = json['created'];
    updated = json['updated'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['comment'] = comment;
    data['created'] = created;
    data['updated'] = updated;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
