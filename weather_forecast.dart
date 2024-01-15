import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String lable;
  final IconData icon;
  final String value;
  const ForecastCard(
      {super.key,
      required this.lable,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                lable,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                size: 32,
              ),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }
}
