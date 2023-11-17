// import 'dart:io';
// import 'package:afriprize/app/app.router.dart';
// import 'package:afriprize/ui/common/app_colors.dart';
// import 'package:afriprize/ui/common/ui_helpers.dart';
// import 'package:afriprize/ui/views/profile/wallet.dart';
// import 'package:afriprize/utils/moneyUtil.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:stacked_services/stacked_services.dart';
//
// import '../../../app/app.locator.dart';
// import '../../../state.dart';
// import '../dashboard/dashboard_view.dart';
//
// class ReceiptWidget extends StatelessWidget {
//   final int amount;
//   final String drawTicketNumber;
//   final String paymentMethod;
//   final String senderName;
//   final DateTime paymentTime;
//
//   const ReceiptWidget({
//     Key? key,
//     required this.amount,
//     required this.drawTicketNumber,
//     required this.paymentMethod,
//     required this.senderName,
//     required this.paymentTime,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//         leading: IconButton(
//         icon: Icon(Icons.close, color: Colors.black), // Change color as needed
//     onPressed: () => {
//     Navigator.pop(context),
//     Navigator.pushReplacement(context, MaterialPageRoute(
//     builder: (context) => DashboardView(),
//     ))
//
//           //  locator<NavigationService>()
//    //      .navigateToDashboardView(
//    // )
//    //      .whenComplete(() => profile)
//     },
//     ),
//     backgroundColor: Colors.transparent, // Adjust the color to fit the design
//     elevation: 0, // No shadow
//     ),
//     backgroundColor: Colors.transparent, // To maintain the background of the current design
//     body: Center(
//     child: Card(
//       margin: const EdgeInsets.all(5.5),
//       color: Colors.transparent, // Make card transparent
//       elevation: 0, // Remove card shadow
//       child: Stack(
//           children: [
//             Container(
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/rc.jpeg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Center(
//                 child:Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//
//                     verticalSpaceLarge,
//                     verticalSpaceLarge,
//
//                     Text(
//                       'Payment Success!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Your payment has been successfully done.',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 13,
//                       ),
//                     ),
//                     Divider(color: Colors.white),
//                     Text(
//                       'Total Payment',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                     Text(
//                       '#${MoneyUtils().formatAmount(amount)}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//
//                     Padding(
//                         padding: const EdgeInsets.all(30.0),
//                         child: Column(
//                           children: [
//                             _infoRow('Draw ticket Number', '${drawTicketNumber}'),
//                             _infoRow('Payment Time', DateFormat("d MMM y").format(DateTime.parse(paymentTime.toString()))),
//                             _infoRow('Payment Method', '${paymentMethod}'),
//                             _infoRow('Sender Name', '${senderName}'),
//                           ],
//                         )
//
//                     ),
//
//                     SizedBox(height: 20),
//                     verticalSpaceLarge,
//                     verticalSpaceLarge,
//                     verticalSpaceLarge,
//
//                     TextButton.icon(
//                       onPressed: () => _generatePDFReceipt(context),
//                       icon: Icon(Icons.picture_as_pdf, color: Colors.white),
//                       label: Text(
//                         'Share Receipt',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       style: TextButton.styleFrom(
//                         primary: Colors.white,
//                         backgroundColor: kcSecondaryColor,
//                       ),
//                     ),
//
//                   ],
//                 ),
//
//               ),
//             ),
//
//
//
//
//
//           ]),
//     )
//     ),
//
//     );
//
//
//
//
//
//
//
//   }
//
//   Widget _infoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   void _generatePDFReceipt(BuildContext context) async {
//     final pdf = pw.Document();
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: new Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               new CircularProgressIndicator(),
//               new Text("Generating receipt..."),
//             ],
//           ),
//         );
//       },
//     );
//
//
//     // Use PdfImage to load the background image into the PDF
//     final image = pw.MemoryImage(
//       (await rootBundle.load('assets/images/rc.jpeg')).buffer.asUint8List(),
//     );
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.FullPage(
//           ignoreMargins: true,
//           child: pw.Stack(
//             children: [
//               pw.Positioned.fill(
//                 child: pw.Image(image, fit: pw.BoxFit.cover),
//               ),
//               // Position your text and other elements just like in your widget
//               // Use pw.Text() for text, and you can position it using pw.Positioned()
//               pw.Positioned(
//                 left: 50, // Adjust the left position as needed
//                 top: 300, // Adjust the top position as needed
//                 child: pw.Column(
//                   children: [
//                     // pw.Text('Payment Success!', style: pw.TextStyle(fontSize: 22, color: pw..fromHex('#FFFFFF'))),
//                     // pw.Text('Your payment has been successfully done.', style: pw.TextStyle(fontSize: 13, color: pw.PdfColor.fromHex('#FFFFFF70'))),
//                     // // Add the rest of your text elements
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//
//
//     Directory downloadDir = (await getExternalStorageDirectory())!;
//
//     String fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';
//     String filePath = '${downloadDir.path}/$fileName';
//
//     // Save the PDF file to the download directory
//     File file = File(filePath);
//     await file.writeAsBytes(await pdf.save());
//     await Printing.sharePdf(bytes: await pdf.save(), filename: 'receipt.pdf');
//
//     // Close the loading dialog
//     Navigator.pop(context);
//
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class ReceiptWidget extends StatefulWidget {
//   // final Map<String, dynamic> info;
//   // final int totalAmount;
//
//   const ReceiptWidget({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ReceiptWidget> createState() => _ReceiptState();
// }
//
// class _ReceiptState extends State<ReceiptWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // Example data structure, replace with actual data
//     final List<Map<String, dynamic>> orderItems = [
//       {
//         'name': 'Nike Woven Tracksuit X Force',
//         'quantity': 1,
//         'price': 'N45,089.90',
//       },
//       // Add other items...
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Receipt'),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Header section with the date and status indicator
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       DateFormat('EEEE, d MMMM').format(DateTime.now()), // Replace with actual date
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                     ),
//                     Chip(
//                       label: Text('Successful'),
//                       backgroundColor: Colors.green,
//                     ),
//                   ],
//                 ),
//                 // Banner thanking for the purchase
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 16.0),
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   child: Image.asset(
//                     "assets/images/receipt_header.png",
//                     height: 80,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 // Order Summary Header
//                 ListTile(
//                   title: Text(
//                     'ORDER SUMMARY',
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 // Order Items List
//                 ...orderItems.map((item) => ListTile(
//                   leading: Icon(Icons.shopping_bag), // Replace with actual image
//                   title: Text(item['name']),
//                   subtitle: Text('x${item['quantity']}'),
//                   trailing: Text(item['price']),
//                 )),
//                 Divider(),
//                 // Total Order
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Total Order'),
//                     Text('N150,000'), // Replace with actual data
//                   ],
//                 ),
//                 SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Delivery Charge:'),
//                     Text('N2,000'), // Replace with actual data
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('TOTAL:'),
//                     Text('N152,000', style: TextStyle(fontWeight: FontWeight.bold)), // Replace with actual data
//                   ],
//                 ),
//                 SizedBox(height: 24),
//                 // Delivery Address
//                 ListTile(
//                   title: Text('DELIVERY ADDRESS'),
//                   subtitle: Text('No. 12 location road off so-so Road.'), // Replace with actual data
//                 ),
//                 Divider(),
//                 // Draw Tickets Section
//                 ListTile(
//                   title: Text('Your Draw Tickets'),
//                   trailing: Icon(Icons.chevron_right), // Replace with actual icon if needed
//                 ),
//                 // Example of a ticket, repeat as needed
//                 Card(
//                   child: ListTile(
//                     leading: Image.asset('assets/images/macbook.png'), // Replace with actual image
//                     title: Text('Win Macbook Pro 2020'),
//                     subtitle: Text('Draw Date: 26th Nov.'),
//                     trailing: Chip(
//                       label: Text('Active'),
//                       backgroundColor: Colors.green,
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 // Ticket Number
//                 Text('Ticket No: 1234567890999876'), // Replace with actual data
//                 // Add more tickets if necessary
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class ReceiptWidget extends StatefulWidget {
  final Map<String, dynamic> info; // The receipt information

  const ReceiptWidget({
    Key? key,
    required this.info, // Make sure to pass the required data when creating ReceiptWidget
  }) : super(key: key);

  @override
  State<ReceiptWidget> createState() => _ReceiptState();
}

class _ReceiptState extends State<ReceiptWidget> {
  @override
  Widget build(BuildContext context) {
    // Extracting data from the passed `info` object.
    final transaction = widget.info['transaction'];
    final user = widget.info['user'];
    final order = transaction['order'];
    final product = order['product'];
    final ticket = widget.info['ticket']['ticket']['raffledraw'];

    // Formatting date
    final String orderDate = DateFormat('EEEE, d MMMM').format(DateTime.parse(transaction['created']));

    // Using the extracted data to populate the UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header section with the date and status indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderDate,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(transaction['status'] == 1 ? 'Successful' : 'Failed'),
                      backgroundColor: transaction['status'] == 1 ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                // Banner thanking for the purchase
            Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Image.asset(
                    "assets/images/receipt_header.png",
                    height: 80,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                // Order Items List
                ListTile(
                  leading: Icon(Icons.shopping_bag), // Replace with actual image if available
                  title: Text(product['product_name']),
                  subtitle: Text('x${order['quantity']}'),
                  trailing: Text('N${product['product_price']}'),
                ),
                Divider(),
                // Total Order
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Order'),
                    Text('N150,000'), // Replace with actual data
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charge:'),
                    Text('N2,000'), // Replace with actual data
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL:'),
                    Text('N152,000', style: TextStyle(fontWeight: FontWeight.bold)), // Replace with actual data
                  ],
                ),


                // Delivery Address
                ListTile(
                  title: Text('DELIVERY ADDRESS'),
                  subtitle: Text('${user['shipping']['shipping_address']}'), // Assuming it's the first shipping address
                ),
                Divider(),
                // Draw Tickets Section
                ListTile(
                  title: Text(ticket['ticket_name']),
                  subtitle: Text('Draw Date: ${DateFormat('d MMM.').format(DateTime.parse(ticket['end_date']))}'),
                  trailing: Chip(
                    label: Text(transaction['status'] == 1 ? 'Active' : 'Inactive'),
                    backgroundColor: transaction['status'] == 1 ? Colors.green : Colors.grey,
                  ),
                ),
                Divider(),
                // Ticket Number
                Text('Ticket No: ${ticket['ticket_tracking']}'),
                // ... other widgets ...
              ],
            ),
          ),
        ],
      ),
    );
  }
}


