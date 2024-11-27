import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentinfo extends StatefulWidget {
  const Studentinfo({super.key});

  @override
  State<Studentinfo> createState() => _StudentinfoState();
}

class _StudentinfoState extends State<Studentinfo>
    with SingleTickerProviderStateMixin {
  User? user;
  String? photo;
  String? username;
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  late AnimationController _animationController;
  void _showCustomPopup(BuildContext context, String title, String message,
      Color backgroundColor, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Increase padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: backgroundColor.computeLuminance() > 0.5
                        ? Colors.green[700]
                        : Colors.black, // Text color for contrast
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

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        print(
            "uuuuuuuppppppppp caaaaaaaaallllllllleeeeeeeeeeeeeeedddddddddddddddddddddddddddddd");
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      _showCustomPopup(context, 'Error', 'Failed to Upload Image : $e',
          Colors.red, Colors.white);
    }
  }

  Future<void> _handleRefresh() async {
    // You can call methods to fetch data or update the state here
    if (user != null) {
      setState(() {
        _userInfoFuture = fetchUserInfo(user!.email!);
      });
    }
    await _checkForNotifications(); // If you need to check for notifications again
  }

  Stream<String> profilePictureStream() {
    // Replace 'userProfileDoc' with the actual document path for the user's profile
    return FirebaseFirestore.instance
        .collection('Students')
        .doc(user?.email) // Replace with the actual document ID or path
        .snapshots()
        .map((snapshot) {
      // Extract the profile picture URL from the snapshot data
      return snapshot.data()?['Profilepicture'] ?? "";
    });
  }

  Future<void> uploadImageToFirebase(File image) async {
    print(":;;;;;;;;;;;;;;;;;;;;;;;;;;");
    print(photo);
    if (photo == '') {
      try {
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("profilepictures/Students/$username.png");
        await reference.putFile(image).whenComplete(() {
          print(
              "I am rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
          _showCustomPopup(
              context,
              'Success',
              'Profile picture Uploaded Successfully!',
              Colors.green,
              Colors.white);
        });
        imageUrl = await reference.getDownloadURL();
        print(
            "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        print(imageUrl);
        await FirebaseFirestore.instance
            .collection('Students')
            .doc(user?.email)
            .update({'Profilepicture': imageUrl});
        print(imageUrl);
        setState(() {
          imageUrl = imageUrl;
        });
      } catch (e) {
        print("failedddddddddddddddddddddddddddddddddddddd....$e");
        _showCustomPopup(context, 'Error', 'Failed to Upload Image : $e',
            Colors.red, Colors.white);
      }
    } else {
      print("failedddddddddddd222222222222222222222");
      _showCustomPopup(
          context,
          'Error',
          'You have used maximum attempts to change Profile picture!. In case of Proflie picture change, check it with your warden',
          Colors.red,
          Colors.white);
    }
  }

  Future<DocumentSnapshot> fetchUserData(String email) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .doc(user?.email)
          .get();
      print("sssssssssnnnnnnnnnnnnpppppppppshtttttttttttttttttttttttttt");
      print(docSnapshot['Profilepicture']);
      // Extract the image URL from the document
      setState(() {
        photo = docSnapshot['Profilepicture'] ??
            ''; // Replace 'Profilepicture' with your field name
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
    print(
        ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
    username = user?.email;
    print(user?.email);
    if (user != null) {
      _userInfoFuture = fetchUserInfo(user!.email!);
    }
    String e = username.toString();
    fetchUserData(e);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true);
    _checkForNotifications();
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

  bool hasNotifications = false;
  Future<void> _checkForNotifications() async {
    try {
      // Replace 'your_rollnumber' with the actual roll number or other criteria
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

  Future<Map<String, dynamic>> fetchUserInfo(String email) async {
    try {
      print(user?.email);
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Students') // Ensure this matches your collection name
          .doc(user?.email) // Assuming document ID is the email
          .get();
      print("**************************************************************");
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
        child: AppBar(
          scrolledUnderElevation: 0,
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
          backgroundColor: Color(0x80CDD1E4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
        ),
        preferredSize: const Size.fromHeight(70.0),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0x80CDD1E4),
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _userInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    // color: Colors.black.withOpacity(0.5), // Dark overlay
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.5 +
                                0.5 *
                                    _animationController
                                        .value, // Blinking effect
                            child: Image.asset(
                              'lib/images/logo3.png', // Replace with your image path
                              width: screenWidth * 0.2,
                              height: screenHeight * 0.2,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No user info found.'));
              }
      
              final userInfo = snapshot.data!;
      
              return Column(
                children: [
                  StreamBuilder<String>(
                    stream: profilePictureStream(),
                    builder: (context, snapshot) {
                      // Get the URL from the snapshot data
                      String profilePictureUrl = snapshot.data ?? "";
                      print(
                          "PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
                      print(profilePictureUrl);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    if (profilePictureUrl != '') {
                                      _showCustomPopup(
                                          context,
                                          'Error',
                                          'You have used maximum attempts to change Profile picture!. In case of Proflie picture change, check it with your warden',
                                          Colors.red,
                                          Colors.white);
                                    } else {
                                      pickImage();
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.white,
                                    backgroundImage: profilePictureUrl
                                            .isNotEmpty
                                        ? NetworkImage(profilePictureUrl)
                                        : NetworkImage(
                                            "https://firebasestorage.googleapis.com/v0/b/outpassify-78b92.appspot.com/o/Add%20Profile%20Picture.png?alt=media&token=e5cffb93-e644-4cf6-8895-122df1b72c1e"),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Optional: Add text or other widgets here
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      
                  buildInfoContainer(userInfo['Name']?.toString() ?? 'N/A'),
                  buildInfoContainer(
                      userInfo['Rollnumber']?.toString() ?? 'N/A'),
                  buildInfoContainer(userInfo['Year']?.toString() ?? 'N/A'),
                  buildInfoContainer(userInfo['Branch']?.toString() ?? 'N/A'),
                  buildInfoContainer(
                      userInfo['Section']?.toString() ?? 'N/A'),
                  buildInfoContainer(
                      userInfo['Contactnumber']?.toString() ?? 'N/A',
                      label: '*Contact Number'),
                  buildInfoContainer(
                      userInfo['Parentcontactnumber']?.toString() ?? 'N/A',
                      label: '*Parent Contact Number'),
                  // buildInfoContainer(userInfo['Profilepicture']),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
          backgroundColor: Colors.transparent, // Remove the background color
          // Align icons vertically
          selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
          unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
        ),
      ),
    );
  }

  Widget buildInfoContainer(String info, {String? label}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.065,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                info ?? 'N/A',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          if (label != null)
            Align(
              alignment: Alignment.topRight,
              child: Text(
                label,
                style: const TextStyle(
                    color: Color.fromARGB(255, 1, 67, 121), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
