class Transaction {
  String? id;
  String? description; // Add this field to capture the description
  int? amount;
  String? paymentMethod;
  String? paymentType;
  String? status;
  String? paymentRef;
  String? paymentUrl; // Add this field to capture payment URL
  String? createdAt;
  String? updatedAt;

  Transaction({
    this.id,
    this.description,
    this.amount,
    this.paymentMethod,
    this.paymentType,
    this.status,
    this.paymentRef,
    this.paymentUrl,
    this.createdAt,
    this.updatedAt,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Change from 'id' to '_id'
    description = json['description'];
    amount = json['amount'];
    paymentMethod = json['payment_method'];
    paymentType = json['payment_type'];
    status = json['status'];
    paymentRef = json['payment_ref'];
    paymentUrl = json['payment_url']; // Adjusted to match the API structure
    createdAt = json['createdAt']; // Adjusted to match the API structure
    updatedAt = json['updatedAt']; // Adjusted to match the API structure
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id; // Change from 'id' to '_id'
    data['description'] = description;
    data['amount'] = amount;
    data['payment_method'] = paymentMethod;
    data['payment_type'] = paymentType;
    data['status'] = status;
    data['payment_ref'] = paymentRef;
    data['payment_url'] = paymentUrl; // Adjusted to match the API structure
    data['createdAt'] = createdAt; // Adjusted to match the API structure
    data['updatedAt'] = updatedAt; // Adjusted to match the API structure
    return data;
  }
}
