import 'package:flutter/material.dart';

class AdditinalInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;

  const AdditinalInfo(
      {super.key,
      required this.icon,
      required this.lable,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 10,
          child: Icon(
            icon,
            size: 32,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          lable,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
