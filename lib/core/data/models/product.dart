import 'package:afriprize/core/data/models/order_item.dart';

// class Product {
//   String? id;
//   String? productName;
//   String? productDescription;
//   int? productPrice;
//
//   int? shippingFee;
//   int? availability;
//   int? verifiedSales;
//   int? stockTotal;
//   bool? featured;
//   bool? lowStockAlert;
//   int? stock;
//   int? status;
//   String? created;
//   List<dynamic>? orders;
//   String? updated;
//   Category? category;
//   List<Pictures>? pictures;
//   List<dynamic>? reviews;
//   List<Raffle>? raffle;
//
//   Product(
//       {this.id,
//       this.productName,
//       this.productDescription,
//       this.productPrice,
//
//       this.shippingFee,
//       this.availability,
//       this.verifiedSales,
//       this.stockTotal,
//       this.orders,
//       this.featured,
//       this.lowStockAlert,
//       this.stock,
//       this.status,
//       this.created,
//       this.updated,
//       this.category,
//       this.pictures,
//       this.reviews,
//       this.raffle});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     productDescription = json['product_description'];
//     productPrice = json['product_price'];
//     shippingFee = json['shipping_fee'];
//     availability = json['availability'];
//     verifiedSales = json['verified_sales'];
//     stockTotal = json['stock_total'];
//     featured = json['featured'];
//     orders = json['orders'];
//     lowStockAlert = json['low_stock_alert'];
//     reviews = json['reviews'];
//     stock = json['stock'];
//     status = json['status'];
//     created = json['created'];
//     updated = json['updated'];
//     category =
//         json['category'] != null ? Category.fromJson(json['category']) : null;
//     if (json['pictures'] != null) {
//       pictures = <Pictures>[];
//       json['pictures'].forEach((v) {
//         pictures!.add(Pictures.fromJson(v));
//       });
//     }
//     if (json['reviews'] != null) {
//       reviews = <Review>[];
//       json['reviews'].forEach((v) {
//         reviews!.add(Review.fromJson(v));
//       });
//     }
//     if (json['raffle'] != null) {
//       raffle = <Raffle>[];
//       json['raffle'].forEach((v) {
//         raffle!.add(Raffle.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_name'] = productName;
//     data['product_description'] = productDescription;
//     data['product_price'] = productPrice;
//     data['shipping_fee'] = shippingFee;
//     data['availability'] = availability;
//     data['verified_sales'] = verifiedSales;
//     data['stock_total'] = stockTotal;
//     data['featured'] = featured;
//     data['orders'] = orders;
//     data['low_stock_alert'] = lowStockAlert;
//     data['stock'] = stock;
//     data['status'] = status;
//     data['created'] = created;
//     data['updated'] = updated;
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     if (pictures != null) {
//       data['pictures'] = pictures!.map((v) => v.toJson()).toList();
//     }
//     if (reviews != null) {
//       data['reviews'] = reviews!.map((v) => v.toJson()).toList();
//     }
//     if (raffle != null) {
//       data['raffle'] = raffle!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Category {
  String? id;
  String? id2;
  String? name;
  String? description;
  bool? status;
  String? created;
  String? updated;

  Category({
    this.id,
    this.id2,
    this.name,
    this.description,
    this.status,
    this.created,
    this.updated,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id2 = json['_id'];
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
    data['_id'] = id2;
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
  String? name;
  String? description;
  int? availableTickets;
  List<Media>? media;
  String? startDate;
  String? endDate;
  int? ticketPrice;
  String? status;
  String? winningTicket;
  String? createdAt;
  String? updatedAt;
  String? formattedTicketPrice;
  List<Participant>? participants;

  Raffle({
    this.id,
    this.name,
    this.description,
    this.availableTickets,
    this.media,
    this.startDate,
    this.endDate,
    this.ticketPrice,
    this.status,
    this.winningTicket,
    this.createdAt,
    this.updatedAt,
    this.formattedTicketPrice,
    this.participants,
  });

  Raffle.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    name = json['name'];
    description = json['description'];
    availableTickets = json['available_tickets'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    startDate = json['start_date'];
    endDate = json['end_date'];
    ticketPrice = json['ticket_price'];
    status = json['status'];
    winningTicket = json['winning_ticket'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    formattedTicketPrice = json['formatted_ticket_price'];
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants!.add(Participant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['available_tickets'] = availableTickets;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['ticket_price'] = ticketPrice;
    data['status'] = status;
    data['winning_ticket'] = winningTicket;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['formatted_ticket_price'] = formattedTicketPrice;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads {
  String? id;
  String? uploadKey;
  String? location;
  String? url;
  String? mimetype;
  String? mediaType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Ads({
    this.id,
    this.uploadKey,
    this.location,
    this.url,
    this.mimetype,
    this.mediaType,
    this.createdAt,
    this.updatedAt,
  });

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    uploadKey = json['upload_key'];
    location = json['location'];
    url = json['url'];
    mimetype = json['mimetype'];
    mediaType = json['media_type'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['upload_key'] = uploadKey;
    data['location'] = location;
    data['url'] = url;
    data['mimetype'] = mimetype;
    data['media_type'] = mediaType;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}


class Media {
  String? id;
  String? uploadKey;
  String? location;
  String? url;
  String? mimetype;
  String? createdAt;
  String? updatedAt;

  Media({
    this.id,
    this.uploadKey,
    this.location,
    this.url,
    this.mimetype,
    this.createdAt,
    this.updatedAt,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    uploadKey = json['upload_key'];
    location = json['location'];
    url = json['url'];
    mimetype = json['mimetype'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['upload_key'] = uploadKey;
    data['location'] = location;
    data['url'] = url;
    data['mimetype'] = mimetype;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Participant {
  String? firstname;
  String? lastname;
  ProfilePic? profilePic;

  Participant({this.firstname, this.lastname, this.profilePic});

  Participant.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    profilePic = json['profile_pic'] != null
        ? ProfilePic.fromJson(json['profile_pic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    if (profilePic != null) {
      data['profile_pic'] = profilePic!.toJson();
    }
    return data;
  }
}

class ProfilePic {
  String? id;
  String? url;

  ProfilePic({this.id, this.url});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['url'] = url;
    return data;
  }
}



// class Review {
//   String? id;
//   String? comment;
//   int? rating;
//   String? created;
//   String? updated;
//   Product? product;
//   User? user;
//
//   Review(
//       {this.id,
//         this.comment,
//         this.rating,
//         this.created,
//         this.updated,
//         this.product,
//         this.user,
//       });
//
//   Review.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     rating = json['rating'];
//     comment = json['comment'];
//     created = json['created'];
//     updated = json['updated'];
//     product = json['product'] != null ? Product.fromJson(json['product']) : null;
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['rating'] = rating;
//     data['comment'] = comment;
//     data['created'] = created;
//     data['updated'] = updated;
//     if (product != null) {
//       data['product'] = product!.toJson();
//     }
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     return data;
//   }
// }
//
// class Winner {
//   String? id;
//   User? user;
//   Raffle? raffle;
//   String? status;
//   String? ticketNumber;
//   bool? isWinner;
//   String? createdAt;
//   String? updatedAt;
//   String? order;
//
//   Winner({
//     this.id,
//     this.user,
//     this.raffle,
//     this.status,
//     this.ticketNumber,
//     this.isWinner,
//     this.createdAt,
//     this.updatedAt,
//     this.order,
//   });
//
//   Winner.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//     raffle = json['raffle'] != null ? Raffle.fromJson(Map<String, dynamic>.from(json['raffle'])) : null;
//     status = json['status'];
//     ticketNumber = json['ticket_number'];
//     isWinner = json['is_winner'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     order = json['order'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = id;
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     if (raffle != null) {
//       data['raffle'] = raffle!.toJson();
//     }
//     data['status'] = status;
//     data['ticket_number'] = ticketNumber;
//     data['is_winner'] = isWinner;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['order'] = order;
//     return data;
//   }
// }

class DrawEvent {
  final String id;
  final Raffle raffle;
  final String title;
  final String link;
  final List<Media> media;
  final DateTime createdAt;
  final DateTime updatedAt;

  DrawEvent({
    required this.id,
    required this.raffle,
    required this.title,
    required this.link,
    required this.media,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DrawEvent.fromJson(Map<String, dynamic> json) {
    return DrawEvent(
      id: json['_id'],
      raffle: Raffle.fromJson(json['raffle']),
      title: json['title'],
      link: json['link'],
      media: (json['media'] as List)
          .map((mediaItem) => Media.fromJson(mediaItem))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Add the toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'raffle': raffle.toJson(), // Assuming Raffle also has a toJson method
      'title': title,
      'link': link,
      'media': media.map((m) => m.toJson()).toList(), // Assuming Media also has a toJson method
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


