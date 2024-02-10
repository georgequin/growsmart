import 'package:afriprize/core/data/models/order_item.dart';

class Product {
  String? id;
  String? productName;
  String? productDescription;
  int? productPrice;

  int? shippingFee;
  int? availability;
  int? verifiedSales;
  int? stockTotal;
  bool? featured;
  bool? lowStockAlert;
  int? stock;
  int? status;
  String? created;
  List<dynamic>? orders;
  String? updated;
  Category? category;
  List<Pictures>? pictures;
  List<dynamic>? reviews;
  List<Raffle>? raffle;

  Product(
      {this.id,
      this.productName,
      this.productDescription,
      this.productPrice,

      this.shippingFee,
      this.availability,
      this.verifiedSales,
      this.stockTotal,
      this.orders,
      this.featured,
      this.lowStockAlert,
      this.stock,
      this.status,
      this.created,
      this.updated,
      this.category,
      this.pictures,
      this.reviews,
      this.raffle});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    shippingFee = json['shipping_fee'];
    availability = json['availability'];
    verifiedSales = json['verified_sales'];
    stockTotal = json['stock_total'];
    featured = json['featured'];
    orders = json['orders'];
    lowStockAlert = json['low_stock_alert'];
    reviews = json['reviews'];
    stock = json['stock'];
    status = json['status'];
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
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews!.add(Review.fromJson(v));
      });
    }
    if (json['raffle'] != null) {
      raffle = <Raffle>[];
      json['raffle'].forEach((v) {
        raffle!.add(Raffle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice;
    data['shipping_fee'] = shippingFee;
    data['availability'] = availability;
    data['verified_sales'] = verifiedSales;
    data['stock_total'] = stockTotal;
    data['featured'] = featured;
    data['orders'] = orders;
    data['low_stock_alert'] = lowStockAlert;
    data['stock'] = stock;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (raffle != null) {
      data['raffle'] = raffle!.map((v) => v.toJson()).toList();
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
  Raffle(
      {this.id,
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

  Review(
      {this.id,
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
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
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
