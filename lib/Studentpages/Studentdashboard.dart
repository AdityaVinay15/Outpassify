// // import 'dart:math';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:full_screen_image/full_screen_image.dart';
// import 'package:go_router/go_router.dart';
// import 'package:insta_image_viewer/insta_image_viewer.dart';
// import 'package:outpassify/components/Noticationsserver.dart';
// import 'package:outpassify/components/export.dart';
// import 'package:outpassify/routes/app_route_constants.dart';
// import 'package:outpassify/Studentpages/Studentpermissions.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Studentdashboard extends StatefulWidget {
//   const Studentdashboard({super.key});

//   @override
//   State<Studentdashboard> createState() => _StudentDashboardState();
// }

// class _StudentDashboardState extends State<Studentdashboard> {
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//   final TextEditingController purposeController = TextEditingController();
//   User? user;
//   late Future<DocumentSnapshot> userData;
//   String? imageUrl; // Variable to store the image URL
//   String? name;
//   int? status;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     if (user != null && user!.email != null) {
//       userData = fetchUserData(user!.email!);
//     }
//     // exportExcel();
//     _checkForNotifications();
//     _deleteOldRequests();
//   }

//   Future<void> _deleteOldRequests() async {
//     print(
//         "I am in the deleteOld request data aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
//     try {
//       // Fetch the requests without ordering directly from Firestore
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('Requests')
//           .where('Email', isEqualTo: user?.email)
//           .get();

//       // Sort the documents locally using the 'Requestnumber' field
//       List<QueryDocumentSnapshot> sortedDocs = querySnapshot.docs.toList()
//         ..sort((a, b) {
//           var requestNumberA = a['Requestnumber'];
//           var requestNumberB = b['Requestnumber'];
//           // Sorting in ascending order
//           return requestNumberA.compareTo(requestNumberB);
//         });

//       // Check if the number of documents exceeds 30
//       if (sortedDocs.length > 30) {
//         // Calculate how many documents need to be deleted
//         int documentsToDelete = sortedDocs.length - 30;

//         // Iterate and delete the oldest documents
//         for (int i = 0; i < documentsToDelete; i++) {
//           var doc = sortedDocs[i];
//           if (doc["Approvalstatus"] != 0)
//             await sortedDocs[i].reference.delete();
//         }
//         print(
//             'Deleted $documentsToDelete old requestsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssseeeeeeeeeeeeeeeee.');
//       } else {
//         print(
//             'No old requests to deleteqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.');
//       }
//     } catch (e) {
//       print(
//           'Error deleting old requestsaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $e');
//     }
//   }

//   Future<String?> wardenphno() async {
//     try {
//       // Example code - adjust according to your actual implementation
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Admins')
//           .where('Role', isEqualTo: 'Admin')
//           .get();

//       // Check if documents exist
//       if (querySnapshot.docs.isEmpty) {
//         print("No documents found");
//         return null;
//       }

//       // Safely get the first document's field
//       final document = querySnapshot.docs.first.data();
//       return document['Contactnumber'].toString();
//     } catch (e) {
//       print("Error fetching phone number: $e");
//       return null;
//     }
//   }

//   Future<DocumentSnapshot> fetchUserData(String email) async {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('Students')
//           .doc(email)
//           .get();

//       // Update the state with user data
//       setState(() {
//         name = docSnapshot['Name'] ?? 'Unknown Name';
//         status = docSnapshot['Status'] ?? 0;
//         imageUrl =
//             docSnapshot['Profilepicture'] ?? 'lib/images/Defaultwelcomer.jpg';
//       });

//       return docSnapshot;
//     } catch (e) {
//       print("Error fetching user data: $e");
//       return Future.error(e);
//     }
//   }

//   bool hasNotifications = false;

//   Future<void> _checkForNotifications() async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Requests')
//           .where('Approvalstatus', isEqualTo: 0)
//           .get();
//       setState(() {
//         hasNotifications = querySnapshot.docs.isNotEmpty;
//       });
//     } catch (e) {
//       print('Error fetching notifications: $e');
//     }
//   }

//   Future<int> getNextIndex() async {
//     final docRef =
//         FirebaseFirestore.instance.collection('system').doc('counters');

//     try {
//       final docSnapshot = await docRef.get();
//       final currentIndex = docSnapshot.exists
//           ? (docSnapshot.data()?['requestIndex'] ?? 0) as int
//           : 0;

//       final newIndex = currentIndex + 1;

//       await docRef.set({'requestIndex': newIndex}, SetOptions(merge: true));

//       return newIndex;
//     } catch (e) {
//       print("Error getting or updating index: $e");
//       return 0;
//     }
//   }

//   void signUserIn() async {
//     final date = dateController.text;
//     final time = timeController.text;
//     final purpose = purposeController.text;
//     if (date.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Date cannot be empty!',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//           duration: Duration(milliseconds: 500),
//         ),
//       );
//       return;
//     }
//     if (time.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Time cannot be empty!',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//           duration: Duration(milliseconds: 500),
//         ),
//       );
//       return;
//     }
//     if (purpose.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Purpose cannot be empty!',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//           duration: Duration(milliseconds: 500),
//         ),
//       );
//       return;
//     }

//     try {
//       String rollNumber = await fetchUserDetails();
//       final index = await getNextIndex();
//       final pstd = DateTime.now().toString();
//       await FirebaseFirestore.instance
//           .collection('Requests')
//           .doc(index.toString())
//           .set({
//         'Requestnumber': index,
//         'Rollnumber': rollNumber,
//         'Email': user?.email,
//         'Aacceptdate': null,
//         'Approvalstatus': 0,
//         'Permissiondate': date,
//         'Permissiontime': time,
//         'Purpose': purpose,
//         'Declinepurpose': null,
//         'Studentindate': null,
//         'Studentoutdate': null,
//         'Studentpermissionsentdate': pstd,
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Request Sent successfully!',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.green,
//           duration: Duration(milliseconds: 500), // Set the duration here
//         ),
//       );

//       dateController.clear();
//       timeController.clear();
//       purposeController.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Error sending request',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.red,
//           duration: Duration(milliseconds: 500),
//         ),
//       );
//     }
//   }

//   Future<String> fetchUserDetails() async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Students')
//           .where('Email', isEqualTo: user?.email)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         final docSnapshot = querySnapshot.docs.first;
//         return docSnapshot['Rollnumber'];
//       } else {
//         print("User document does not exist in Firestore");
//         return "";
//       }
//     } catch (e) {
//       print("Error fetching user details: $e");
//       return "";
//     }
//   }

//   Future<void> fetchAdminDeviceTokens() async {
//     try {
//       if (user?.email != null) {
//         final snap = await FirebaseFirestore.instance
//             .collection('Students')
//             .doc(user!.email!)
//             .get();

//         FirebaseFirestore firestore = FirebaseFirestore.instance;
//         CollectionReference adminsCollection = firestore.collection('Admins');
//         QuerySnapshot querySnapshot = await adminsCollection.get();

//         for (QueryDocumentSnapshot document in querySnapshot.docs) {
//           String? deviceToken = document.get('Devicetoken');
//           if (deviceToken != null) {
//             PushNotificationService.sendNotification(
//               deviceToken,
//               context,
//               snap['Rollnumber'],
//               purposeController.text,
//             );
//           }
//         }
//       } else {
//         throw Exception("User email is null");
//       }
//     } catch (e) {
//       print('Error fetching admin device tokens: $e');
//     }
//   }

//   int currentIndex = 0;

//   void onTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.homeRouteName);
//         break;
//       case 1:
//         GoRouter.of(context)
//             .pushNamed(MyAppRouteConstants.studentpermissionRouteName);
//         break;
//       case 2:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.studentsettingsName);
//         break;
//       case 3:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.studentinfoName);
//         break;
//       default:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.homeRouteName);
//     }
//   }

//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         dateController.text =
//             "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null && picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//         timeController.text = selectedTime.format(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // resizeToAvoidBottomInset: false,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0),
//         child: AppBar(
//           scrolledUnderElevation: 0,
//           centerTitle: true,
//           title: Text(
//             "OutPassIfy",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: MediaQuery.of(context).size.width * 0.08,
//               fontFamily: 'DancingScript',
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               onPressed: () async {
//                 // Await the result of the future
//                 final phn = await wardenphno();
//                 print("pppppppppphhhhhhhhhhnnnnnnnnnnnnnnnnnnnnn");
//                 print(phn);

//                 // Check if the phone number is not null and is valid
//                 if (phn != null && phn.isNotEmpty) {
//                   final url = 'tel:$phn';
//                   if (await canLaunch(url)) {
//                     await launch(url);
//                   } else {
//                     throw 'Could not launch $url';
//                   }
//                 } else {
//                   print('No phone number available');
//                   // Optionally show a message to the user
//                 }
//               },
//               icon: Icon(
//                 Icons.call,
//                 size: MediaQuery.of(context).size.width * 0.1,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//           leading: Container(
//             height: MediaQuery.of(context).size.height * 0.07,
//             child: Image.asset(
//               'lib/images/logo3.png',
//               width: MediaQuery.of(context).size.height * 0.3,
//             ),
//           ),
//           backgroundColor: Color(0x80CDD1E4),
//           elevation: 0,
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.width * 0.80,
//                     margin: EdgeInsets.only(bottom: 15),
//                     decoration: BoxDecoration(
//                       color: Color(0x80CDD1E4),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(50),
//                         bottomRight: Radius.circular(50),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 25, horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(73),
//                           ),
//                           child: InstaImageViewer(
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Open the full-screen image viewer
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => FullScreenImagePage(
//                                       imageUrl: imageUrl ??
//                                           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s',
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: CircleAvatar(
//                                 radius: 75,
//                                 backgroundColor: Colors.white,
//                                 backgroundImage: CachedNetworkImageProvider(
//                                   imageUrl ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Text(
//                               "Hello, ${name ?? 'User'}",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize:
//                                     MediaQuery.of(context).size.width * 0.08,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     child: Text(
//                       "Would you like to request permission?",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: MediaQuery.of(context).size.width * 0.04,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     height: MediaQuery.of(context).size.width * 0.05,
//                     width: MediaQuery.of(context).size.width * 0.80,
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.width * 0.75,
//                     width: double.infinity,
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     decoration: BoxDecoration(
//                       color: Color(0x80CDD1E4),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.width * 0.15,
//                           width: MediaQuery.of(context).size.width * 0.90,
//                           margin: EdgeInsets.symmetric(
//                               vertical:
//                                   MediaQuery.of(context).size.width * 0.04),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () => _selectDate(context),
//                                   child: AbsorbPointer(
//                                     child: Container(
//                                       height: double.infinity,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.white,
//                                       ),
//                                       padding: EdgeInsets.all(17),
//                                       child: Center(
//                                         child: TextField(
//                                           controller: dateController,
//                                           decoration: InputDecoration(
//                                             border: InputBorder.none,
//                                             hintText: "DD/MM/YY",
//                                           ),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () => _selectTime(context),
//                                   child: AbsorbPointer(
//                                     child: Container(
//                                       height: double.infinity,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.white,
//                                       ),
//                                       padding: EdgeInsets.all(17),
//                                       child: Center(
//                                         child: TextField(
//                                           controller: timeController,
//                                           decoration: InputDecoration(
//                                             border: InputBorder.none,
//                                             hintText: "TIME",
//                                           ),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.grey,
//                                             fontSize: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.04,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           margin:
//                               EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                           child: TextField(
//                             controller: purposeController,
//                             style: TextStyle(
//                                 fontSize:
//                                     MediaQuery.of(context).size.width * 0.04,
//                                 color: Colors.black),
//                             maxLines: 4,
//                             textAlign: TextAlign.start,
//                             decoration: InputDecoration(
//                               labelText: 'Purpose...',
//                               labelStyle: TextStyle(
//                                   color: Color.fromARGB(255, 77, 76, 76)),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               contentPadding: EdgeInsets.all(
//                                   MediaQuery.of(context).size.width * 0.04),
//                               alignLabelWithHint: true,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (status == 0) {
//                               fetchAdminDeviceTokens();
//                               signUserIn();
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'You are already out, please update your status at the guard.',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(17),
//                             ),
//                           ),
//                           child: Text(
//                             'SUBMIT',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize:
//                                   MediaQuery.of(context).size.width * 0.04,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//         decoration: BoxDecoration(
//           color: Color(0x80CDD1E4), // Background color
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(35),
//             topRight: Radius.circular(35),
//           ),
//         ),
//         child: BottomNavigationBar(
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/homeicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/inboxicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.05,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/settingsicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.045,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/profileicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//             ),
//           ],
//           currentIndex: currentIndex,
//           selectedItemColor: Colors.black,
//           unselectedItemColor: Colors.black,
//           onTap: onTapped,
//           iconSize: 40,
//           backgroundColor: Colors.transparent, // Remove the background color
//           // Align icons vertically
//           selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
//           unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
//         ),
//       ),
//     );
//   }
// }

// class FullScreenImagePage extends StatelessWidget {
//   final String imageUrl;

//   const FullScreenImagePage({required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Image.network(imageUrl),
//       ),
//     );
//   }
// }

// import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:outpassify/Studentpages/unauthstudent.dart';
import 'package:outpassify/Studentpages/unauthstudent.dart';
import 'package:outpassify/components/Noticationsserver.dart';
import 'package:outpassify/components/export.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:outpassify/Studentpages/Studentpermissions.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentdashboard extends StatefulWidget {
  const Studentdashboard({super.key});

  @override
  State<Studentdashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<Studentdashboard> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  User? user;
  late Future<DocumentSnapshot> userData;
  String? imageUrl; // Variable to store the image URL
  String? name;
  int? status;
  bool iskeyboardvisable = false;
  ///////////////////////////////////////////////////////////////////////////////////////////
  Future<void> checkEmailAndNavigate() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'Students') // Replace 'Students' with your collection name
          .where('Email', isEqualTo: user?.email)
          .get();
      print(
          'cccchhhhhhhhheckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      print(querySnapshot.docs.first.data());
      if (querySnapshot.docs.isEmpty) {
        // Email not found in Students collection
        print(
            "nnnnnooooooooooooooo onnnnnnnnnnnnnnneeeeeeeeeeeeeeeeeeeeeeeeeeee foundddddddddddddddddddddddddddddd");
        GoRouter.of(context).pushNamed(MyAppRouteConstants.unauthstudent);
      }
    } catch (e) {
      print(
          "Erroooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor checking email in Students collection: $e");
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(
        "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
    print(user);
    print(
        "sssssstudentttttttttttttttttttttttttt dashhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    checkEmailAndNavigate();
    if (user != null && user!.email != null) {
      userData = fetchUserData(user!.email!);
    }
    // exportExcel();
    print("calledddddddddddddddddddddddddddddddddddddddddddd");

    _checkForNotifications();
    _deleteOldRequests();
  }
  Stream<int> statusStream() {
  // Replace this with your actual stream that fetches the status.
  // For example, listening to a Firestore document's field.
  return FirebaseFirestore.instance
      .collection('Students')
      .doc(user?.email) // Replace with the actual document ID
      .snapshots()
      .map((snapshot) {
    // Convert the snapshot data to the status integer
    return snapshot.data()?['Status'] ?? 0; // Default status is 0 if null
  });
  }

  Future<void> _deleteOldRequests() async {
    print(
        "I am in the deleteOld request data aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      // Fetch the requests without ordering directly from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Email', isEqualTo: user?.email)
          .get();

      // Sort the documents locally using the 'Requestnumber' field
      List<QueryDocumentSnapshot> sortedDocs = querySnapshot.docs.toList()
        ..sort((a, b) {
          var requestNumberA = a['Requestnumber'];
          var requestNumberB = b['Requestnumber'];
          // Sorting in ascending order
          return requestNumberA.compareTo(requestNumberB);
        });

      // Check if the number of documents exceeds 30
      if (sortedDocs.length > 30) {
        // Calculate how many documents need to be deleted
        int documentsToDelete = sortedDocs.length - 30;

        // Iterate and delete the oldest documents
        for (int i = 0; i < documentsToDelete; i++) {
          var doc = sortedDocs[i];
          if (doc["Approvalstatus"] != 0)
            await sortedDocs[i].reference.delete();
        }
        print(
            'Deleted $documentsToDelete old requestsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssseeeeeeeeeeeeeeeee.');
      } else {
        print(
            'No old requests to deleteqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.');
      }
    } catch (e) {
      print(
          'Error deleting old requestsaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $e');
    }
  }

  Future<String?> wardenphno() async {
    try {
      // Example code - adjust according to your actual implementation
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .where('Role', isEqualTo: 'Admin')
          .get();

      // Check if documents exist
      if (querySnapshot.docs.isEmpty) {
        print("No documents found");
        return null;
      }

      // Safely get the first document's field
      final document = querySnapshot.docs.first.data();
      return document['Contactnumber'].toString();
    } catch (e) {
      print("Error fetching phone number: $e");
      return null;
    }
  }

  Future<DocumentSnapshot> fetchUserData(String email) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .doc(email)
          .get();

      // Update the state with user data
      setState(() {
        name = docSnapshot['Name'] ?? 'Unknown Name';
        status = docSnapshot['Status'] ?? 0;
        imageUrl = docSnapshot['Profilepicture']?.isNotEmpty == true
            ? docSnapshot['Profilepicture']
            : Image.asset('lib/images/Defaultwelcomer.jpg', fit: BoxFit.cover);
      });

      return docSnapshot;
    } catch (e) {
      print("Error fetching user data: $e");
      return Future.error(e);
    }
  }

  bool hasNotifications = false;

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

  Future<int> getNextIndex() async {
    final docRef =
        FirebaseFirestore.instance.collection('system').doc('counters');

    try {
      final docSnapshot = await docRef.get();
      final currentIndex = docSnapshot.exists
          ? (docSnapshot.data()?['requestIndex'] ?? 0) as int
          : 0;

      final newIndex = currentIndex + 1;

      await docRef.set({'requestIndex': newIndex}, SetOptions(merge: true));

      return newIndex;
    } catch (e) {
      print("Error getting or updating index: $e");
      return 0;
    }
  }

  Future<void> updateStudentField(String rollNumber) async {
    try {
      // Query to find the document
      print(
          'sssssssssstttttttttuuuuuuddddddddddnnnnnnnnntttttsssssssssssssssssssssssssss');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: rollNumber)
          .get();

      // Check if any documents were returned
      if (querySnapshot.docs.isEmpty) {
        print(
            'No00000000000000000000000000000000000000000 document found with Rollnumber: $rollNumber');
        return;
      }

      // Assume we want to update the first matching document
      final documentId = querySnapshot.docs.first.id;
      print(
          "dddddddddddddddddddddddddooooooooooooooooooooooooocccccccccccccccccccccccccccccccccccc");
      print(documentId);
      // Update the document
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(documentId)
          .update({'Status': 2});

      print(
          'Document updated successfulllllllllllllllllllllllllllllllllllllllllllllllllllllly');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  void signUserIn() async {
    final date = dateController.text;
    final time = timeController.text;
    final purpose = purposeController.text;
    if (date.isEmpty) {
      _showCustomPopup(
        context,
        'Error',
        'Date cannot be empty!',
        Colors.red,
        Colors.white,
      );
      return;
    }
    if (time.isEmpty) {
      _showCustomPopup(
        context,
        'Error',
        'Time cannot be empty!',
        Colors.red,
        Colors.white,
      );

      return;
    }
    if (purpose.isEmpty) {
      _showCustomPopup(
        context,
        'Error',
        'Purpose cannot be empty!',
        Colors.red,
        Colors.white,
      );
      return;
    }

    try {
      String rollNumber = await fetchUserDetails();
      final index = await getNextIndex();
      final pstd = DateTime.now().toString();
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(index.toString())
          .set({
        'Requestnumber': index,
        'Rollnumber': rollNumber,
        'Email': user?.email,
        'Aacceptdate': null,
        'Approvalstatus': 0,
        'Permissiondate': date,
        'Permissiontime': time,
        'Purpose': purpose,
        'Declinepurpose': null,
        'Studentindate': null,
        'Studentoutdate': null,
        'Studentpermissionsentdate': pstd,
      });
      //for updating status to 2 , to mention that pending and arrest multiple requests
      updateStudentField(rollNumber);
      _showCustomPopup(
        context,
        'Success',
        'Request Sent successfully!',
        Colors.green,
        Colors.white,
      );

      dateController.clear();
      timeController.clear();
      purposeController.clear();
    } catch (e) {
      _showCustomPopup(
        context,
        'Error',
        'Error sending request',
        Colors.red,
        Colors.white,
      );
    }
  }

  Duration duration = Duration(seconds: 2);
  void _showCustomPopup(BuildContext context, String title, String message,
      Color backgroundColor, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Automatically close the dialog after the specified duration
        Future.delayed(duration, () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(); // Close the dialog
          }
        });

        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: textColor,
                size: 40,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
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
              color: textColor,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Future<String> fetchUserDetails() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Email', isEqualTo: user?.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        return docSnapshot['Rollnumber'];
      } else {
        print("User document does not exist in Firestore");
        return "";
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return "";
    }
  }

  Future<void> fetchAdminDeviceTokens() async {
    try {
      if (user?.email != null) {
        final snap = await FirebaseFirestore.instance
            .collection('Students')
            .doc(user!.email!)
            .get();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference adminsCollection = firestore.collection('Admins');
        QuerySnapshot querySnapshot = await adminsCollection.get();

        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          String? deviceToken = document.get('Devicetoken');
          if (deviceToken != null) {
            PushNotificationService.sendNotification(
              deviceToken,
              context,
              snap['Rollnumber'],
              purposeController.text,
            );
          }
        }
      } else {
        throw Exception("User email is null");
      }
    } catch (e) {
      print('Error fetching admin device tokens: $e');
    }
  }

  int currentIndex = 0;

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

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeController.text = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    KeyboardVisibilityController().onChange.listen((isVisible) {
      iskeyboardvisable = isVisible;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontFamily: 'DancingScript',
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                // Await the result of the future
                final phn = await wardenphno();
                print("pppppppppphhhhhhhhhhnnnnnnnnnnnnnnnnnnnnn");
                print(phn);

                // Check if the phone number is not null and is valid
                if (phn != null && phn.isNotEmpty) {
                  final url = 'tel:$phn';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else {
                  print('No phone number available');
                  // Optionally show a message to the user
                }
              },
              icon: Icon(
                Icons.call,
                size: MediaQuery.of(context).size.width * 0.1,
                color: Colors.red,
              ),
            ),
          ],
          leading: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Image.asset(
              'lib/images/logo3.png',
              width: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          backgroundColor: Color(0x80CDD1E4),
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.80,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color(0x80CDD1E4),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(73),
                          ),
                          child: InstaImageViewer(
                            child: GestureDetector(
                              onTap: () {
                                // Open the full-screen image viewer
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImagePage(
                                      imageUrl: imageUrl ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s',
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                  imageUrl ??
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "Hello, ${name ?? 'User'}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "Would you like to request permission?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    height: MediaQuery.of(context).size.width * 0.05,
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.75,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0x80CDD1E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.90,
                          margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(17),
                                      child: Center(
                                        child: TextField(
                                          controller: dateController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "DD/MM/YY",
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectTime(context),
                                  child: AbsorbPointer(
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(17),
                                      child: Center(
                                        child: TextField(
                                          controller: timeController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "TIME",
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold,
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: TextField(
                            controller: purposeController,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: Colors.black),
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              labelText: 'Purpose...',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 77, 76, 76)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              contentPadding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.04),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        StreamBuilder<int>(
  stream: statusStream(),
  builder: (context, snapshot) {
    // Check if the snapshot has data and retrieve the status
    int currentStatus = snapshot.data ?? 0; // Default to 0 if no data

    return ElevatedButton(
      onPressed: () {
        // Modify the button's behavior based on the current status
        if (currentStatus == 2) {
          _showCustomPopup(
            context,
            'Error',
            'You have already sent a permission request. Check with your warden.',
            Colors.red,
            Colors.white,
          );
        } else if (currentStatus == 0) {
          fetchAdminDeviceTokens();
          signUserIn();
        } else {
          _showCustomPopup(
            context,
            'Error',
            'You are already out, please update your status at the guard.',
            Colors.red,
            Colors.white,
          );
        }
        // Clear the text fields
        dateController.clear();
        timeController.clear();
        purposeController.clear();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      child: Text(
        'SUBMIT',
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
    );
  },
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

      bottomNavigationBar: iskeyboardvisable
          ? null
          : Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              decoration: BoxDecoration(
                color: Color(0x80CDD1E4), // Background color
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
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/inboxicon.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/settingsicon.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.045,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/profileicon.png',
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    label: '',
                  ),
                ],
                currentIndex: currentIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black,
                onTap: onTapped,
                iconSize: 40,
                backgroundColor:
                    Colors.transparent, // Remove the background color
                // Align icons vertically
                selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
                unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
              ),
            ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
