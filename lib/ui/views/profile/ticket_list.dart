import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/app.logger.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../state.dart';
import '../../common/ui_helpers.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _OrderListState();
}

class _OrderListState extends State<TicketList> {

  bool loading = false;


  final repo = locator<Repository>();
  final log = getLogger("DrawsViewModel");
  List<RaffleTicket> raffle = [];
  List<RaffleTicket> filteredRaffle = [];
  List<CombinedTicket> combinedTicket = [];
  int selectedIndex = 0;
  List<String> filteredCategories = ['All', 'Active', 'Winner', 'Invalid' ];
  static const String allCategoriesId = 'All';

  String selectedId = allCategoriesId;
  String searchQuery = '';

  onPageChanged(int index) {
    selectedIndex = index;
     // rebuildUi();
  }

  void listRaffle() async {
    // setBusyForObject(raffle, true);
    try {
      ApiResponse res = await repo.raffleList();
      if (res.statusCode == 200) {
        // Extracting the list of raffle tickets from the response
        raffle = (res.data['data']['items'] as List)
            .map((e) => RaffleTicket.fromJson(Map<String, dynamic>.from(e)))
            .toList();


        setState(() {
          filteredRaffle = raffle;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      log.e(e);
      setState(() {
        loading = false;
      });
    }
    //setBusyForObject(raffle, false);
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredRaffle = raffle;
      } else {
        filteredRaffle = raffle.where((service) {
          return service.ticketNumber!.toLowerCase().contains(searchQuery.toLowerCase()) ||
              service.raffle!.name!.toLowerCase().contains(searchQuery.toLowerCase())
              ||
              service.raffle!.description!.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }
    });

  }

  void setSelectedCategory(String id) {
    setState(() {
      selectedId = id;

      if (id == allCategoriesId) {
        filteredRaffle = raffle;
        print('Full Raffle List:');
        filteredRaffle.forEach((ticket) {
          print('Ticket Number: ${ticket.ticketNumber}, Status: ${ticket.status}, Winner: ${ticket.isWinner}');
        });
      } else if (id == 'Active') {
        filteredRaffle = raffle.where((ticket) => ticket.status == 'ACTIVE').toList();
      } else if (id == 'Winner') {
        filteredRaffle = raffle.where((ticket) => ticket.isWinner == true && ticket.status == 'WINNING').toList();
      }
      else if (id == 'Invalid') {
        filteredRaffle = raffle.where((ticket) =>
        ticket.status == 'INVALID' || ticket.status == 'EXPIRED' || ticket.status == 'REVOKED'
        ).toList();
      }
    });
  }



  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(category),
        selected: category == selectedId, // Check if this category is selected
        onSelected: (bool selected) {
          setSelectedCategory(selected ? category : allCategoriesId); // Update selected category
        },
        selectedColor: kcSecondaryColor,
        backgroundColor: uiMode.value == AppUiModes.dark
            ? kcMediumGrey
            : kcWhiteColor,
        labelStyle: TextStyle(
          color: category == selectedId ? Colors.white : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: uiMode.value == AppUiModes.dark
                ? kcMediumGrey
                : kcWhiteColor,  // Set the border color to light grey
            width: 1.0,                // Set the border width
          ),
          borderRadius: BorderRadius.circular(30.0), // Reduce the border radius (adjust this value)
        ),
      ),
    );
  }


  @override
  void initState() {
    getOrders();
    super.initState();
  }

  void getOrders() async {
    setState(() {
      loading = true;
    });
     listRaffle(); // Make sure to await the result of listRaffle
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
          "My Tickets",
        ),
        centerTitle: true,
      ),
      body: loading
          ?  const Center(
        child: CircularProgressIndicator(),
      )
          : raffle.isEmpty
          ?  const EmptyState(
          animation: "empty_order.json", label: "No Tikets Yet")
          :
            Container(
              color: uiMode.value == AppUiModes.dark
                  ? kcDarkGreyColor
                  : kcWhiteColor,
              child:  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: uiMode.value == AppUiModes.dark
                            ? kcMediumGrey
                            : kcWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredCategories.map((category) {
                        return _buildCategoryChip(category);
                      }).toList(),
                    ),
                  ),
                  verticalSpaceSmall,
                  Expanded(child: _buildOrderList()),
                ],
              )

            ),


    );
  }

  Widget _buildOrderList() {
    return filteredRaffle.isEmpty ?  const EmptyState(
        animation: "empty_order.json", label: "No Ticket Yet") :
    ListView.builder(
      itemCount: filteredRaffle.length,
      itemBuilder: (context, index) {
        RaffleTicket ticket = filteredRaffle[index];
        return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 0,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                   decoration: BoxDecoration(
                                  color: uiMode.value == AppUiModes.dark
                                      ? kcMediumGrey
                                      : kcWhiteColor, // Card's background color
                                  borderRadius: BorderRadius.circular(10.0), // Ensure this matches the card's border radius
                                  boxShadow: const [
                                      BoxShadow(
                                          color: kcSecondaryColor,
                                          blurRadius: 0,
                                          spreadRadius: 1,
                                          offset: Offset(0, 6),
                                      ),
                                  ],
                  ),
                  child: Padding( padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top of the row
                                    children: <Widget>[

                                      Container(
                                        height: 74,
                                        width: 74,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(ticket.raffle!.media?[0].url ?? 'https://via.placeholder.com/120'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                          children: <Widget>[

                                            Container(
                                              decoration: BoxDecoration(
                                                color: kcPrimaryColor,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              // Added padding around the content of the container
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                                child: Text(
                                                  '${ticket.raffle?.name}',
                                                  style: const TextStyle(
                                                      color: kcWhiteColor,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Panchang"
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                Text(
                                                  'Draw Date: ${DateFormat("d MMM").format(DateTime.parse(ticket.raffle!.endDate!))}',
                                                  style: const TextStyle(
                                                    fontSize: 14, // Adjust the size as needed
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(ticket.status ?? 'INACTIVE',
                                                    style:  TextStyle(color: ticket.status == 'ACTIVE' ? Colors.green : Colors.grey, fontSize: 12)),
                                              ],
                                            )

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: kcSecondaryColor, height: 10,thickness: 1.0, indent: 0.8),
                                  verticalSpaceTiny,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 25, // Adjust the size as needed
                                        width: 25, // Adjust the size as needed
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage("assets/images/ticket_img.png"),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                           'Ticket No:',
                                            style: TextStyle(
                                              fontSize: 12, // Adjust the size as needed
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            ticket.ticketNumber ?? '',
                                            style: const TextStyle(
                                              fontSize: 17, // Adjust the size as needed
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
              ],
            ),
          ),
            ),
        );
      },
    );



    // ListView.builder(
    //   itemCount: raffle.length,
    //   itemBuilder: (context, index) {
    //     RaffleTicket ticket = raffle[index];
    //     return Card(
    //       margin: EdgeInsets.all(8.0),
    //       child: Padding(
    //         padding: EdgeInsets.all(16.0),
    //         child: Column(
    //           children: <Widget>[
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text(
    //                   'Ticket ID',
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.normal,
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: <Widget>[
    //                 Expanded(
    //                   child: Text(
    //                     ticket.ticketTracking ?? "",
    //                     style: TextStyle(
    //                       fontSize: 24,
    //                       fontWeight: FontWeight.bold,
    //                       letterSpacing: 2,
    //                     ),
    //                   ),
    //                 ),
    //                 Text(
    //                   'Draw Date: ${DateFormat("d MMM").format(
    //                       DateTime.parse(ticket.startDate!))}',
    //                   style: TextStyle(
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //
    //               ],
    //             ),
    //             // verticalSpaceTiny,
    //             Wrap(
    //               spacing: 8.0, // gap between adjacent chips
    //               runSpacing: 4.0, // gap between lines
    //               alignment: WrapAlignment.spaceBetween,
    //               children: <Widget>[
    //                 ElevatedButton(
    //                   onPressed: () {}, // Button tapped functionality goes here
    //                   style: ElevatedButton.styleFrom(
    //                     primary: kcPrimaryColor, // Background color
    //                   ),
    //                   child: Text(
    //                     '${ticket.ticketName}',
    //                     style: TextStyle(
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: "Panchang"
    //                     ),
    //                   ),
    //                 ),
    //                 ElevatedButton(
    //                   onPressed: () {}, // Button tapped functionality goes here
    //                   style: ElevatedButton.styleFrom(
    //                     primary: Colors.green, // Background color
    //                     onPrimary: Colors.white,
    //                     padding: EdgeInsets.all(6),
    //                   ),
    //                   child: Text('${ticket.status == 1 ? 'Active' : 'Completed'}'),
    //                 ),
    //               ],
    //             ),
    //
    //             SizedBox(height: 8.0),
    //             Row(
    //               children: <Widget>[
    //                 Container(
    //                   height: 40,
    //                   width: 40,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(12),
    //                     color: kcVeryLightGrey,
    //                     image: ticket.pictures == null || ticket.pictures!.isEmpty
    //                         ? null
    //                         : DecorationImage(
    //                       fit: BoxFit.cover,
    //                       image: NetworkImage(ticket!.pictures![0].location!),
    //                     ),
    //                   ),
    //                 ),
    //                 horizontalSpaceTiny,
    //                 Expanded(
    //                   child: Text(
    //                     "${ticket.ticketDescription}",
    //                     style: TextStyle(fontSize: 16),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }


}

