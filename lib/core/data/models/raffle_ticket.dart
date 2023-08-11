import 'package:afriprize/core/data/models/product.dart';

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
