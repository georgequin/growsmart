import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';

class ShippingAddressesPage extends StatefulWidget {
  const ShippingAddressesPage({Key? key}) : super(key: key);

  @override
  _ShippingAddressesPageState createState() => _ShippingAddressesPageState();
}

class _ShippingAddressesPageState extends State<ShippingAddressesPage> {
  final TextEditingController houseAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<Map<String, dynamic>> shippingAddresses = [
    {
      'name': '${profile.value.firstName} ${profile.value.lastName}',
      'address': '3 Newbridge Court, Chino Hills, CA 91709',
      'isDefaultPayment': false,
    },
  ];

  void addAddress(String name, String address, String city, String state, String phoneNumber, bool isDefaultPayment) {
    setState(() {
      shippingAddresses.add({
        'name': '${profile.value.firstName} ${profile.value.lastName}',
        'address': '$address, $city, $state',
        'phone': phoneNumber,
        'isDefaultPayment': isDefaultPayment,
      });
    });
  }

  void deleteAddress(int index) {
    setState(() {
      shippingAddresses.removeAt(index);
    });
  }

  void showAddAddressBottomSheet() {
    String name = '';
    String houseAddress = '';
    String city = '';
    String state = '';
    String phoneNumber = '';
    bool isDefaultPayment = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
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

                      TextFieldWidget(
                        hint: 'House address',
                        controller: houseAddressController,
                        onChanged: (value) => houseAddress = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'City',
                        controller: cityController,
                        onChanged: (value) => city = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'State/Nationality',
                        controller: stateController,
                        onChanged: (value) => state = value,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hint: 'Phone Number',
                        controller: phoneNumberController,
                        onChanged: (value) => phoneNumber = value,
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: isDefaultPayment,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                      SubmitButton(
                          isLoading: false,
                          label: 'Add Address',
                          submit: () {
                            if (houseAddressController.text.isNotEmpty &&
                                cityController.text.isNotEmpty &&
                                stateController.text.isNotEmpty &&
                                phoneNumberController.text.isNotEmpty) {
                              addAddress(name, houseAddress, city, state, phoneNumber, isDefaultPayment);
                            }
                            houseAddressController.clear();
                            cityController.clear();
                            stateController.clear();
                            phoneNumberController.clear();
                            Navigator.pop(context);
                          },
                          color: kcPrimaryColor),
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
          List<String> addressParts = address['address'].split(',');
          String firstLine = addressParts.isNotEmpty ? addressParts[0] + "," : "";
          String secondLine = addressParts.length > 1
              ? addressParts.sublist(1).join(',').trim()
              : "";

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          _buildIconButton(Icons.edit, 'Edit', Colors.red),
                          horizontalSpaceSmall,
                          _buildIconButton(Icons.delete, 'Delete', Colors.red, () {
                            deleteAddress(index);
                          }),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(firstLine),
                      Text(secondLine),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Checkbox(
                            value: address['isDefaultPayment'],
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            onChanged: (value) {
                              setState(() {
                                address['isDefaultPayment'] = value;
                              });
                            },
                          ),
                          const SizedBox(width: 2),
                          const Expanded(
                            child: Text(
                              "Use as shipping address",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50), // Adjust this value to move the button up
        child: FloatingActionButton(
          onPressed: showAddAddressBottomSheet,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color, [VoidCallback? onPressed]) {
    return Column(
        children: [
        IconButton(
        icon: Icon(icon, color: color),
    onPressed: onPressed,
    ),
    Text(label, style: TextStyle(color: color)),
    ],
    );
    }
}