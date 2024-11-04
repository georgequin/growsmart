import 'package:afriprize/app/app.router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_cart_item.dart';
import '../../../core/network/interceptors.dart';
import '../../../core/utils/local_store_dir.dart';
import '../../../core/utils/local_stotage.dart';
import '../../../state.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String selectedImage = '';
  Color iconColor = kcBlackColor;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.product.images?.first ?? ''; // Default to the first image
  }

  void addToRaffleCart(Product raffle) async {
    // setBusy(true);
    // notifyListeners();
    try {
      final existingItem = raffleCart.value.firstWhere(
            (raffleItem) => raffleItem.raffle?.id == raffle.id,
        orElse: () => RaffleCartItem(raffle: raffle, quantity: 0),
      );

      if (existingItem.quantity != null && existingItem.quantity! > 0 && existingItem.raffle != null) {
        existingItem.quantity = (existingItem.quantity! + 1);
      } else {
        existingItem.quantity = 1;
        raffleCart.value.add(existingItem);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);

      // Save to online cart using API
      final response = await repo.addToCart({
        "productId": raffle.id,
        "quantity": existingItem.quantity,
      });

      if (response.statusCode == 200) {
        locator<SnackbarService>().showSnackbar(message: "Raffle added to cart", duration: Duration(seconds: 2));
      } else {
        locator<SnackbarService>().showSnackbar(message: response.data["message"], duration: Duration(seconds: 2));
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to add raffle to cart: $e", duration: Duration(seconds: 2));
    }
  }

  void initCart() async {
    dynamic raffle = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    dynamic store = await locator<LocalStorage>().fetch(LocalStorageDir.cart);
    List<RaffleCartItem> localRaffleCart = List<Map<String, dynamic>>.from(raffle)
        .map((e) => RaffleCartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    raffleCart.value = localRaffleCart;
    raffleCart.notifyListeners();
  }

  Future<void> decreaseRaffleQuantity(RaffleCartItem item) async {
    try {
      if (item.quantity! > 1) {
        item.quantity = item.quantity! - 1;

        // Update online cart
        await repo.addToCart({
          "productId": item.raffle?.id,
          "quantity": item.quantity,
        });
      } else if (item.quantity! == 1) {
        // Remove from local cart
        raffleCart.value.removeWhere((cartItem) => cartItem.raffle?.id == item.raffle?.id);

        // Remove from online cart
        await repo.deleteFromCart(item.raffle!.id!);
      }

      // Save to local storage
      List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
      await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to decrease raffle quantity: $e", duration: Duration(seconds: 2));
    print(e);
    }
  }

  Future<void> increaseRaffleQuantity(RaffleCartItem item) async {

    try {
      item.quantity = item.quantity! + 1;
      int index = raffleCart.value.indexWhere((raffleItem) => raffleItem.raffle?.id == item.raffle?.id);
      if (index != -1) {
        raffleCart.value[index] = item;
        raffleCart.value = List.from(raffleCart.value);

        // Update online cart
        await repo.addToCart({
          "raffle": item.raffle?.id,
          "quantity": item.quantity,
        });

        // Save to local storage
        List<Map<String, dynamic>> storedList = raffleCart.value.map((e) => e.toJson()).toList();
        await locator<LocalStorage>().save(LocalStorageDir.raffleCart, storedList);
      }
    } catch (e) {
      locator<SnackbarService>().showSnackbar(message: "Failed to increase raffle quantity: $e", duration: Duration(seconds: 2));

    } finally {

      raffleCart.notifyListeners();
    }
  }

  void updateImage(String imagePath) {
    setState(() {
      selectedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widget value: ${widget.product.productName}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product Details"),
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: Icon(Icons.share, size: 25),
            onPressed: () async {
              // Sharing content
              await Share.share(
                  'Check out this product: ${widget.product.productName} - ${widget.product.productDescription}');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Shrinks the Row's size to fit its content
            children: [
              Column(
                children: (widget.product.images ?? [])
                    .map((image) => GestureDetector(
                  onTap: () => updateImage(image),
                  child: buildImageContainer(image, 80, 80),
                ))
                    .toList(),
              ),
              SizedBox(width: 16),
              Flexible(
                fit: FlexFit.loose, // Allows the container to shrink if needed
                child: Container(
                  height: 345,
                  decoration: BoxDecoration(
                    color: Color(0xFFDADADA).withOpacity(0.5),
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.network(
                    selectedImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            ],
          )
,
          Divider(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.product.productName ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.product.productDescription ?? '',
                  style: TextStyle(fontSize: 12),
                  softWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      '\$${widget.product.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: userLoggedIn.value == false
                          ? const SizedBox()
                          : ValueListenableBuilder<List<RaffleCartItem>>(
                          valueListenable: raffleCart,
                          builder: (context, value, child) {
                            bool isInCart = value.any((item) =>
                            item.raffle?.id == widget.product.id);
                            RaffleCartItem? cartItem = isInCart
                                ? value.firstWhere((item) =>
                            item.raffle?.id == widget.product.id)
                                : null;

                            return isInCart && cartItem != null
                                ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: kcVeryLightGrey,
                                  borderRadius:
                                  BorderRadius.circular(9)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      locator<NavigationService>()
                                          .navigateToCartView();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: kcSecondaryColor,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Goto Cart",
                                            style: TextStyle(
                                                color: kcBlackColor,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  verticalSpaceSmall,
                                  Container(
                                    height: 53,
                                    decoration: BoxDecoration(
                                      color: kcWhiteColor,
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child:  Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              decreaseRaffleQuantity(cartItem);
                                            });
                                            },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: kcWhiteColor,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.remove,
                                                    size: 18,
                                                    color: kcBlackColor)),
                                          ),
                                        ),
                                        horizontalSpaceSmall,
                                        Text(
                                          "${cartItem.quantity}",
                                          style: const TextStyle(
                                              color: kcBlackColor),
                                        ),
                                        horizontalSpaceSmall,
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              increaseRaffleQuantity(cartItem);
                                            });
                                            },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: kcWhiteColor,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.add,
                                                    size: 18,
                                                    color: kcBlackColor)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            )
                                : InkWell(
                              onTap: () async {
                                setState(() {
                                  addToRaffleCart(widget.product);
                                });
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: kcSecondaryColor,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add Raffle to cart",
                                        style: TextStyle(color: kcBlackColor),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: kcBlackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border_outlined, size: 30, color: iconColor,),
                      onPressed: () async {
                        // Sharing content
                      setState(() {
                        iconColor = kcSecondaryColor;
                      });
                      },
                    ),


                  ],
                ),

              ),

            ],
          ),
          Divider(),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You might also like',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '12 items',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget buildImageContainer(String imagePath, double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.network(imagePath, fit: BoxFit.cover),
    );
  }
}
