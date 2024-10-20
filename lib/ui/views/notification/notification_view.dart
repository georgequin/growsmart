import 'package:easy_power/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../common/app_colors.dart';
import '../../components/submit_button.dart';
import 'notification_viewmodel.dart';

final _navigationService = locator<NavigationService>();


enum ServiceMethod {
  siteServices,
  panelServices,
  inverterServices,
}

class NotificationView extends StackedView<NotificationViewModel> {
  const NotificationView({Key? key, this.selectedMethod}) : super(key: key);

  final ServiceMethod? selectedMethod;

  @override
  Widget builder(
      BuildContext context,
      NotificationViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            verticalSpaceLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Bar Container
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // background color of the search bar
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey, // border color
                        width: 1.5, // border thickness
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search services...",
                              border: InputBorder.none, // no border for cleaner look
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Profile Icon
                GestureDetector(
                  onTap: () {
                    // Handle profile icon tap (e.g., navigate to profile page)
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: 20,
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Services",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: buildServiceItems(viewModel),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 30,
                color: kcWhiteColor,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter your promo code',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward, size: 25, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total amount',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "124\$",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SubmitButton(
              isLoading: false,
              boldText: true,
              label: "CHECK OUT",
              submit: () {
                // Check if a service has been selected
                if (viewModel.selectedMethod != null) {
                  // Navigate to the next screen (replace current screen)
                  _navigationService.replaceWith(Routes.wallet);
                } else {
                  // Show a SnackBar prompting the user to select a service
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a service method"),
                    ),
                  );
                }
              },
              color: kcPrimaryColor,
            ),

          ],
        ),
      ),
    );
  }

  @override
  NotificationViewModel viewModelBuilder(BuildContext context) =>
      NotificationViewModel();
}

List<Widget> buildServiceItems(NotificationViewModel viewModel) {
  const services = [
    {'image': 'assets/images/girl.png', 'name': 'Site Suitability Evaluation', 'price': '\$29.99'},
    {'image': 'assets/images/girl.png', 'name': 'Panel Cleaning', 'price': '\$19.99'},
    {'image': 'assets/images/girl.png', 'name': 'Inverter Installation', 'price': '\$39.99'},
  ];

  return services.asMap().entries.map((entry) {
    int index = entry.key;
    Map<String, String> service = entry.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Add space between each card
      child: GestureDetector(
        onTap: () {
          viewModel.setSelectedIndex(index); // Update the selected index
        },
        child: Card(
          color: viewModel.selectedIndex == index ? kcPrimaryColor : Colors.white, // Highlight selected card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3, // Add shadow for better visibility
          child: buildServiceItem(
            service['image']!,
            service['name']!,
            service['price']!,
          ),
        ),
      ),
    );
  }).toList();
}

// Pure function to build individual service item
Widget buildServiceItem(String imagePath, String serviceName, String price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Service Image
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Service Name and Price
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        // 3-dots Icon
        GestureDetector(
          onTap: () {
            // Handle more options
          },
          child: const Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
Widget buildBottomSheet(BuildContext context, TabController tabController) {
  return Container(
      height: 420,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Heading
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(
              'Select Recommended Service\nIf you require any of these services',
              textAlign: TextAlign.center, // Center the text
              style: const TextStyle(
                fontSize: 12,
                color: kcLightGrey,
              ),
            ),
          ),
        ),
        // Service List
        Expanded(
          child: ListView(
            children: [
              // Service 1
              buildServiceItem(
                'assets/images/girl.png',
                'Site Suitability Evaluation',
                '\$29.99',
              ),
              buildServiceItem(
                'assets/images/girl.png',
                'Panel Cleaning',
                '\$19.99',
              ),
              buildServiceItem(
                'assets/images/girl.png',
                'Inverter Installation',
                '\$39.99',
              ),
            ],
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter your promo code',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward, size: 25, color: Colors.black),
            ),
          ],
        ),
        Center(
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        verticalSpaceMedium,
        SubmitButton(
          isLoading: false,
          boldText: true,
          label: "CHECK OUT",
          submit: () {},
          color: kcPrimaryColor,
        ),
      ]));
}

// Widget buildServiceItem(String imagePath, String serviceName, String price) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Service Image
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // Service Name and Price
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   serviceName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   price,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // 3-dots Icon
//         GestureDetector(
//           onTap: () {
//             // Handle more options
//           },
//           child: const Icon(
//             Icons.more_vert,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     ),
//   );
// }
