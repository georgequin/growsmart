class Product {
  String? id;
  String? productName;
  String? productDescription;
  int? productPrice;
  int? stock;
  bool? featured;
  String? created;
  String? updated;
  Category? category;
  List<Pictures>? pictures;
  Raffle? raffle;

  Product(
      {this.id,
      this.productName,
      this.productDescription,
      this.productPrice,
      this.featured,
      this.stock,
      this.created,
      this.updated,
      this.category,
      this.pictures,
      this.raffle});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    featured = json['featured'];
    created = json['created'];
    updated = json['updated'];
    stock = json['stock'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
    raffle = json['raffle'] != null ? Raffle.fromJson(json['raffle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice;
    data['featured'] = featured;
    data['created'] = created;
    data['stock'] = stock;
    data['updated'] = updated;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    if (raffle != null) {
      data['raffle'] = raffle!.toJson();
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
  bool? front;

  Pictures({
    this.id,
    this.token,
    this.location,
    this.create,
    this.updated,
    this.front,
  });

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    location = json['location'];
    create = json['create'];
    front = json['front'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['location'] = location;
    data['create'] = create;
    data['front'] = front;
    data['updated'] = updated;
    return data;
  }
}

class Raffle {
  String? id;
  String? ticketName;
  String? ticketDescription;
  String? ticketTracking;
  int? status;
  List<Pictures>? pictures;
  String? startDate;
  String? endDate;
  String? created;
  String? updated;

  Raffle(
      {this.id,
      this.ticketName,
      this.ticketDescription,
      this.ticketTracking,
      this.status,
      this.pictures,
      this.startDate,
      this.endDate,
      this.created,
      this.updated});

  Raffle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketName = json['ticket_name'];
    ticketDescription = json['ticket_description'];
    ticketTracking = json['ticket_tracking'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    created = json['created'];
    updated = json['updated'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_name'] = ticketName;
    data['ticket_description'] = ticketDescription;
    data['ticket_tracking'] = ticketTracking;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created'] = created;
    data['updated'] = updated;
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
