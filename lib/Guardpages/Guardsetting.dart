import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guardsetting extends StatefulWidget {
  const Guardsetting({super.key});

  @override
  State<Guardsetting> createState() => _GuardsettingState();
}

class _GuardsettingState extends State<Guardsetting> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).pushNamed(MyAppRouteConstants.logout);
  }

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _startListeningForNewRequests();
  }

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardRouteName);
        break;
      case 1:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.guardstatusRouteName);
        break;
      case 2:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.guardsettingsRouteName);
        break;
      case 3:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardinfoRouteName);
        break;
      default:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardRouteName);
    }
  }

  bool sw = false;
  bool hasNotifications = false;
  late StreamSubscription<QuerySnapshot> _subscription;
  void _startListeningForNewRequests() {
    _subscription = FirebaseFirestore.instance
        .collection('Guarddb')
        .where('Studentoutdate',isEqualTo: '')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docChanges.any((change) => change.type == DocumentChangeType.added)) {
        setState(() {
          hasNotifications = true;
        });
      }
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: PreferredSize(
  //       preferredSize: Size.fromHeight(70.0),
  //       child: AppBar(
  //         elevation: 0,
  //         centerTitle: true,
  //         title: Text(
  //           "OutPassIfy",
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: MediaQuery.of(context).size.width * 0.08,
  //               fontFamily: 'DancingScript'),
  //         ),
  //         leading: Container(
  //           height: MediaQuery.of(context).size.height * 0.07,
  //           child: Image.asset(
  //             'lib/images/logo3.png',
  //             width: MediaQuery.of(context).size.height * 0.3,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           IconButton(
  //             onPressed: () {
  //               GoRouter.of(context)
  //                   .pushNamed(MyAppRouteConstants.guardinboxRouteName);
  //             },
  //             icon: Icon(
  //               Icons.notifications,
  //               size: MediaQuery.of(context).size.width *
  //                   0.1, // Adjust size as needed
  //               color: hasNotifications ? Colors.red : Colors.black,
  //             ),
  //           ),
  //         ],
  //         backgroundColor: Color(0x80CDD1E4),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(35),
  //                 bottomRight: Radius.circular(35))),
  //       ),
  //     ),
  //     body: Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           color: Color(0x80CDD1E4), borderRadius: BorderRadius.circular(20)),
  //       margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               height: MediaQuery.of(context).size.width * 0.2,
  //               width: double.infinity,
  //               decoration:
  //                   BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //               child: Center(
  //                   child: Text(
  //                 "SETTINGS",
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: MediaQuery.of(context).size.width * 0.08),
  //               )),
  //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 GoRouter.of(context)
  //                     .pushNamed(MyAppRouteConstants.resetpass);
  //               },
  //               child: Container(
  //                 height: MediaQuery.of(context).size.width * 0.2,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //                 padding: EdgeInsets.all(20),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Reset password",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: MediaQuery.of(context).size.width * 0.06,
  //                       ),
  //                       textAlign: TextAlign.start,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 print("Notifications Container Tapped");
  //                 // Add any functionality you want when the container is tapped
  //               },
  //               child: Container(
  //                 height: MediaQuery.of(context).size.width * 0.2,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(20)),
  //                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //                 padding: EdgeInsets.all(20),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Notifications",
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: MediaQuery.of(context).size.width * 0.06),
  //                       textAlign: TextAlign.start,
  //                     ),
  //                     Transform.scale(
  //                       scale: 1.1,
  //                       child: Switch(
  //                         value: sw,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             sw = value;
  //                           });
  //                         },
  //                         activeColor: Colors.blue,
  //                         inactiveThumbColor: Colors.black,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 GoRouter.of(context)
  //                     .pushNamed(MyAppRouteConstants.guardhelpcenter);
  //                 // Add any functionality you want when the container is tapped
  //               },
  //               child: Container(
  //                 height: 70,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(20)),
  //                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //                 padding: EdgeInsets.all(20),
  //                 child: Text(
  //                   "Feedback",
  //                   style: TextStyle(color: Colors.black, fontSize: 22),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 GoRouter.of(context)
  //                     .pushNamed(MyAppRouteConstants.guardaboutus);
  //               },
  //               child: Container(
  //                 height: 70,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(20)),
  //                 padding: EdgeInsets.all(20),
  //                 child: Text(
  //                   "About Us",
  //                   style: TextStyle(color: Colors.black, fontSize: 22),
  //                 ),
  //                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: signUserOut,
  //               child: Container(
  //                 height: 70,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(20)),
  //                 margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //                 padding: EdgeInsets.symmetric(horizontal: 25),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.logout,
  //                       size: 32,
  //                       color: Colors.black,
  //                     ),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       "Logout",
  //                       style: TextStyle(color: Colors.red, fontSize: 22),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     bottomNavigationBar: Container(
  //       padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
  //       decoration: BoxDecoration(
  //         color: Color(0x80CDD1E4), // Background color
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(35),
  //           topRight: Radius.circular(35),
  //         ),
  //       ),
  //       child: BottomNavigationBar(
  //         elevation: 0,
  //         type: BottomNavigationBarType.fixed,
  //         items: <BottomNavigationBarItem>[
  //           BottomNavigationBarItem(
  //             icon: Image.asset(
  //               'assets/icons/homeicon.png',
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               height: MediaQuery.of(context).size.height * 0.04,
  //             ),
  //             label: '',
  //           ),
  //           BottomNavigationBarItem(
  //             icon: Image.asset(
  //               'assets/icons/inboxicon.png',
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               height: MediaQuery.of(context).size.height * 0.05,
  //             ),
  //             label: '',
  //           ),
  //           BottomNavigationBarItem(
  //             icon: Image.asset(
  //               'assets/icons/settingsicon.png',
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               height: MediaQuery.of(context).size.height * 0.045,
  //             ),
  //             label: '',
  //           ),
  //           BottomNavigationBarItem(
  //             icon: Image.asset(
  //               'assets/icons/profileicon.png',
  //               width: MediaQuery.of(context).size.width * 0.2,
  //               height: MediaQuery.of(context).size.height * 0.04,
  //             ),
  //             label: '',
  //           ),
  //         ],
  //         currentIndex: currentIndex,
  //         selectedItemColor: Colors.black,
  //         unselectedItemColor: Colors.black,
  //         onTap: onTapped,
  //         iconSize: 40,
  //         backgroundColor: Colors.transparent, // Remove the background color
  //         // Align icons vertically
  //         selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
  //         unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.white,
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: AppBar(scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Image.asset(
                'lib/images/logo3.png',
                width: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "OutPassIfy",
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontFamily: 'DancingScript',
              ),
            ),
          ],
        ),
        backgroundColor: Color(0x80CDD1E4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
      ),
    ),
    body: Row(
      children: [
        // Sidebar
        Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
          decoration: BoxDecoration(
            color: Color(0x80CDD1E4),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Sidebar buttons with icons and labels
              buildSidebarIcon("Home", "assets/icons/homeicon.png", 0),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              buildSidebarIcon("Inbox", "assets/icons/inboxicon.png", 1),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              buildSidebarIcon("Settings", "assets/icons/settingsicon.png", 2),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              buildSidebarIcon("Profile", "assets/icons/profileicon.png", 3),
            ],
          ),
        ),
        // Central container
        Expanded(
          
          child: Container(
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.height * 0.8,
  margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
  padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
  decoration: BoxDecoration(
    color: Color(0x80CDD1E4),
    borderRadius: BorderRadius.circular(40),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: 20),
      // List of settings and options
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(MyAppRouteConstants.resetpass);
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reset password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(MyAppRouteConstants.guardhelpcenter);
                  // Add any functionality you want when the container is tapped
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Feedback",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(MyAppRouteConstants.guardaboutus);
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "About Us",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                ),
              ),
              GestureDetector(
                onTap: signUserOut,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 32,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.red, fontSize: 22),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
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
Widget buildSidebarIcon(String label, String iconPath, int index) {
  return Column(
    children: [
      IconButton(
        icon: Image.asset(
          iconPath,
          width: MediaQuery.of(context).size.width * 0.08,
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        onPressed: () => onTapped(index),
      ),
      Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: MediaQuery.of(context).size.width * 0.01,
        ),
      ),
    ],
  );


}
}
