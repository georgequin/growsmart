import 'package:afriprize/core/data/models/cart_item.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:afriprize/utils/date_time_utils.dart';
import 'package:afriprize/utils/money_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../utils/cart_utill.dart';
import '../../../widget/custom_clipper.dart';
import '../../common/app_colors.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;



class ReceiptPage extends StatelessWidget {
  final List<CartItem> cart;

  const ReceiptPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    createAndSharePdf();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade300, // Use the appropriate color for your app
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                  const Row(children: [
                    Icon(Icons.share_outlined),
                    horizontalSpaceTiny,
                    Text('Share Receipt', style: TextStyle(fontSize: 15)),
                  ],),
                ),
              ],
            ),
          ),
          SingleChildScrollView( // Use SingleChildScrollView for a single child scrollable widget
            child: ClipPath(
                  clipper: MyClipper(),
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    createAndSharePdf();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white, // Use the appropriate color for your app
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child:
                                  const Row(children: [
                                    Icon(Icons.share_outlined),
                                    horizontalSpaceTiny,
                                    Text('Share Receipt', style: TextStyle(fontSize: 15)),
                                  ],),
                                ),
                              ],
                            ),
                          ),
                          verticalSpaceLarge,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDate(DateTime.now()),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.ac_unit, size: 15, color:Colors.green),
                                  Text('Successful', style: TextStyle(fontSize: 11, color: Colors.green)),
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16.0),

                            decoration: BoxDecoration(
                              color: kcPrimaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset(
                              "assets/images/receipt_header.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text(
                            'ORDER SUMMARY',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          ...cart.map((cartItem) =>  ListTile(
                            leading: Image.network(cartItem.product!.pictures!.first.location ?? '', height: 44, width: 48), // Replace with your image URL field
                            title: Text(cartItem.product!.productName!, style: const TextStyle(fontSize: 10.61)),
                            subtitle: Text('${cartItem.quantity}', style: const TextStyle(fontSize: 10.61)),
                            trailing: Text(MoneyUtils().formatAmount(cartItem.product!.productPrice!),style: TextStyle(fontSize: 10.61, fontWeight: FontWeight.bold,
                              color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                              fontFamily: "satoshi",)),
                          )),
                          const Divider(),
                          verticalSpaceMedium,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Order',
                                style: TextStyle(fontWeight: FontWeight.w100),
                              ),
                              Text(
                                MoneyUtils().formatAmount(getShopSubTotal(cart)),
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12,
                                  color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                  fontFamily: "satoshi",),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery Charge:',
                                style: TextStyle(fontWeight: FontWeight.w100),
                              ),
                              Text(
                                getDeliveryFee(cart) == 0 ? 'Free!' : MoneyUtils().formatAmount(getDeliveryFee(cart)),
                                style:TextStyle(fontWeight: FontWeight.normal, fontSize: 12,
                                  color: uiMode.value == AppUiModes.dark ? Colors.white : Colors.black,
                                  fontFamily: "satoshi",),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL:',
                                style: TextStyle(fontWeight: FontWeight.w100),
                              ),
                              Text(
                                MoneyUtils().formatAmount(getShopSubTotal(cart) + getDeliveryFee(cart)),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.3),
                              ),
                            ],
                          ),
                          const Divider(),
                          verticalSpaceSmall,
                          const Text(
                            'DELIVERY ADDRESS',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
                          ),
                          Text(
                            profile.value.shipping?.firstWhere((element) => element.isDefault!).shippingAddress ?? "Default shipping not set",
                            style: const TextStyle(color: kcSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),),

          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  locator<NavigationService>().replaceWithHomeView();
                  // Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardView, (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                  primary: kcSecondaryColor, // Use the appropriate color for your app
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(children: [
                  Icon(Icons.home, color: Colors.black,),
                  horizontalSpaceTiny,
                  Text('Back to Home', style: TextStyle(fontSize: 15)),
                ],),
              ),
              ElevatedButton(
                onPressed: () {
                  locator<NavigationService>().clearStackAndShow(Routes.ticketView);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300, // Use the appropriate color for your app
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                const Row(children: [
                  Icon(Icons.airplane_ticket_outlined),
                  horizontalSpaceTiny,
                  Text('View Tickets', style: TextStyle(fontSize: 15)),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createAndSharePdf() async {
    final pdf = pw.Document();

    final imageBytes = await rootBundle.load('assets/images/receipt_header.png');
    final image = pw.MemoryImage(
      imageBytes.buffer.asUint8List(),
    );
    List<Future<pw.Widget>> cartItemFutures = cart.map((cartItem) => createCartItemWidget(cartItem)).toList();

    List<pw.Widget> cartItemWidgets = await Future.wait(cartItemFutures);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    formatDate(DateTime.now()),
                    style:  pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.normal),
                  ),
                   pw.Row(
                    children: [
                      pw.Text('Successful', style: const pw.TextStyle(fontSize: 11, color: PdfColor(0, 1, 0))),
                    ],
                  )
                ],
              ),
              pw.Container(
                margin:  pw.EdgeInsets.symmetric(vertical: 16.0),

                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(10.0),
                ),
                child: pw.Image(image, fit: pw.BoxFit.cover),
              ),
               pw.Text(
                'ORDER SUMMARY',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
              ),

              pw.Column(
                children: cartItemWidgets,
              ),

              pw.Divider(),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total Order',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    MoneyUtils().formatAmount(getShopSubTotal(cart)),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Delivery Charge:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    getDeliveryFee(cart) == 0 ? 'Free!' : MoneyUtils().formatAmount(getDeliveryFee(cart)),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    MoneyUtils().formatAmount(getShopSubTotal(cart) + getDeliveryFee(cart)),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14.3),
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'DELIVERY ADDRESS',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16,),
              ),
              pw.Text(
                profile.value.shipping?.firstWhere((element) => element.isDefault!).shippingAddress ?? "Default shipping not set",
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/receipt.pdf");
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    Share.shareFiles([file.path], text: 'Your receipt');
  }

  Future<pw.Widget> createCartItemWidget(CartItem cartItem) async {
    // Attempt to load the image from the network
    final response = await http.get(Uri.parse(cartItem.product!.pictures!.first.location!));

    pw.Widget imageWidget;
    if (response.statusCode == 200) {
      final imageBytes = response.bodyBytes;
      final image = pw.MemoryImage(imageBytes);
      imageWidget = pw.Image(image, width: 44, height: 48); // Use the loaded image
    } else {
      print('Failed to load network image.');
      imageWidget = pw.Text('Image not available'); // Use a placeholder or error widget
    }

    // Construct the container with the image widget
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 44,
            height: 48,
            margin: const pw.EdgeInsets.only(right: 8.0),
            child: imageWidget, // Use the image widget here
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(cartItem.product!.productName!, style: pw.TextStyle(fontSize: 10.61)),
                pw.Text('${cartItem.quantity}', style: pw.TextStyle(fontSize: 10.61)),
              ],
            ),
          ),
          pw.Text('₦${MoneyUtils().formatAmount(cartItem.product!.productPrice!)}',
            style: pw.TextStyle(fontSize: 10.61, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<pw.Widget> createNetworkImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;
        final image = pw.MemoryImage(imageBytes);
        return pw.Image(image, width: 44, height: 48);
      } else {
        print('Failed to load network image.');
        // Return a placeholder widget or handle the error as you see fit
        return pw.Text('Image not available');
      }
    } catch (e) {
      print('Error loading image: $e');
      // Handle exception by returning a placeholder or an error widget
      return pw.Text('Image load error');
    }
  }

}




