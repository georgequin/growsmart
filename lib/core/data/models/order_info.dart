class OrderInfo {
  int? status;
  String? trackingNumber;
  String? location;
  String? comment;
  String? id;
  String? created;
  String? updated;

  OrderInfo(
      {this.status,
      this.trackingNumber,
      this.location,
      this.comment,
      this.id,
      this.created,
      this.updated});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    trackingNumber = json['tracking_number'];
    location = json['location'];
    comment = json['comment'];
    id = json['id'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['tracking_number'] = trackingNumber;
    data['location'] = location;
    data['comment'] = comment;
    data['id'] = id;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}
