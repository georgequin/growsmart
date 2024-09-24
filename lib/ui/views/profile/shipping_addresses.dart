import 'package:flutter/material.dart';

class ShippingAddressesPage extends StatefulWidget {
  const ShippingAddressesPage({Key? key}) : super(key: key);

  @override
  _ShippingAddressesPageState createState() => _ShippingAddressesPageState();
}

class _ShippingAddressesPageState extends State<ShippingAddressesPage> {
  List<Map<String, dynamic>> shippingAddresses = [
    {
      'name': 'Jane Doe',
      'address': '3 Newbridge Court, Chino Hills, CA 91709',
      'isDefaultPayment': false,
    },
    // Add more addresses here
  ];

  // Function to add a new address
  void addAddress(String name, String address, String city, String state, String phoneNumber, bool isDefaultPayment) {
    setState(() {
      shippingAddresses.add({
        'name': name,
        'address': '$address, $city, $state',
        'phone': phoneNumber,
        'isDefaultPayment': isDefaultPayment,
      });
    });
  }

  // Function to delete an address
  void deleteAddress(int index) {
    setState(() {
      shippingAddresses.removeAt(index);
    });
  }

  // Function to show the add address bottom sheet
  void showAddAddressBottomSheet() {
    String name = '';
    String houseAddress = '';
    String city = '';
    String state = '';
    String phoneNumber = '';
    bool isDefaultPayment = false; // Manage checkbox state

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet takes the full screen height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Handle keyboard overlap
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Address',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // House Address Input Field in a Card
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'House address',
                              border: InputBorder.none, // No border for a clean card look
                            ),
                            onChanged: (value) {
                              houseAddress = value;
                            },
                          ),
                        ),
                      ),

                      // City Input Field in a Card
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              city = value;
                            },
                          ),
                        ),
                      ),

                      // State/Nationality Input Field in a Card
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'State/Nationality',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              state = value;
                            },
                          ),
                        ),
                      ),

                      // Phone Number Input Field in a Card with Country Code
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text('+234', style: TextStyle(fontSize: 16)),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    phoneNumber = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Default Payment Checkbox with Black Color
                      Row(
                        children: [
                          Checkbox(
                            value: isDefaultPayment,
                            activeColor: Colors.black, // Set checkbox color to black
                            checkColor: Colors.white,  // Set checkmark color to white
                            onChanged: (value) {
                              setModalState(() {
                                isDefaultPayment = value ?? false;
                              });
                            },
                          ),
                          const Text("Set as default payment method"),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Add Address Button
                      ElevatedButton(
                        onPressed: () {
                          if (houseAddress.isNotEmpty &&
                              city.isNotEmpty &&
                              state.isNotEmpty &&
                              phoneNumber.isNotEmpty) {
                            addAddress(name, houseAddress, city, state, phoneNumber, isDefaultPayment); // Call addAddress with inputs
                          }
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Set button color to match the screenshot
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Add Address'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
      ),
      body: ListView.builder(
        itemCount: shippingAddresses.length,
        itemBuilder: (context, index) {
          final address = shippingAddresses[index];

          // Safely split the address into parts
          List<String> addressParts = address['address'].split(',');
          String firstLine = addressParts.isNotEmpty ? addressParts[0] + "," : "";
          String secondLine = addressParts.length > 1
              ? addressParts.sublist(1).join(',').trim()
              : "";

          return Card(
            margin: const EdgeInsets.all(8.0), // Margin around the card
            elevation: 2, // Set elevation for light box shadow
            color: Colors.white, // Set card background color to white
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.red), // Set color to red
                            onPressed: () {
                              // Implement edit functionality
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red), // Set color to red
                            onPressed: () {
                              deleteAddress(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(firstLine), // First line of address
                  Text(secondLine), // Second line of address

                  // Checkbox Row with Label (Checkbox comes before the text)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.black, // Set unchecked color to black
                        ),
                        child: Checkbox(
                          checkColor: Colors.white, // Set checkmark color
                          activeColor: Colors.black, // Set background color to black when checked
                          value: address['isDefaultPayment'],
                          onChanged: (value) {
                            setState(() {
                              address['isDefaultPayment'] = value;
                            });
                          },
                        ),
                      ),
                      const Text("Use as shipping address"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddAddressBottomSheet, // Show the bottom sheet instead of dialog
        backgroundColor: Colors.black,   // Set background to black
        child: const Icon(Icons.add, color: Colors.white),  // Set "+" icon to white
        shape: const CircleBorder(),     // Ensure the button is round
      ),
    );
  }
}
