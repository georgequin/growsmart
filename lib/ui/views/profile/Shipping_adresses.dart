import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  List<Address> addresses = [
    Address(name: "John Doe", address: "123 Main St, Springfield"),
    Address(name: "Jane Smith", address: "456 Elm St, Springfield"),
    Address(name: "Alice Johnson", address: "789 Maple Ave, Springfield"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            return _buildAddressCard(addresses[index], index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAddressDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAddressCard(Address address, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () {
                            // Handle edit action
                            _showEditDialog(address, index);
                          },
                        ),
                        Text('edit', style: TextStyle(color: Colors.red),),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                          },
                        ),
                        Text('delete', style: TextStyle(color: Colors.red),),

                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              address.address,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: address.isShippingAddress,
                  onChanged: (bool? value) {
                    setState(() {
                      address.isShippingAddress = value ?? false;
                    });
                  },
                ),
                Text('Use as  the shipping address'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Address address, int index) {
    TextEditingController nameController = TextEditingController(text: address.name);
    TextEditingController addressController = TextEditingController(text: address.address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  addresses[index].name = nameController.text;
                  addresses[index].address = addressController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddAddressDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    bool isDefaultPaymentMethod = false; // Checkbox state variable

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "House address",
                controller: nameController,
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "City",
                controller: addressController,
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "State/Nationality",
                controller: cityController,
              ),
              verticalSpaceMedium,
              TextFieldWidget(
                hint: "Phone number",
                controller: stateController,
              ),
              SizedBox(height: 16), // Space between fields
              Row(
                children: [
                  Checkbox(
                    value: isDefaultPaymentMethod,
                    onChanged: (bool? value) {
                      setState(() {
                        isDefaultPaymentMethod = value ?? false; // Update checkbox state
                      });
                    },
                  ),
                  Text('Set as default payment method'),
                ],
              ),
              SizedBox(height: 16), // Space before the button
              SubmitButton(
                isLoading: false,
                label: "Add Address",
                submit: () {
                  // Add your submit logic here
                  // You can access the checkbox state here
                  print("Default Payment Method: $isDefaultPaymentMethod");
                  // Clear the controllers after submission if needed
                  nameController.clear();
                  addressController.clear();
                  cityController.clear();
                  stateController.clear();
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                boldText: true,
                color: kcPrimaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

}

class Address {
  String name;
  String address;
  bool isShippingAddress;

  Address({required this.name, required this.address, this.isShippingAddress = false});
}
