import 'package:afriprize/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Support",
          style: TextStyle(
            color: kcBlackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            title: Text("Contact us"),
            subtitle: Text("Support@mail.com"),
          ),
          ListTile(
            title: Text("Phone"),
            subtitle: Text("09012345678"),
          )
        ],
      ),
    );
  }
}