
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_power/ui/common/ui_helpers.dart';
import 'package:easy_power/ui/views/shop/productcard.dart';
import 'package:easy_power/ui/views/shop/shop_viewmodel.dart';
import 'package:stacked/stacked.dart';
import '../../../core/data/models/product.dart';
import '../../common/app_colors.dart';
import '../home/module_switch.dart';
import '../profile/profile_viewmodel.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';




class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  // @override
  // Widget builder(
  //     BuildContext context,
  //     ShopViewModel viewModel,
  //     Widget? child,
  //     )

  @override
  _ShopViewState createState() => _ShopViewState();
}
bool isSelected = false;
enum categories {solarEnergy, electronics, services}

List<Product> productList = [];
String _topModalData = "";

class _ShopViewState extends State<ShopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) {
       // viewModel.getProfile();
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildBottomSheet(context, _tabController),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final item = productList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: kcMediumGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: (){
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                                      child:CachedNetworkImage(
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0, // Make the loader thinner
                                            valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                          ),
                                        ),
                                        imageUrl:item.images?.first ?? 'https://via.placeholder.com/120',
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        fadeInDuration: const Duration(milliseconds: 500),
                                        fadeOutDuration: const Duration(milliseconds: 300),
                                      ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    height: 20,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: kcDarkGreyColor.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: kcStarColor,
                                          size: 20,
                                        ),
                                        Text(
                                          item.rating.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  item.productName ?? 'Product name',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'N${item.price}' ?? "N0",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: kcPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductCard(),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


void _showDummyModal(BuildContext context) async {
  var value = await showTopModalSheet<String?>(context, const DummyModal());
  print('Modal closed with value: $value');
}


Widget buildBottomSheet(BuildContext context, TabController tabController) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    height: 120,
    padding: const EdgeInsets.all(20),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          spreadRadius: 5,
        ),
      ],
    ),
    child: Column(
      children: [
        verticalSpaceSmall,
        ModuleSwitch(
          isRafflesSelected: isSelected,
          onToggle: (isSelected) {
            isSelected = true;

            print('call topbotton $isSelected');

            if (isSelected) {
              _showDummyModal(context);
            }
          },
        ),
      ],
    ),
  );
}
class DummyModal extends StatelessWidget {
  const DummyModal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kcWhiteColor,
      height: 450,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              verticalSpaceLarge,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Balance:',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Text(
                            '\$10,000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Installment:',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Text(
                            '\$10,000',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade600,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      _buildItem('Full Solar  Energy System', true ,false),
                      _buildItem('Solar Panels', false, false),
                      _buildItem('Inverters ',false, false),
                      _buildItem('Battery Storage', false, true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildItem(String title, bool isFirst, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(20.0) : Radius.zero,
          topRight: isFirst ? Radius.circular(20.0) : Radius.zero,
          bottomLeft: isLast ? Radius.circular(20.0) : Radius.zero,
          bottomRight: isLast ? Radius.circular(20.0) : Radius.zero,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14), // Make the font size smaller
        ),
      ),
    );
  }
}
