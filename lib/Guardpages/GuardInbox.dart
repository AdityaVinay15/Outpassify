import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guardinstatus extends StatefulWidget {
  const Guardinstatus({super.key});

  @override
  State<Guardinstatus> createState() => _GuardinstatusState();
}

class _GuardinstatusState extends State<Guardinstatus> {
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
        .where('Studentoutdate', isEqualTo: '')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docChanges
          .any((change) => change.type == DocumentChangeType.added)) {
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
  //       child: Column(
  //         children: [
  //           Container(
  //             height: MediaQuery.of(context).size.width * 0.2,
  //             width: double.infinity,
  //             decoration:
  //                 BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //             child: Center(
  //                 child: Text(
  //               "INBOX",
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: MediaQuery.of(context).size.width * 0.08),
  //             )),
  //           ),
  //           Expanded(
  //             child: StreamBuilder<QuerySnapshot>(
  //               stream: FirebaseFirestore.instance
  //                   .collection('Guarddb')
  //                   .where('Studentoutdate', isNotEqualTo: '')
  //                   .snapshots(), // Real-time stream of all documents in the collection
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Center(child: CircularProgressIndicator());
  //                 } else if (snapshot.hasError) {
  //                   return Center(child: Text('Error: ${snapshot.error}'));
  //                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                   return Center(child: Text('No permissions found.'));
  //                 } else {
  //                   final permissions = snapshot.data!.docs.map((doc) {
  //                     final data = doc.data() as Map<String, dynamic>;
  //                     return {
  //                       'Rollnumber': data['Rollnumber'] ?? 'N/A',
  //                       'Permissiondate': data['Permissiondate'] ?? 'N/A',
  //                       'Approvalstatus': data['Approvalstatus'] ?? 0,
  //                       'Permissiontime': data['Permissiontime'] ?? '',
  //                     };
  //                   }).toList();

  //                   permissions.sort((a, b) {
  //                     int requestNumberA = a['Requestnumber'] ?? 0;
  //                     int requestNumberB = b['Requestnumber'] ?? 0;
  //                     return requestNumberB
  //                         .compareTo(requestNumberA); // Descending order
  //                   });

  //                   return ListView.builder(
  //                     itemCount: permissions.length,
  //                     itemBuilder: (context, index) {
  //                       final permission = permissions[index];
  //                       final rollnumber = permission['Rollnumber'];
  //                       final date = permission['Permissiondate'];
  //                       final time = permission['Permissiontime'];

  //                       return GestureDetector(
  //                         onTap: () {
  //                           GoRouter.of(context).pushNamed(
  //                             MyAppRouteConstants.guardstudentinfo,
  //                             pathParameters: {
  //                               'rollnumber': rollnumber.toString(),
  //                               'date': date.toString(),
  //                               'time': time.toString(),
  //                             },
  //                           );
  //                         },
  //                         child: Container(
  //                           height: MediaQuery.of(context).size.width * 0.2,
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(20)),
  //                           margin: EdgeInsets.symmetric(
  //                               vertical: 10, horizontal: 10),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                             children: [
  //                               Flexible(
  //                                   child: Center(
  //                                       child: Text(
  //                                 rollnumber,
  //                                 textAlign: TextAlign.start,
  //                                 style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.width *
  //                                           0.04,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ))),
  //                               Flexible(
  //                                   child: Center(
  //                                       child: Text(
  //                                 date,
  //                                 textAlign: TextAlign.start,
  //                                 style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.width *
  //                                           0.04,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ))),
  //                               Flexible(
  //                                   child: Center(
  //                                       child: Text(
  //                                 "Out",
  //                                 textAlign: TextAlign.start,
  //                                 style: TextStyle(
  //                                   color: Colors.red,
  //                                   fontSize:
  //                                       MediaQuery.of(context).size.width *
  //                                           0.05,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ))),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 }
  //               },
  //             ),
  //           ),
  //         ],
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
  Future<String?> getStudentName(String rollnumber) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .where('Rollnumber', isEqualTo: rollnumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      return document.get('Name') as String;
    } else {
      return null; // No document found
    }
  } catch (e) {
    print('Error fetching student name: $e');
    return null; // Error occurred
  }
}


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
                    'INBOX',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Request list
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Guarddb')
                        .where('Studentoutdate', isNotEqualTo: '')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No permissions found.'));
                      } else {
                        final permissions = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return {
                            'Rollnumber': data['Rollnumber'] ?? 'N/A',
                            'Permissiondate': data['Permissiondate'] ?? 'N/A',
                            'Permissiontime': data['Permissiontime'] ?? '',
                            'Studentoutdate': data['Studentoutdate'] ?? '',
                          };
                        }).toList();

                        return ListView.builder(
                          itemCount: permissions.length,
                          itemBuilder: (context, index) {
                            final permission = permissions[index];
                            final rollnumber = permission['Rollnumber'];
                            final date = permission['Permissiondate'];
                            final time = permission['Permissiontime'];
                            final studentouttime = permission['Studentoutdate'];
                            String slicedTime =
                                studentouttime.substring(11, 16) +
                                    '   ' +
                                    studentouttime
                                        .substring(0, 10)
                                        .split('-')
                                        .reversed
                                        .join('/');

                            return FutureBuilder<String?>(
                              future: getStudentName(rollnumber),
                              builder: (context, nameSnapshot) {
                                if (nameSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (nameSnapshot.hasError) {
                                  return Center(child: Text('Error: ${nameSnapshot.error}'));
                                } else {
                                  final name = nameSnapshot.data ?? 'Name not found';

                                  return GestureDetector(
                                    onTap: () {
                                      GoRouter.of(context).pushNamed(
                                        MyAppRouteConstants.guardstudentinfo,
                                        pathParameters: {
                                          'rollnumber': rollnumber.toString(),
                                          'date': date.toString(),
                                          'time': time.toString(),
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            rollnumber,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context).size.width * 0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context).size.width * 0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Out",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: MediaQuery.of(context).size.width * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 2.0),
                                              Text(
                                                slicedTime,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: MediaQuery.of(context).size.width * 0.01,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
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














