class Discount {
  final String id;
  final String referralCode;
  final int usageCount;
 //  final double discountPercentage; // Should be double, not String
 //  final double referrerBonus; // Should be double, not String
 // // Should be int, not String
 //  final String? expirationDate;
 //  final DateTime created;
 //  final DateTime updated;
 //  final int status;

  Discount({
    required this.id,
    required this.referralCode,
    required this.usageCount,
    // required this.discountPercentage,
    // required this.referrerBonus,
    // this.expirationDate,
    // required this.created,
    // required this.updated,
    // required this.status,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'],
      referralCode: json['referralCode'],
      // discountPercentage: double.parse(json['discountPercentage']),
      // referrerBonus: double.parse(json['referrerBonus']),
      usageCount: int.parse(json['usageCount'].toString()),
      // expirationDate: json['expirationDate'],
      // created: DateTime.parse(json['created']),
      // updated: DateTime.parse(json['updated']),
      // status: int.parse(json['status'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['referralCode'] = referralCode;
    data['usageCount'] = usageCount;
    // data['discountPercentage'] = discountPercentage;
    // data['expirationDate'] = expirationDate;
    // data['created'] = created;
    // data['status'] = status;
    // data['updated'] = updated;
    return data;
  }
}