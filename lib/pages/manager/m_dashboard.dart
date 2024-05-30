import 'package:flutter/material.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/m_BNB.dart';

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Analytics Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Dashboard "),
      body: Container(
        child: Center(
          
        ),
      ),
           bottomNavigationBar: BottomNavigationBarWidgetM(),

    );
  }
}
