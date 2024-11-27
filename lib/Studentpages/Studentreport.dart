import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';

class Studentreport extends StatefulWidget {
  const Studentreport({super.key});

  @override
  State<Studentreport> createState() => _Studentreport();
}

class _Studentreport extends State<Studentreport> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final TextEditingController _feedbackController = TextEditingController();
  late Future<Map<String, int>> statusData;
  late AnimationController _animationController;
  User? user;
  bool hasNotifications = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _checkForNotifications();
    statusData = getRequestStatusCounts(user?.email ?? '');
  }

  Future<String?> wardenphno() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .where('Role', isEqualTo: 'Admin')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No documents found");
        return null;
      }

      final document = querySnapshot.docs.first.data();
      return document['Contactnumber'].toString();
    } catch (e) {
      print("Error fetching phone number: $e");
      return null;
    }
  }

  Future<void> _checkForNotifications() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Approvalstatus', isEqualTo: 0)
          .get();

      setState(() {
        hasNotifications = querySnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<Map<String, int>> getRequestStatusCounts(String email) async {
    try {
      final reportstats = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Email', isEqualTo: email)
          .get();

      int pending = 0;
      int approved = 0;
      int declined = 0;

      for (var doc in reportstats.docs) {
        final status = doc['Approvalstatus'];
        if (status == 0) pending++;
        if (status == 1) approved++;
        if (status == 2) declined++;
      }

      return {'Pending': pending, 'Approved': approved, 'Declined': declined};
    } catch (e) {
      print('Error fetching request statuses: $e');
      return {'Pending': 0, 'Approved': 0, 'Declined': 0};
    }
  }

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.homeRouteName);
        break;
      case 1:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.studentpermissionRouteName);
        break;
      case 2:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.studentsettingsName);
        break;
      case 3:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.studentinfoName);
        break;
      default:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.homeRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                fontFamily: 'DancingScript'),
          ),
          leading: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Image.asset(
              'lib/images/logo3.png',
              width: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                final phn = await wardenphno();
                if (phn != null && phn.isNotEmpty) {
                  final url = 'tel:$phn';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else {
                  print('No phone number available');
                }
              },
              icon: Icon(
                Icons.call,
                size: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
              ),
            ),
          ],
          backgroundColor: Color(0x80CDD1E4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0x80CDD1E4),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Center(
                  child: Text(
                    "PERMISSIONS REPORT",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FutureBuilder<Map<String, int>>(
                    future: statusData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity:
                                    0.5 + 0.5 * _animationController.value,
                                child: Image.asset(
                                  'lib/images/logo3.png',
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.2,
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return PieChartWidget(data: snapshot.data!);
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Color(0x80CDD1E4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/homeicon.png',
                width: screenWidth * 0.2,
                height: screenHeight * 0.04,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/inboxicon.png',
                width: screenWidth * 0.2,
                height: screenHeight * 0.05,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/settingsicon.png',
                width: screenWidth * 0.2,
                height: screenHeight * 0.045,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/profileicon.png',
                width: screenWidth * 0.2,
                height: screenHeight * 0.04,
              ),
              label: '',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: onTapped,
          iconSize: 40,
          backgroundColor: Colors.transparent,
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;

  const PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = data.entries.map((entry) {
      return PieChartSectionData(
        color: _getColorForStatus(entry.key),
        value: entry.value.toDouble(),
        title: '${entry.value}',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: Center(
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 4,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('Pending', Colors.orange),
            SizedBox(width: 10),
            _buildLegend('Approved', Colors.green),
            SizedBox(width: 10),
            _buildLegend('Declined', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
