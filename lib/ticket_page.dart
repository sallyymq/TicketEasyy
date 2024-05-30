import 'package:flutter/material.dart';
import 'package:ticketeasy/bottom_navigation_bar_widget.dart';
import 'package:ticketeasy/ticket_card_widget.dart';

class TicketPage extends StatelessWidget {
  final List<Map<String, String>> tickets;

  TicketPage({Key? key, required this.tickets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Tickets in TicketPage: $tickets'); // Debug statement

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Purchased Tickets",
          style: TextStyle(
            color: Color(0xFF59597C),
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/logo.png',
              width: 53,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: tickets.isEmpty
          ? Center(child: Text('No tickets available'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return TicketCard(
                  purchasedDate: ticket['purchasingDate']!,
                  qrCodeData: ticket['qrCodeData']!,
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBarWidget(tickets: tickets),
    );
  }
}
