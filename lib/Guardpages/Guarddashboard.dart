// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:full_screen_image/full_screen_image.dart';
// import 'package:go_router/go_router.dart';
// import 'package:outpassify/routes/app_route_constants.dart';

// class Gaurddashboard extends StatefulWidget {
//   const Gaurddashboard({super.key});

//   @override
//   State<Gaurddashboard> createState() => _GaurddashboardState();
// }

// class _GaurddashboardState extends State<Gaurddashboard> {
//   User? user = FirebaseAuth.instance.currentUser;
//   String? name;
//   String? imageUrl;
//   String? permissionDate;
//   String? permissionTime;
//   String? rollnum;
//   String? profilepicture;
//   List<Widget> widgets = [
//     Text("Home"),
//     Text("Inbox"),
//     Text("Settings"),
//     Text("Profile"),
//   ];
//   int currentIndex = 0;
//   Stream<QuerySnapshot>? _suggestionsStream;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       fetchUserData(user!.email!);
//     }
//     _startListeningForNewRequests();
//   }
//   bool hasNotifications = false;
//   late StreamSubscription<QuerySnapshot> _subscription;
//   void _startListeningForNewRequests() {
//     _subscription = FirebaseFirestore.instance
//         .collection('Guarddb')
//         .where('Studentoutdate',isEqualTo: '')
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docChanges.any((change) => change.type == DocumentChangeType.added)) {
//         setState(() {
//           hasNotifications = true;
//         });
//       }
//     });
//   }
//   final TextEditingController _controller = TextEditingController();
//   bool _isSearching = false;

//   void _onTextChanged(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         _suggestionsStream = null;
//       });
//       return;
//     }

//     setState(() {
//       _suggestionsStream = FirebaseFirestore.instance
//           .collection('Guarddb')
//           // .where('Rollnumber', isGreaterThanOrEqualTo: value)
//           // .where('Rollnumber', isLessThan: value + 'z')
//           .where('Studentoutdate', isEqualTo: "")
//           .snapshots();
//     });
//   }

//   void _searchRollNumber() async {
//     final rollNumber = _controller.text.trim();
//     if (rollNumber.isEmpty) {
//       _showSnackbar('Please enter an ID number.', Colors.red);
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//     });
//     String? rollnumber;
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Guarddb')
//           .where('Rollnumber', isEqualTo: rollNumber.toString())
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         final doc = querySnapshot.docs.first;
//         setState(() {
//           rollnumber = doc['Rollnumber'];
//           rollnum = rollnumber;
//           permissionDate = doc['Permissiondate'];
//           permissionTime = doc['Permissiontime'];
//           //profilepicture = doc['Profilepicture'];
//           print("//////////////////////ROLLNUMBER/////////////////////////");
//           print(rollnumber);
//           updateApprovalStatus('$rollnumber');
//         });

//         _showSnackbar('Permission Granted', Colors.green);
//       } else {
//         _showSnackbar('Roll number not found.', Colors.red);
//       }
//     } catch (e) {
//       _showSnackbar('Error: ${e.toString()}', Colors.red);
//     } finally {
//       setState(() {
//         _isSearching = false;
//       });
//     }
//   }

//   Future<void> updateApprovalStatus(String rollnum) async {
//     try {
//       print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");
//       print(rollnum);
//       print(permissionDate);
//       print(permissionTime);
//       CollectionReference requests =
//           FirebaseFirestore.instance.collection('Requests');
//       QuerySnapshot querySnapshot = await requests
//           .where('Rollnumber', isEqualTo: rollnum)
//           .where('Permissiondate', isEqualTo: permissionDate)
//           .where('Permissiontime', isEqualTo: permissionTime)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//           print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");

//           String t = DateTime.now().toString();
//           await doc.reference.update({'Studentoutdate': t});
//           print(t);
//           await FirebaseFirestore.instance
//               .collection('Guarddb')
//               .doc(rollnum) // Reference the document with the ID `rollNumber`
//               .update({
//             'Studentoutdate': t, // Update the `Studentoutdate` field
//           });
//           await doc.reference
//               .update({'Aacceptdate': DateTime.now().toString()});
//         }
//         print('Approvalstatus updated successfully.');
//       } else {
//         print('No documents found with the specified rollnumber.');
//       }
//     } catch (e) {
//       print('Error updating Approvalstatus: $e');
//     }
//   }

//   void _showSnackbar(String message, Color color) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       backgroundColor: color,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   void onTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.guardRouteName);
//         break;
//       case 1:
//         GoRouter.of(context)
//             .pushNamed(MyAppRouteConstants.guardstatusRouteName);
//         break;
//       case 2:
//         GoRouter.of(context)
//             .pushNamed(MyAppRouteConstants.guardsettingsRouteName);
//         break;
//       case 3:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.guardinfoRouteName);
//         break;
//       default:
//         GoRouter.of(context).pushNamed(MyAppRouteConstants.guardRouteName);
//     }
//   }

//   Future<void> fetchUserData(String email) async {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('Guards')
//           .doc(user?.email)
//           .get();

//       setState(() {
//         name = docSnapshot['Name'];
//         imageUrl = docSnapshot[
//             'Profilepicture']; // Replace 'Profilepicture' with your field name
//       });
//     } catch (e) {
//       print("Error fetching user data: $e");
//       return Future.error(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         child: AppBar(
//           scrolledUnderElevation: 0,
//           centerTitle: true,
//           title: Text(
//             "OutPassIfy",
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: MediaQuery.of(context).size.width * 0.08,
//                 fontFamily: 'DancingScript'),
//           ),
//           actions: <Widget>[
//             IconButton(
//               onPressed: () {
//                 GoRouter.of(context)
//                     .pushNamed(MyAppRouteConstants.guardinboxRouteName);
//               },
//               icon: Icon(
//                 Icons.notifications,
//                 size: MediaQuery.of(context).size.width *
//                     0.1, // Adjust size as needed
//                 color: hasNotifications ? Colors.red : Colors.black,
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
//         preferredSize: Size.fromHeight(70.0),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           // Hide the suggestions box when tapping outside
//           setState(() {
//             _suggestionsStream = null;
//           });
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.width * 0.80,
//                 margin: EdgeInsets.only(bottom: 15),
//                 decoration: BoxDecoration(
//                   color: Color(0x80CDD1E4),
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(50),
//                       bottomRight: Radius.circular(50)),
//                 ),
//                 child: Column(
//                   children: [
//                     FullScreenWidget(
//                       disposeLevel: DisposeLevel.Medium,
//                       child: Container(
//                         child: CircleAvatar(
//                       radius: 75,
//                       backgroundColor: Colors.white,
//                         backgroundImage: imageUrl != ""
//                             ? NetworkImage(imageUrl!)
//                             : NetworkImage("https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png")
//                                 as ImageProvider,
//                     ),
//                         margin:
//                             EdgeInsets.symmetric(vertical: 25, horizontal: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50)),
//                       ),
//                     ),
//                     Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 20), // Padding for the container
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Text(
//                         "Hello, $name",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: MediaQuery.of(context).size.width * 0.08,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.width * 0.85,
//                 width: double.infinity,
//                 margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                 decoration: BoxDecoration(
//                     color: Color(0x80CDD1E4),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width * 0.90,
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Center(
//                               child: Text(
//                             "Search for permission",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: MediaQuery.of(context).size.width * 0.06,
//                                 fontWeight: FontWeight.bold),
//                           ))),
//                       Stack(
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 height: MediaQuery.of(context).size.height * 0.06,
//                                 width: MediaQuery.of(context).size.width * 0.8,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   border: Border.all(color: Colors.white),
//                                   color: Colors.white, // Border color
//                                 ),
//                                 child: TextField(
//                                   controller: _controller,
//                                   onChanged: _onTextChanged,
//                                   decoration: InputDecoration(
//                                     suffixIcon: Icon(Icons.search,
//                                         color: Colors.black, size: 25.0),
//                                     contentPadding: EdgeInsets.only(left: 10.0),
//                                     labelText: 'Id number',
//                                     fillColor: Colors.white,
//                                     labelStyle: TextStyle(
//                                         color: Colors.grey, fontSize: MediaQuery.of(context).size.height * 0.02),
//                                     border: InputBorder
//                                         .none, // Remove the default border
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               "*Enter in Uppercase only",
//                               style: TextStyle(
//                                 color: Colors.red, // Set the text color to red
//                                 fontSize: MediaQuery.of(context).size.height * 0.01, // Adjust the font size as needed
//                               ),
//                             ),
//                           ),
//                         ),
//                                // Add some spacing between the search box and the buttons
//                               Container(
//                                 width: MediaQuery.of(context).size.height * 0.2,
//                                 height: MediaQuery.of(context).size.height * 0.06,
//                                 margin: EdgeInsets.only(top: 20),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(17)),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (!_isSearching) {
//                                       _searchRollNumber();
//                                     }
//                                     print(";;;;;;;;;;;;;;;;");
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(17),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'Proceed',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: MediaQuery.of(context).size.height * 0.02,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.height * 0.2,
//                                 height: MediaQuery.of(context).size.height * 0.06,
//                                 margin: EdgeInsets.only(top: 20),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(17)),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     GoRouter.of(context).pushNamed(
//                                         MyAppRouteConstants
//                                             .guardinboxRouteName);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Color.fromARGB(123, 255, 153, 0),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(17),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'Inbox',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: MediaQuery.of(context).size.height * 0.02,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           if (_suggestionsStream != null)
//                             Positioned(
//                               child: Center(
//                                 child: Container(
//                                   margin: EdgeInsets.only(top: 60),
//                                   color: Colors.white,
//                                   height: MediaQuery.of(context).size.height * 0.1,
//                                   width: MediaQuery.of(context).size.width * 0.8,
//                                   child: StreamBuilder<QuerySnapshot>(
//                                     stream: _suggestionsStream,
//                                     builder: (context, snapshot) {
//                                       if (!snapshot.hasData) return Container();
//                                       final suggestions =
//                                           snapshot.data!.docs.map((doc) {
//                                         return ListTile(
//                                           title: Text(doc['Rollnumber']),
//                                           onTap: () {
//                                             _controller.text = doc['Rollnumber'];
//                                             setState(() {
//                                               _suggestionsStream = null;
//                                             });
//                                           },
//                                         );
//                                       }).toList();

//                                       return ListView(
//                                         children: suggestions,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
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
//       child: BottomNavigationBar(
//         elevation: 0,
//         type:BottomNavigationBarType.fixed,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             // backgroundColor: Color(0x80CDD1E4),
//             icon: Image.asset(
//                 'assets/icons/homeicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//                 'assets/icons/inboxicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.05,
//               ),
//               label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//                 'assets/icons/settingsicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.045,
//               ),
//               label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//                 'assets/icons/profileicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//           ),
//         ],
//         currentIndex: currentIndex,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black,
//         onTap: onTapped,
//         iconSize: 40,
//         backgroundColor: Colors.transparent, // Remove the background color
//           selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
//           unselectedLabelStyle: TextStyle(fontSize: 0),
//       ),
//     )
//     );
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/Guardpages/Guardstudentinfo.dart';
import 'package:outpassify/components/export.dart';
import 'package:outpassify/components/sheetscolumn.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Gaurddashboard extends StatefulWidget {
  const Gaurddashboard({super.key});

  @override
  State<Gaurddashboard> createState() => _GaurddashboardState();
}

class _GaurddashboardState extends State<Gaurddashboard> {
  User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? imageUrl;
  String? permissionDate;
  String? permissionTime;
  String? rollnum;
  String? profilepicture;
  String? acceptdate;
  String? purpose;
  int? approvalstatus;
  String? emails;
  String? permissionsentdate;
  String? studentoutdate;
  bool? vals;
  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];
  int currentIndex = 0;
  Timer? _debounce;
  final TextEditingController _scannerController = TextEditingController();
  final TextEditingController rollnumbercontroller = TextEditingController();
  final FocusNode _scannerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserData(user!.email!);
    }
    print("//////////////////////////////");

    // _scannerFocusNode.requestFocus();
    getfocus();
  }

  @override
  void getfocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scannerFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scannerController.dispose();
    super.dispose();
  }

  void _showCustomSnackbar(BuildContext context, String message, Color color) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
            minWidth: 300.0, // Minimum width to maintain readability
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            minHeight: 200.0, // Minimum height to fit content properly
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(height: 8.0),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // Insert the OverlayEntry into the Overlay
  overlay.insert(overlayEntry);

  // Automatically remove the snackbar after a delay
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}


  void roll() {
    _scannerFocusNode.requestFocus();
  }

  void _onBarcodeChanged(String barcode) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (barcode.isNotEmpty) {
        _fetchData(barcode);
        _scannerController.clear(); // Clear the controller after processing
        _scannerFocusNode.requestFocus();
      }
    });
  }

  Future<void> _fetchData(String barcode) async {
    // mainbarcode = barcode;
    print("//////////////////////////////////////////////////////");
    print('Scanned barcode: $barcode');
    // Implement your data fetching logic here
    _searchRollNumber(barcode);
  }

  bool _isSearching = false;
  void _searchRollNumber(String rollNumber) async {
    if (rollNumber.isEmpty) {
      // _showSnackbar('Please enter an ID number.', Colors.red);
      _showCustomSnackbar(context, 'Please enter an ID number.', Colors.red);

      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Guarddb')
          .where('Rollnumber', isEqualTo: rollNumber)
          .get();
      if (querySnapshot.docs.first['Studentoutdate'] != "") {
        final doc = querySnapshot.docs.first;
        setState(() {
          rollnum = doc['Rollnumber'];
          permissionDate = doc['Permissiondate'];
          permissionTime = doc['Permissiontime'];

          studentoutdate = doc['Studentoutdate'];
          updateApprovalStatusforIn(rollnum!);
        });
        // _showSnackbar('Permission Granted', Colors.green);
         _showCustomSnackbar(context, 'Rollnumber found,Permission Granted', Colors.green);
      } else if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          rollnum = doc['Rollnumber'];
          permissionDate = doc['Permissiondate'];
          permissionTime = doc['Permissiontime'];
          updateApprovalStatusforOut(rollnum!);
        });

        // _showSnackbar('Permission Granted', Colors.green);
         _showCustomSnackbar(context, 'Rollnumber found,Permission Granted', Colors.green);

      } else {
        // _showSnackbar('Roll number not found.', Colors.red);
        _showCustomSnackbar(context, 'Roll number not found.', Colors.red);
      }
    } catch (e) {
      // _showSnackbar('Error: ${e.toString()}', Colors.red);
      _showCustomSnackbar(context, 'ERROR ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // bool _isSearching = false;
  // void _searchRollNumber() async {
  //   final rollNumber = _scannerController.text.trim();
  //   if (rollNumber.isEmpty) {
  //     _showSnackbar('Please enter an ID number.', Colors.red);
  //     return;
  //   }

  //   setState(() {
  //     _isSearching = true;
  //   });
  //   String? rollnumber;
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('Guarddb')
  //         .where('Rollnumber', isEqualTo: rollNumber.toString())
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       final doc = querySnapshot.docs.first;
  //       setState(() {
  //         rollnumber = doc['Rollnumber'];
  //         rollnum = rollnumber;
  //         permissionDate = doc['Permissiondate'];
  //         permissionTime = doc['Permissiontime'];
  //         //profilepicture = doc['Profilepicture'];
  //         print("//////////////////////ROLLNUMBER/////////////////////////");
  //         print(rollnumber);
  //         updateApprovalStatus('$rollnumber');
  //       });

  //       _showSnackbar('Permission Granted', Colors.green);
  //     } else {
  //       _showSnackbar('Roll number not found.', Colors.red);
  //     }
  //   } catch (e) {
  //     _showSnackbar('Error: ${e.toString()}', Colors.red);
  //   } finally {
  //     setState(() {
  //       _isSearching = false;
  //     });
  //   }
  // }
  bool _isInputFieldActive = false;

  void _activateInputField() {
    setState(() {
      _isInputFieldActive = true;
    });
  }

  Future<void> updateApprovalStatusforOut(String rollnum) async {
    try {
      print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");
      print(rollnum);
      print(permissionDate);
      print(permissionTime);
      CollectionReference requests =
          FirebaseFirestore.instance.collection('Requests');
      QuerySnapshot querySnapshot = await requests
          .where('Rollnumber', isEqualTo: rollnum)
          .where('Permissiondate', isEqualTo: permissionDate)
          .where('Permissiontime', isEqualTo: permissionTime)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]");

          String t = DateTime.now().toString();
          await doc.reference.update({'Studentoutdate': t});
          print(t);
          await FirebaseFirestore.instance
              .collection('Guarddb')
              .doc(rollnum) // Reference the document with the ID `rollNumber`
              .update({
            'Studentoutdate': t, // Update the `Studentoutdate` field
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

  Future<void> updateApprovalStatusforIn(String rollnum) async {
    try {
      print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");
      print(rollnum);
      print(permissionDate);
      print(permissionTime);
      CollectionReference requests =
          FirebaseFirestore.instance.collection('Requests');
      QuerySnapshot querySnapshot = await requests
          .where('Rollnumber', isEqualTo: rollnum)
          .where('Permissiondate', isEqualTo: permissionDate)
          .where('Permissiontime', isEqualTo: permissionTime)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          print(
              "[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]22222222222222222222222222222");

          String t = DateTime.now().toString();
          await doc.reference.update({'Studentindate': t});
          print(t);
          await FirebaseFirestore.instance
              .collection('Guarddb')
              .doc(rollnum) // Reference the document with the ID `rollNumber`
              .update({
            'Studentindate': t, // Update the `Studentoutdate` field
          });
          updatestatus();
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          CollectionReference delreq = firestore.collection('Guarddb');

          try {
            CollectionReference requests =
                FirebaseFirestore.instance.collection('Requests');
            QuerySnapshot querySnapshot = await requests
                .where('Rollnumber', isEqualTo: rollnum)
                .where('Permissiondate', isEqualTo: permissionDate)
                .where('Permissiontime', isEqualTo: permissionTime)
                .get();
            //for updating in excel to stroe in variables
      // approvalstatus = querySnapshot.docs.first['Approvalstatus'];
      emails = querySnapshot.docs.first['Email'];
      purpose = querySnapshot.docs.first['Purpose'];
      permissionDate = querySnapshot.docs.first['Studentpermissionsentdate'];
      acceptdate = querySnapshot.docs.first['Aacceptdate'];
      print(
          "#######################################**************************************************#############");
      print(emails);
      print(purpose);
      print(permissionDate);
      print(acceptdate);
            final feedback = {
              SheetsColumn.Rollnumber: rollnum,
              SheetsColumn.Email: emails,
              SheetsColumn.Purpose: purpose,
              SheetsColumn.Declinepurpose: "None",
              SheetsColumn.Studentpermissionsentdate: permissionDate,
              SheetsColumn.Aacceptdate: acceptdate,
              SheetsColumn.Approvalstatus: "Approved",
              SheetsColumn.Studentoutdate: studentoutdate,
              SheetsColumn.Studentindate: t,
            };
            await SheetsFlutter.insert([feedback]);
            await delreq.doc(rollnum).delete();
            print('Document with ID $rollnum deleted successfully.');
          } catch (e) {
            print('Error deleting document: $e');
          }
        }
        print('Approvalstatus updated successfully.');
      } else {
        print('No documents found with the specified rollnumber.');
      }
    } catch (e) {
      print('Error updating Approvalstatus: $e');
    }
  }

  Future<void> updatestatus() async {
    try {
      final querySnapshots = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: rollnum)
          .get();

      if (querySnapshots.docs.isNotEmpty) {
        final docRef = querySnapshots.docs.first.reference;
        await docRef.update({
          "Status": 0,
        });
        print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        print('Field updated successfully.');
      } else {
        print("oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
        print('No document found with Rollnumber: $rollnum');
      }
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  void _studentfetchData(String barcode) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: barcode)
          .get();

      if (query.docs.isNotEmpty) {
        final ref = query.docs.first;
        print(
            "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
        setState(() {
          print(ref['Rollnumber']);
          print(ref['Permissiondate']);
          print(ref['Permissiontime']);
        });
      }
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  void _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  void _handleSubmit() {
    _scannerController.clear();
    _scannerFocusNode.requestFocus();
  }

  Future<void> fetchUserData(String email) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Guards')
          .doc(user?.email)
          .get();

      setState(() {
        name = docSnapshot['Name'];
        imageUrl = docSnapshot[
            'Profilepicture']; // Replace 'Profilepicture' with your field name
      });
    } catch (e) {
      print("Error fetching user data: $e");
      return Future.error(e);
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
          // Left Sidebar
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
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/homeicon.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () => onTapped(0),
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/inboxicon.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () => onTapped(1),
                    ),
                    Text(
                      "Inbox",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/settingsicon.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () => onTapped(2),
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/profileicon.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () => onTapped(3),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Central Container
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      color: Color(0x80CDD1E4),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      children: [
                        // Heading
                        Text(
                          'SCAN BARCODE',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),

                        // Logo
                        Container(
                          child: Image.asset(
                            'lib/images/barcodelogo.png',
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Search Box
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.1,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _scannerController,
                                  focusNode: _scannerFocusNode,
                                  enabled: true,
                                  onChanged: (String barcode) {
                                    if (barcode.isNotEmpty &&
                                        barcode.length >= 10) {
                                      _fetchData(barcode.toUpperCase());
                                      _scannerController
                                          .clear(); // Clear the controller after processing
                                      getfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Enter or Scan Roll Number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  getfocus();
                                },
                                child: Text('SCAN'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Sidebar
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
            decoration: BoxDecoration(
              color: Color(0x80CDD1E4),
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    // Icon Button
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/studentinfo.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      "Student Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    SizedBox(height: 20), // Space between text and TextField
                    // TextField
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.6, // Adjust width as needed

                      child: TextField(
                        controller: rollnumbercontroller,
                        decoration: InputDecoration(
                          labelText: 'Enter Rollnumber',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            10), // Space between TextField and Submit button
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle submit action
                        // Guardstudentinfo();
                        String rollNumber = rollnumbercontroller.text.toUpperCase().trim();
                        if (rollNumber.isNotEmpty) {
                          GoRouter.of(context).pushNamed(
                            MyAppRouteConstants.guardrollnumber,
                            pathParameters: {
                              'rollnumber': rollNumber,
                            },
                          );
                          print('Submitted');
                        } else {
                          print('Roll number is empty');
                        }
                        print('Submitted');
                      },
                      child: Text('SUBMIT'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Icon Button
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/callwarden.png',
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      onPressed: () {},
                    ),
                    // Call Warden Text
                    Text(
                      "Call Warden",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    SizedBox(height: 20), // Space between text and container
                    // Container to display phone number
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Admins')
                            .doc('admin@gmail.com')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Text('No data found');
                          } else {
                            int phoneNumber = snapshot.data!['Contactnumber'] ??
                                'No phone number available';
                            return Text(
                              phoneNumber.toString(),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
