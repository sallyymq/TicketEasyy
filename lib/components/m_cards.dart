import 'package:flutter/material.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';
import 'package:ticketeasy/pages/manager/m_businfo.dart';

class ManagerCards extends StatelessWidget {
  final CCard card;
  final String documentId;
  final void Function()? onTap;
  const ManagerCards({Key? key, required this.card, required this.documentId, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: bluee.withOpacity(0.18),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Bus #" + card.BusNumber,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 15),
              Text(
                "Complex",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59597C),
                    fontSize: 12),
              ),
              const SizedBox(width: 15),
              Text(
                "Status",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59597C),
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 22),
              Text(
                card.Complex,
                style: TextStyle(color: Color(0xFF59597C), fontSize: 12),
              ),
              const SizedBox(width: 20),
              Text(
                card.Status,
                style: TextStyle(color: Color(0xFF59597C), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(documentId: documentId), // Pass documentId here
                ),
              );
            },
            child: Container(
              height: 25,
              width: 80,
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: orangee,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}