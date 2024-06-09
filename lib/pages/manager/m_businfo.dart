import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketeasy/components/m_BNB.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/BusInfoCard.dart';
import 'package:ticketeasy/components/currentdata.dart';
import 'package:ticketeasy/components/currentdata_status.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';

class InfoPage extends StatefulWidget {
  final String documentId;
  const InfoPage({Key? key, required this.documentId}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late TextEditingController complexController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    complexController = TextEditingController();
    statusController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Update Info"),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Buses').doc(widget.documentId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Bus not found"));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var card = CCard(
            Complex: data['Complex'],
            Status: data['Status'],
            BusNumber: (data['id'] ?? '').toString(),
          );

          // Update controllers with new data
          complexController.text = data['Complex'];
          statusController.text = data['Status'];

          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  infocards(card: card),
                  SizedBox(height: 45),
                  Text(
                    '    Current Data',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CurrentData(card: card, complexController: complexController),
                  SizedBox(height: 10),
                  CurrentDataStatus(card: card, statusController: statusController),
                  SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        updateBusInfo();
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidgetM(),
    );
  }

  void updateBusInfo() async {
    await FirebaseFirestore.instance.collection('Buses').doc(widget.documentId).update({
      'Complex': complexController.text,
      'Status': statusController.text,
    });
    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Text('Update done successfully', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: orangee, // Use the orangee color from the theme
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
