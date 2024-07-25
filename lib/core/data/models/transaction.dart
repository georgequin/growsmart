class Transaction {
  String? id;
  int? status;
  int? amount;
  String? reference;
  dynamic meta;
  int? type;
  String? created;
  String? updated;

  Transaction(
      {this.id,
      this.status,
      this.amount,
      this.reference,
      this.meta,
      this.type,
      this.created,
      this.updated});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'];
    reference = json['reference'];
    meta = json['meta'];
    type = json['type'];
    created = json['created'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['amount'] = amount;
    data['reference'] = reference;
    data['meta'] = meta;
    data['type'] = type;
    data['created'] = created;
    data['updated'] = updated;
    return data;
  }
}
