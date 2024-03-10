import 'package:afriprize/core/data/models/product.dart';

import 'order_item.dart';

class RaffleTicket {
  String? id;
  String? ticketName;
  String? ticketDescription;
  String? ticketTracking;
  int? status;
  String? startDate;
  String? endDate;
  String? created;
  String? updated;
  List<Participants>? participants;
  List<Pictures>? pictures;

  RaffleTicket(
      {this.id,
      this.ticketName,
      this.ticketDescription,
      this.ticketTracking,
      this.status,
      this.startDate,
      this.endDate,
      this.pictures,
      this.created,
      this.updated,
      this.participants});

  RaffleTicket.fromJson(Map<String, dynamic> json) {
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
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
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
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CombinedTicket {
  String? ticketId;
  String? raffleNumber;
  // Raffle Draw details
  String? raffleId;
  String? ticketName;
  String? ticketDescription;
  String? ticketTracking;
  String? startDate;
  String? endDate;
  double? rafflePrice;
  bool? ticketStatus;
  List<Pictures>? pictures;

  CombinedTicket({
    this.ticketId,
    this.raffleNumber,

    this.raffleId,
    this.ticketName,
    this.ticketDescription,
    this.ticketTracking,
    this.startDate,
    this.endDate,
    this.rafflePrice,
    this.ticketStatus,
    this.pictures,
  });

  CombinedTicket.fromJson(Map<String, dynamic> json) {
    ticketId = json['id'];
    raffleNumber = json['raffle_number'];

    raffleId = json['raffledraw']['id'];
    ticketStatus = json['raffledraw']['status'];
    ticketName = json['raffledraw']['ticket_name'];
    ticketDescription = json['raffledraw']['ticket_description'];
    ticketTracking = json['raffledraw']['ticket_tracking'];
    startDate = json['raffledraw']['start_date'];
    endDate = json['raffledraw']['end_date'];
    rafflePrice = json['raffledraw']['raffle_price'].toDouble();
    if (json['raffledraw']['pictures'] != null) {
      pictures = List<Pictures>.from(json['raffledraw']['pictures'].map((model) => Pictures.fromJson(model)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = ticketId;
    data['raffle_number'] = raffleNumber;

    data['raffledraw']['id'] = raffleId;
    data['raffledraw']['ticket_name'] = ticketName;
    data['raffledraw']['ticket_description'] = ticketDescription;
    data['raffledraw']['ticket_tracking'] = ticketTracking;
    data['raffledraw']['start_date'] = startDate;
    data['raffledraw']['end_date'] = endDate;
    data['raffledraw']['raffle_price'] = rafflePrice;
    if (pictures != null) {
      data['raffledraw']['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }


    return data;
  }
}

class SingleTicket {
  String? id;
  String? ticketTracking;
  bool? status;
  String? created;
  String? updated;

  SingleTicket(
      {this.id,
        this.ticketTracking,
        this.status,
        this.created,
        this.updated,});

  SingleTicket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketTracking = json['ticket_tracking'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['raffle_number'] = ticketTracking;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Participants {
  String? id;
  String? raffleNumber;
  bool? status;
  String? created;
  String? updated;

  Participants(
      {this.id, this.raffleNumber, this.status, this.created, this.updated});

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    raffleNumber = json['raffle_number'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['raffle_number'] = raffleNumber;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}

class Winner {
   String? id;
   bool? status;
   int? entry;
   bool? winner;
   DateTime? created;
   DateTime? updated;
   User? user;
   Raffle? raffle;
   List<SingleTicket>? tickets;

  Winner(
      {this.id,
     this.status,
     this.entry,
     this.winner,
     this.created,
     this.updated,
     this.user,
     this.tickets,
     this.raffle,});

   Winner.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      status = json['status'] is bool ? json['status'] : null;
      entry = json['entry'] is int ? json['entry'] : null;
      // // entry = json['entry'];
      // // winner = json['winner'];
      winner = json['winner'] is bool ? json['winner'] : null;
      created = DateTime.parse(json['created']);
      updated = DateTime.parse(json['updated']);
      user =  User.fromJson(json['user']);
      raffle = Raffle.fromJson(json['raffledraw']);
      tickets = List<SingleTicket>.from(json['ticket'].map((x) => SingleTicket.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['status'] = status;
    // data['entry'] = entry;
    // data['winner'] = winner;
    // data['created'] = created;
    // data['updated'] = updated;
    data['created'] = created?.toIso8601String();
    data['updated'] = updated?.toIso8601String();

    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (raffle != null) {
      data['raffledraw'] = raffle!.toJson();
    }
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

