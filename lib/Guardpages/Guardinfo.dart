import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Gaurdinfo extends StatefulWidget {
  const Gaurdinfo({super.key});

  @override
  State<Gaurdinfo> createState() => _GaurdinfoState();
}

class _GaurdinfoState extends State<Gaurdinfo> {
  User? user;
  String? photo;
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  Future<void> pickImage() async {
  try {
    // Open file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      // Get the selected file
      File file = File(result.files.single.path!);

      // Upload the image to Firebase
      await uploadImageToFirebase(file);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("Failed to Upload Image: $e"),
      ),
    );
  }
}


  Future<void> uploadImageToFirebase(File image) async {
    print(":;;;;;;;;;;;;;;;;;;;;;;;;;;");
    try {
      var email = user?.email;
      Reference reference = FirebaseStorage.instance.ref().child(
          "profilepictures/Guards/$email/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Upload Successfull!!"),
          ),
        );
      });
      imageUrl = await reference.getDownloadURL();
      print(
          "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
      await FirebaseFirestore.instance
          .collection('Guards')
          .doc(user?.email)
          .update({'Profilepicture': imageUrl});
      print(imageUrl);
      setState(() {
        imageUrl = imageUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Upload Image : $e"),
        ),
      );
    }
  }

  Future<DocumentSnapshot> fetchUserData(String email) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Guards')
          .doc(user?.email)
          .get();

      // Extract the image URL from the document
      setState(() {
        photo = docSnapshot[
            'Profilepicture']; // Replace 'Profilepicture' with your field name
        print("////////////////////////////");
      });

      return docSnapshot;
    } catch (e) {
      print("Error fetching user data: $e");
      return Future.error(e);
    }
  }

  late Future<Map<String, dynamic>> _userInfoFuture;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userInfoFuture = fetchUserInfo(user!.email!);
    }
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

  Future<Map<String, dynamic>> fetchUserInfo(String email) async {
    try {
      print(user?.email);
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Guards')
          .doc(user?.email)
          .get();
      print(docSnapshot.data());
      return docSnapshot.data() ?? {};
    } catch (e) {
      print("Error fetching user info: $e");
      return {};
    }
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
  //       preferredSize: const Size.fromHeight(70.0),
  //     ),
  //     body: Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           color: const Color(0x80CDD1E4),
  //           borderRadius: BorderRadius.circular(20)),
  //       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //       child: SingleChildScrollView(
  //         child: FutureBuilder<Map<String, dynamic>>(
  //           future: _userInfoFuture,
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(child: CircularProgressIndicator());
  //             } else if (snapshot.hasError) {
  //               return Center(child: Text('Error: ${snapshot.error}'));
  //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //               return const Center(child: Text('No user info found.'));
  //             }

  //             final userInfo = snapshot.data!;

  //             return Column(
  //               children: [
  //                 Container(
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       pickImage();
  //                     },
  //                     child: CircleAvatar(
  //                       radius: 100,
  //                       backgroundColor: Colors.white,
  //                       backgroundImage: userInfo['Profilepicture']!=""? NetworkImage(userInfo['Profilepicture']):NetworkImage("https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png"),
  //                     ),
  //                   ),
  //                   margin: const EdgeInsets.symmetric(
  //                       vertical: 25, horizontal: 10),
  //                   decoration:
  //                       BoxDecoration(borderRadius: BorderRadius.circular(50)),
  //                 ),
  //                 buildInfoContainer(userInfo['Name']?.toString() ?? 'N/A'),
  //                 buildInfoContainer(
  //                     userInfo['Rollnumber']?.toString() ?? 'N/A'),
  //                 buildInfoContainer(
  //                     userInfo['Yearofjoining']?.toString() ?? 'N/A'),
  //                 buildInfoContainer(
  //                     userInfo['Contactnumber']?.toString() ?? 'N/A'),
  //                 // buildInfoContainer(userInfo['Profilepicture']),
  //               ],
  //             );
  //           },
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

  // Widget buildInfoContainer(String info) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.065,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(20)),
  //     margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //     padding: const EdgeInsets.all(15),
  //     child: Text(
  //       info,
  //       style: const TextStyle(color: Colors.black, fontSize: 18),
  //     ),
  //   );
  // }
// ############################################################################################################################3
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
          'PROFILE',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: 20),
      Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _userInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No user info found.'));
              }

              final userInfo = snapshot.data!;

              return Column(
                children: [
                  /*Container(
                    child:
                    CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.5,
                    backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHz6erp12t0beMvgCcr-1G9q2I5hWL7mPw0Q&s"),
                  ), /*GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: userInfo['Profilepicture'] != "" 
                            ? NetworkImage(userInfo['Profilepicture']) 
                            : NetworkImage("https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png"),
                      ),
                    ),*/
                    margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  ),*/
                  Container(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey,
                          backgroundImage: userInfo['Profilepicture'] != null
                              ? NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHz6erp12t0beMvgCcr-1G9q2I5hWL7mPw0Q&s")
                              : null,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                  buildInfoContainer(userInfo['Name']?.toString() ?? 'N/A'),
                  buildInfoContainer(userInfo['Rollnumber']?.toString() ?? 'N/A'),
                  buildInfoContainer(userInfo['Yearofjoining']?.toString() ?? 'N/A'),
                  buildInfoContainer(userInfo['Contactnumber']?.toString() ?? 'N/A'),
                ],
              );
            },
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
Widget buildInfoContainer(String info) {
    return Container(
       height: 70,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        
      ),
      child: Text(
        info,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
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
