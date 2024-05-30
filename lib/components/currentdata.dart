import 'package:flutter/material.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';

class CurrentData extends StatelessWidget {
  final CCard card;
  final TextEditingController complexController;
  const CurrentData({Key? key, required this.card, required this.complexController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    complexController.text = card.Complex; // Pre-fill with existing value
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bluee.withOpacity(0.12),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            color: Colors.black,
            size: 25,
          ),
          SizedBox(width: 3),
          Text(
            "Complex",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 60),
          Expanded(
            child: TextField(
              controller: complexController,
              decoration: InputDecoration(
                hintText: 'Enter complex',
              ),
            ),
          ),
        ],
      ),
    );
  }
}