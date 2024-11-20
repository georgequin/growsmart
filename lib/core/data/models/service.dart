class Service {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? image;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': image,
    };
  }
}
