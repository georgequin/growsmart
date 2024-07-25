class AppNotification {
  String? id;
  String? eventName;
  String? eventDescription;
  int? type;
  dynamic status;
  String? created;
  String? updated;

  AppNotification(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.type,
      this.status,
      this.created,
      this.updated});

  AppNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    type = json['type'];
    status = json['status'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_name'] = eventName;
    data['event_description'] = eventDescription;
    data['type'] = type;
    data['status'] = status;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}
