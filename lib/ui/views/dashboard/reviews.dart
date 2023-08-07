import 'package:afriprize/core/data/models/product.dart';
import 'package:awesome_rating/awesome_rating.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reviews extends StatefulWidget {
  final Product product;

  const Reviews({required this.product, Key? key}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: widget.product.reviews!.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> review =
                Map<String, dynamic>.from(widget.product.reviews![index]);
            return Card(
              child: ListTile(
                title: Text(review['comment']),
                subtitle: AwesomeStarRating(
                  borderColor: Colors.orange,
                  color: Colors.orange,
                  starCount: 5,
                  rating: double.parse(review['rating'].toString()),
                ),
                trailing: Text(DateFormat("d MMM y")
                    .format(DateTime.parse(review['created']))),
              ),
            );
          }),
    );
  }
}
