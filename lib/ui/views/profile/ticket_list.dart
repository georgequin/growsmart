import 'package:afriprize/app/app.locator.dart';
import 'package:afriprize/app/app.router.dart';
import 'package:afriprize/core/data/models/order_item.dart';
import 'package:afriprize/core/data/repositories/repository.dart';
import 'package:afriprize/core/network/api_response.dart';
import 'package:afriprize/state.dart';
import 'package:afriprize/ui/common/app_colors.dart';
import 'package:afriprize/ui/components/empty_state.dart';
import 'package:afriprize/ui/views/profile/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.logger.dart';
import '../../../core/data/models/raffle_ticket.dart';
import '../../../utils/orderUtil.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _OrderListState();
}

class _OrderListState extends State<TicketList> {
  List<OrderItem> orders = [];
  bool loading = false;


  final repo = locator<Repository>();
  final log = getLogger("DrawsViewModel");
  List<RaffleTicket> raffle = [];
  int selectedIndex = 0;

  onPageChanged(int index) {
    selectedIndex = index;
     // rebuildUi();
  }

  void listRaffle() async {
    // setBusyForObject(raffle, true);
    try {
      ApiResponse res = await repo.raffleList();
      if (res.statusCode == 200) {
        var raffleData = (res.data["participant"] as List)
            .map((e) => RaffleTicket.fromJson(Map<String, dynamic>.from(e['raffledraw'])))
            .toList();

        setState(() {
          raffle = raffleData;
          loading = false; // Now we set loading to false after we get data
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
        title: const Text(
          "My Tickets",
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : raffle.isEmpty
          ? const EmptyState(
          animation: "empty_order.json", label: "No Tikets Yet")
          :
            Container(
              color: Colors.white,
              child:  _buildOrderList(),
            ),


    );
  }

  Widget _buildOrderList() {
    return raffle.isEmpty ?  const EmptyState(
        animation: "empty_order.json", label: "No Ticket Yet") :
    ListView.builder(
      itemCount: raffle.length,
      itemBuilder: (context, index) {
        RaffleTicket ticket = raffle[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Ticket ID',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        ticket.ticketTracking ?? "",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Text(
                      'Draw Date: ${DateFormat("d MMM").format(
                          DateTime.parse(ticket.startDate!))}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
                // verticalSpaceTiny,
                Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {}, // Button tapped functionality goes here
                        style: ElevatedButton.styleFrom(
                          primary: kcPrimaryColor, // Background color
                        ),
                        child: Text('${ticket.ticketName}' , style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"
                        ),),
                      ),
                      ElevatedButton(
                        onPressed: () {}, // Button tapped functionality goes here
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // Background color
                          onPrimary: Colors.white,
                          padding: EdgeInsets.all(6),
                        ),
                        child: Text('${ticket.status == 1 ? 'Active' : 'Completed'}'),
                      ),
                    ]),
                SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kcVeryLightGrey,
                        image: ticket.pictures == null || ticket.pictures!.isEmpty
                            ? null
                            : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(ticket!.pictures![0].location!),
                        ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                      child: Text(
                        "${ticket.ticketDescription}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}

