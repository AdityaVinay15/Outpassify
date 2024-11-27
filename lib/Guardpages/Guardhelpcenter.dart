import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/components/newuser.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Guardhelpcenter extends StatefulWidget {
  const Guardhelpcenter({super.key});

  @override
  State<Guardhelpcenter> createState() => _Guardhelpcenter();
}

class _Guardhelpcenter extends State<Guardhelpcenter> {
  int indexs = 0;
  final TextEditingController _feedbackController = TextEditingController();
  User? user;
  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _startListeningForNewRequests();
  }
  void _showSuccessPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.green[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Feedback Sent!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
  Center(
    child: TextButton(
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.white, // Button background color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Increase padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      child: Text(
        'OK',
        style: TextStyle(
          color: Colors.green[700], // Text color for contrast
          fontWeight: FontWeight.bold,
          fontSize: 16, // Increase font size if needed
        ),
      ),
    ),
  ),
],

      );
    },
  );
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
  //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //               child: Center(
  //                   child: Text(
  //                 "Feedback",
  //                 style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.08),
  //               )),
  //             ),
  //             Container(
  //               margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.all(10), // Adjust the padding as needed
  //                 child: TextField(
  //                   controller: _feedbackController,
  //                   style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.black),
  //                   maxLines: 10,
  //                   decoration: InputDecoration(
  //                     labelText: 'Enter your text',
  //                     labelStyle: TextStyle(color: Colors.black),
  //                     alignLabelWithHint: true, // Align the label with the hint
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide:
  //                           BorderSide.none, // Remove the default border
  //                     ),
  //                     contentPadding: EdgeInsets.symmetric(
  //                         vertical: 10,
  //                         horizontal: 10), // Add padding inside the TextField
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               width: MediaQuery.of(context).size.height * 0.2,
  //               height: MediaQuery.of(context).size.height * 0.06,
  //               margin: EdgeInsets.all(3),
  //               decoration:
  //                   BoxDecoration(borderRadius: BorderRadius.circular(17)),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   // Handle button tap
  //                   launchUrlString('mailto:x@gmail.com?''subject:OUTPASSIFY - SUPPORT''body:$_feedbackController'); 
  //                   print('Feedback sent!');
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.black,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(17),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'SUBMIT',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: MediaQuery.of(context).size.width * 0.04,
  //                   ),
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
          'FEEDBACK',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: 20),
      Expanded(
        child: Column(
          children: [
            // TextField for feedback input
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: InputBorder.none,
                ),
                maxLines: 10,
                // Add controller here if needed
              ),
            ),
            SizedBox(height: 20),
            // Submit button
            ElevatedButton(
              onPressed: () {
                // Handle submit action here
                    sendEmail(
                        "adityauttaravilli@gmail.com", _feedbackController.text.toString(),user!.email.toString()+" Feedback","");
                        _feedbackController.clear();
                    _showSuccessPopup(context, 'Feedback sent successfully!'); 
              },
              child: Text('SUBMIT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Background color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 20, color: Colors.white), // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
