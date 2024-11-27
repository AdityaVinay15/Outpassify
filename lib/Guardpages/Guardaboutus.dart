import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guardaboutus extends StatefulWidget {
  const Guardaboutus({super.key});

  @override
  State<Guardaboutus> createState() => _GuardaboutusState();
}

class _GuardaboutusState extends State<Guardaboutus> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).pushNamed(MyAppRouteConstants.logout);
  }
  User? user;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _startListeningForNewRequests();
  }
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
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardsettingsRouteName);
        break;
      case 3:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardinfoRouteName);
        break;
      default:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.guardRouteName);
    }
  }

  // bool sw = false;

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
  //                   .pushNamed(MyAppRouteConstants.studentpermissionRouteName);
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
  //         color: Color(0x80CDD1E4),
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               height: MediaQuery.of(context).size.width * 0.2,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //               child: Center(
  //                 child: Text(
  //                   "About Us",
  //                   style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.08),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.all(10),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
                      
  //                     // SizedBox(height: 15), // Space between names and paragraph
  //                     Text(
  //                       "Welcome to Outpassify, your ultimate solution for efficient outpass management. Designed with both students and administrative staff in mind, Outpassify streamlines the process of requesting and approving outpasses, making campus life smoother and more organized.\n\n""Our system then notifies the relevant authorities, who can review and approve these requests with just a few clicks. Our goal is to reduce paperwork, save time, and enhance the overall efficiency of outpass management within educational campuses.\n\n""We are committed to providing a reliable, secure, and easy-to-use platform that meets the needs of modern educational institutions.",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: MediaQuery.of(context).size.width * 0.04,
  //                         fontStyle: FontStyle.italic, // Apply italic style
  //                       ),
  //                       textAlign: TextAlign.start,
  //                     ),
  //                     SizedBox(height: 10),
  //                     Text("Created by",style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: MediaQuery.of(context).size.width * 0.06,
  //                         fontStyle: FontStyle.italic,
  //                         fontWeight: FontWeight.bold // Apply italic style
  //                       ),
  //                       textAlign: TextAlign.start,),
  //                     GestureDetector(
  //                       onTap: () {
  //                         // Replace with your desired route name
  //                         // GoRouter.of(context).pushNamed(MyAppRouteConstants.firstRouteName);
  //                       },
  //                       child: Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.symmetric(vertical: 10),
  //                         child: Center(
  //                           child: Text(
  //                             'ADITYA VINAY UTTARAVILLI',
  //                             style: TextStyle(
  //                                 fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.red),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     // SizedBox(height: 5), // Space between the two names
  //                     GestureDetector(
  //                       onTap: () {
  //                         // Replace with your desired route name
  //                         // GoRouter.of(context).pushNamed(MyAppRouteConstants.secondRouteName);
  //                       },
  //                       child: Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.symmetric(vertical: 10),
  //                         child: Center(
  //                           child: Text(
  //                             'CHARAN SAI MURAKONDA',
  //                             style: TextStyle(
  //                                 fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.red),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
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
          'About Us',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: 10),
      Expanded(
        child: Column(
          children: [
            // TextField for feedback input
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      // SizedBox(height: 15), // Space between names and paragraph
                      Text(
                        "Welcome to Outpassify, your ultimate solution for efficient outpass management. Designed with both students and administrative staff in mind, Outpassify streamlines the process of requesting and approving outpasses, making campus life smoother and more organized.\n\n""Our system then notifies the relevant authorities, who can review and approve these requests with just a few clicks. Our goal is to reduce paperwork, save time, and enhance the overall efficiency of outpass management within educational campuses.\n\n""We are committed to providing a reliable, secure, and easy-to-use platform that meets the needs of modern educational institutions.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                          fontStyle: FontStyle.italic, // Apply italic style
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 10),
                      Text("Created by",style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.01,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold // Apply italic style
                        ),
                        textAlign: TextAlign.start,),
                      GestureDetector(
                        onTap: () {
                          // Replace with your desired route name
                          // GoRouter.of(context).pushNamed(MyAppRouteConstants.firstRouteName);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'ADITYA VINAY UTTARAVILLI',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.01, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 5), // Space between the two names
                      GestureDetector(
                        onTap: () {
                          // Replace with your desired route name
                          // GoRouter.of(context).pushNamed(MyAppRouteConstants.secondRouteName);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'CHARAN SAI MURAKONDA',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.01, color: Colors.red),
                            ),
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
