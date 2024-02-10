import 'package:afriprize/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyTabContent extends StatelessWidget {

  final String title;
  final String description;
  final List<String> rules;

  const EmptyTabContent({
    Key? key,

    required this.title,
    required this.description,
    required this.rules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20), // Adjust padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpaceMedium,
          const Image(image: AssetImage('assets/images/ticket_tag.png')),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rules',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Panchang"),
                  ),
                  ...rules.map(
                        (rule) => Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(rule, style: TextStyle(fontSize: 10),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
