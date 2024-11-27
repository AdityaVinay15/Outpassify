import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guardstudentrequest extends StatefulWidget {
  final String rollnumber;
  final String date;
  final String time;
  const Guardstudentrequest(
      {super.key,
      required this.rollnumber,
      required this.date,
      required this.time});

  @override
  State<Guardstudentrequest> createState() => _GuardstudentrequestState();
}

class _GuardstudentrequestState extends State<Guardstudentrequest> {
  final TextEditingController _purposeController = TextEditingController();
  String declinepurpose = '';
  int indexs = 0;
  String buttonState = "initial"; // initial, accepted, declined
  String? name;
  String? rollNumber;
  String? permissionDate;
  String? permissionTime;
  String? purpose;
  String? profilepicture;
  int? approvalstatus;
  int? requestnumber;
  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];

  int currentIndex = 0;
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

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchnamepic();
    if (approvalstatus == 1) {
      buttonState = "accepted";
    } else if (approvalstatus == 2) {
      buttonState = "declined";
    } else {
      buttonState = "initial";
    }
    _startListeningForNewRequests();
  }

  Future<void> fetchnamepic() async {
    try {
      final namepicshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: widget.rollnumber)
          .get();
      print("//////////////////////////");
      if (namepicshot.docs.isNotEmpty) {
        final doc = namepicshot.docs.first;
        setState(() {
          name = doc['Name'];
          profilepicture = doc['Profilepicture'];
          downloadImageUrl(profilepicture!);
          print(
              "//////////////////////PROFILE PIC FETCHED/////////////////////////");
          print(profilepicture);
        });
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Rollnumber', isEqualTo: widget.rollnumber)
          .where('Permissiondate', isEqualTo: widget.date)
          .where('Permissiontime', isEqualTo: widget.time)
          .get();
      print("//////////////////////////");
      print(querySnapshot.docs);

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          print("*******************************");

          rollNumber = doc['Rollnumber'];
          permissionDate = doc['Permissiondate'];
          permissionTime = doc['Permissiontime'];
          purpose = doc['Purpose'];
          approvalstatus = doc['Approvalstatus'];
          requestnumber = doc['Requestnumber'];
          print(approvalstatus);
        });
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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

  Future<void> updateApprovalStatus(int status) async {
    try {
      CollectionReference requests =
          FirebaseFirestore.instance.collection('Requests');
      QuerySnapshot querySnapshot = await requests
          .where('Rollnumber', isEqualTo: rollNumber)
          .where('Permissiondate', isEqualTo: widget.date)
          .where('Permissiontime', isEqualTo: widget.time)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");
          print(status);

          await doc.reference.update({'Approvalstatus': status});
          await doc.reference.update({'Declinepurpose': declinepurpose});
          if (status == 1)
            FirebaseFirestore.instance.collection('Guarddb').doc(rollNumber);
          await FirebaseFirestore.instance
              .collection('Guarddb')
              .doc(rollNumber)
              .set({
            'Rollnumber': rollNumber,
            'Permissiondate': permissionDate,
            'Permissiontime': permissionTime,
            'Requestnumber': requestnumber,
            'Studentindate': "",
            'Studentoutdate': "",
          });
          await doc.reference
              .update({'Aacceptdate': DateTime.now().toString()});
        }
        print('Approvalstatus updated successfully.');
      } else {
        print('No documents found with the specified rollnumber.');
      }
    } catch (e) {
      print('Error updating Approvalstatus: $e');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: PreferredSize(
  //       preferredSize: Size.fromHeight(70.0),
  //       child: AppBar(
  //         centerTitle: true,
  //         title: Text(
  //           "OutPassIfy",
  //           style: TextStyle(
  //               color: Colors.black, fontSize: 38, fontFamily: 'DancingScript'),
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
  //             icon: const Icon(
  //               Icons.notifications,
  //               size: 32,
  //             ),
  //             iconSize: 40,
  //             color: Colors.black,
  //           )
  //         ],
  //         backgroundColor: Color(0x80CDD1E4),
  //         shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(25),
  //                 bottomRight: Radius.circular(25))),
  //         elevation: 0,
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
  //               height: 60,
  //               width: double.infinity,
  //               decoration:
  //                   BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //               child: Center(
  //                   child: Text(
  //                 "PERMISSION",
  //                 style: TextStyle(color: Colors.black, fontSize: 30),
  //               )),
  //             ),
  //             Container(
  //               height: 130,
  //               width: double.infinity,
  //               decoration:BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //               margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                     height: double.infinity,
  //                     width: MediaQuery.of(context).size.width * 0.5,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         Container(
  //                           padding: EdgeInsets.all(10),
  //                           height: 45,
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                           //NAME
  //                           child: SingleChildScrollView(
  //                             scrollDirection: Axis.horizontal,
  //                             child: Center(
  //                               child: Center(
  //                                 child: Text(
  //                                   name ?? "Loading...",
  //                                   style: TextStyle(
  //                                     color: Colors.black,
  //                                     fontSize: 20,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           height: 45,
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(20)),
  //                           child: Center(
  //                             child: Text(
  //                               rollNumber ?? "Loading...",
  //                               style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: 20,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     child: CircleAvatar(
  //                       radius: 60,
  //                       backgroundImage: profilepicture != null
  //                           ? NetworkImage(profilepicture!)
  //                           : AssetImage('assets/images/defaultavatar.jpeg')
  //                               as ImageProvider,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(50),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               height: 45,
  //               width: double.infinity,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   Container(
  //                     height: double.infinity,
  //                     width: MediaQuery.of(context).size.width * 0.40,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20)),
  //                     padding: EdgeInsets.all(13),
  //                     child: Center(
  //                       child: Text(
  //                         permissionDate ?? "Loading...",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     height: double.infinity,
  //                     width: MediaQuery.of(context).size.width * 0.40,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20)),
  //                     padding: EdgeInsets.all(13),
  //                     child: Center(
  //                       child: Text(
  //                         permissionTime ?? "Loading...",
  //                         style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 15,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             SingleChildScrollView(
  //               child: Container(
  //                 height: MediaQuery.of(context).size.width * 0.10,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(20)),
  //                 margin: EdgeInsets.all(10),
  //                 padding: EdgeInsets.all(15),
  //                 child: Text(
  //                   purpose ?? "Loading...",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: MediaQuery.of(context).size.width * 0.12,
  //               width: double.infinity,
  //               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
  //               child: Row(
  //                 children: [
  //                   if (approvalstatus == 0) ...[
  //                     // Two buttons side by side when approvalstatus is 0
  //                     Expanded(
  //                       child: Container(
  //                         height: 45,
  //                         margin: EdgeInsets.all(3),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(17),
  //                         ),
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               updateApprovalStatus(
  //                                   1); // Update status to accepted
  //                               buttonState =
  //                                   "accepted"; // Update the button state
  //                               declinepurpose =
  //                                   _purposeController.text; // Capture purpose
  //                               GoRouter.of(context).pushNamed(
  //                                   MyAppRouteConstants
  //                                       .adminpermissionRouteName);
  //                             });
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.green,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(17),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'ACCEPT',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 15,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         height: 45,
  //                         margin: EdgeInsets.all(3),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(17),
  //                         ),
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               updateApprovalStatus(
  //                                   2); // Update status to declined
  //                               buttonState =
  //                                   "declined"; // Update the button state
  //                               declinepurpose =
  //                                   _purposeController.text; // Capture purpose
  //                               GoRouter.of(context).pushNamed(
  //                                   MyAppRouteConstants
  //                                       .adminpermissionRouteName);
  //                             });
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.red,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(17),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'DECLINE',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 15,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                   if (approvalstatus == 1) ...[
  //                     // Single button for accepted when approvalstatus is 1
  //                     Expanded(
  //                       child: Container(
  //                         height: 45,
  //                         margin: EdgeInsets.all(3),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(17),
  //                         ),
  //                         child: ElevatedButton(
  //                           onPressed: () {},
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.green,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(17),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'ACCEPTED',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 15,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                   if (approvalstatus == 2) ...[
  //                     // Single button for declined when approvalstatus is 2
  //                     Expanded(
  //                       child: Container(
  //                         height: 45,
  //                         margin: EdgeInsets.all(3),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(17),
  //                         ),
  //                         child: ElevatedButton(
  //                           onPressed: () {},
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.red,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(17),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'DECLINED',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 15,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           backgroundColor: Color(0x80CDD1E4),
  //           icon: Icon(
  //             Icons.home_filled,
  //           ),
  //           label: '',
  //         ),
  //         BottomNavigationBarItem(
  //             icon: Icon(
  //               Icons.list,
  //             ),
  //             label: '',
  //             backgroundColor: Color(0x80CDD1E4)),
  //         BottomNavigationBarItem(
  //             backgroundColor: Color(0x80CDD1E4),
  //             icon: Icon(
  //               Icons.settings,
  //             ),
  //             label: ''),
  //         BottomNavigationBarItem(
  //             backgroundColor: Color(0x80CDD1E4),
  //             icon: Icon(
  //               Icons.person,
  //             ),
  //             label: ''),
  //       ],
  //       currentIndex: indexs,
  //       selectedItemColor: Colors.black,
  //       unselectedItemColor: Colors.black,
  //       onTap: onTapped,
  //       iconSize: 40,
  //     ),
  //   );
  // }
  String? downloadUrl;
  Future<void> downloadImageUrl(String imagePath) async {
    try {
      // Reference to the Firebase Storage location
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);

      // Get the download URL
      downloadUrl = await ref.getDownloadURL();
      print(
          "uuuuuuuuuuuuurrrrrrrrrrrrrrrrrrrrrllllllllllllllllllllllllllllllllllllll");
      print("Download URL: $downloadUrl");

      // Trigger a rebuild to reflect the image URL
      setState(() {});
    } catch (e) {
      print("Error fetching download URL: $e");
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
                buildSidebarIcon(
                    "Settings", "assets/icons/settingsicon.png", 2),
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
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              decoration: BoxDecoration(
                color: Color(0x80CDD1E4),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'PERMISSION',
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 130,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side details
                                Expanded(
                                  flex: 2, // Adjust flex to take more space
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        height: 45,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            name ?? "Loading...",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            rollNumber ?? "Loading...",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right side profile picture
                                Expanded(
                                  // flex: 1, // Adjust flex to take less space
                                  child: Center(
                                    child: InstaImageViewer(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FullScreenImagePage(
                                      imageUrl: downloadUrl.toString(),
                                          
                                            ),
                                          ),
                                        );
                                  },
                                        child: CircleAvatar(
                                                  radius: MediaQuery.of(context).size.width * 0.25,
                                                  backgroundColor: Colors.grey[200], // Optional: background color
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      downloadUrl ?? 'https://via.placeholder.com/150',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        // Handle image loading error here
                                                        return Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                          size: MediaQuery.of(context).size.width * 0.1,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Additional details below
                          Container(
                            height: 45,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.03),
                                  padding: EdgeInsets.all(13),
                                  child: Center(
                                    child: Text(
                                      permissionDate ?? "Loading...",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(13),
                                  child: Center(
                                    child: Text(
                                      permissionTime ?? "Loading...",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.10,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(15),
                              child: Text(
                                purpose ?? "Loading...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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









                                