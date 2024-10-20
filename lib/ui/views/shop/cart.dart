import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_power/ui/common/ui_helpers.dart';
import '../../common/app_colors.dart';

class CartPageView extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPageView> {
  List<int> quantities = [1, 2, 1]; // Initial quantities for each item
  List<double> prices = [59.99, 79.99, 120.00]; // Prices of each item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          // Total items and price at the top
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${getTotalItems()} Items -',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Total \$${getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
              color: kcPrimaryColor.withOpacity(0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/shipping.svg'),
                  horizontalSpaceSmall,
                  Text(
                    'Arrives by April 3 to April 9th',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                ],
              )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  buildCartItem(
                    'assets/images/Mercury-10KVA-Solar-System-1 2.png',
                    'WH-1000XM5',
                    '\$59.99',
                    'Red',
                    'MK solar panels, ua inverter, total inverter battery, cables',
                    0,
                  ),
                  buildCartItem(
                    'assets/images/Mercury-10KVA-Solar-System-1 2.png',
                    'WH-1000XM5',
                    '\$79.99',
                    'White',
                    'MK solar panels, ua inverter, total inverter battery, cables',
                    1,
                  ),
                  buildCartItem(
                    'assets/images/Mercury-10KVA-Solar-System-1 2.png',
                    'WH-1000XM5',
                    '\$120.00',
                    'Black',
                    'MK solar panels, ua inverter, total inverter battery, cables',
                    2,
                  ),
                ],
              ),
            ),
          ),
          // Checkout and total price at the bottom
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 145, // Set the width
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPageView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kcWhiteColor,
                      backgroundColor:
                      kcPrimaryColor, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 14, // Text size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate total number of items
  int getTotalItems() {
    return quantities.fold(0, (total, current) => total + current);
  }

  // Function to calculate total price
  double getTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < quantities.length; i++) {
      totalPrice += quantities[i] * prices[i];
    }
    return totalPrice;
  }

  Widget buildCartItem(String imagePath, String itemName, String price, String color, String description, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15), // Margin between items
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Color: $color',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Selector
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantities[index] > 1) {
                          quantities[index]--;
                        }
                      });
                    },
                  ),
                  Text(
                    '${quantities[index]}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantities[index]++;
                      });
                    },
                  ),
                ],
              ),
              // Total Price for this item
              Text(
                'Total: \$${(double.parse(price.substring(1)) * quantities[index]).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
