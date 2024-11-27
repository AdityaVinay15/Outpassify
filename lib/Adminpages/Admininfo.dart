import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Admininfo extends StatefulWidget {
  const Admininfo({super.key});

  @override
  State<Admininfo> createState() => _AdmininfoState();
}

class _AdmininfoState extends State<Admininfo>
    with SingleTickerProviderStateMixin {
  User? user;
  String? photo;
  // late AnimationController _animationController;

  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
        print(
            "I am indddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to Upload Image : $e"),
        ),
      );
    }
  }

  Future<void> _updateField(String fieldName, String newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('Admins')
          .doc(user?.email)
          .update({fieldName: newValue});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to update field: $e"),
        ),
      );
    }
  }

  void _showEditDialog(String fieldName, String currentValue) async {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    final String? newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newValue != null && newValue.isNotEmpty) {
      await _updateField(fieldName, newValue);
      setState(() {
        // Refresh the UI or update the state as needed
      });
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    print(":;;;;;;;;;;;;;;;;;;;;;;;;;;");
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("profilepictures/admins/${user?.email}.png");
      print("I am helloooooooooooooooooooooooooooo");
      await reference.putFile(image).whenComplete(() {
        print(
            "I am rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
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
          .collection('Admins')
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
          .collection('Admins')
          .doc(user?.email)
          .get();

      // Extract the image URL from the document
      setState(() {
        photo = docSnapshot[
            'Profilepicture']; // Replace 'Profilepicture' with your field name
      });
      return docSnapshot;
    } catch (e) {
      print("Error fetching user data: $e");
      return Future.error(e);
    }
  }

  // late Future<Map<String, dynamic>> _userInfoFuture;
  int currentIndex = 0;
  late String user1;
  late Stream<QuerySnapshot> _userInfoStream;

late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // user1 = user!.email!;
      _userInfoStream = FirebaseFirestore.instance
          .collection('Admins')
          .where("Role",isEqualTo: "Admin")
          .snapshots();
    }
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true);
    _checkForNotifications();
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

 

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.adminRouteName);
        break;
      case 1:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.adminpermissionRouteName);
        break;
      case 2:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.adminsettingsRouteName);
        break;
      case 3:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.admininfoRouteName);
        break;
      default:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.adminRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
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
            height: 50,
            child: Image.asset(
              'lib/images/logo3.png',
              width: 500,
            ),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              onPressed: () {
                GoRouter.of(context)
                    .pushNamed(MyAppRouteConstants.adminpermissionRouteName);
              },
              icon: Icon(
                Icons.notifications,
                size: MediaQuery.of(context).size.width * 0.1,
                color: hasNotifications ? Colors.red : Colors.black,
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
          child: StreamBuilder<QuerySnapshot>(
            stream: _userInfoStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.5 +
                            0.5 * _animationController.value, // Blinking effect
                        child: Image.asset(
                          'lib/images/logo3.png', // Replace with your image path
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.2,
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No user info found.'));
              }

              final userInfo = snapshot.data!.docs.first.data() as Map<String, dynamic>;


              return Column(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        backgroundImage: userInfo['Profilepicture'] != ""
                            ? NetworkImage(userInfo['Profilepicture'])
                            : NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png"),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  ),
                  buildInfoContainer(
                      'Name', userInfo['Name']?.toString() ?? 'N/A'),
                  buildInfoContainer('Rollnumber',
                      userInfo['Rollnumber']?.toString() ?? 'N/A'),
                  buildInfoContainer('Yearofjoining',
                      userInfo['Yearofjoining']?.toString() ?? 'N/A'),
                  buildInfoContainer('Contactnumber',
                      userInfo['Contactnumber']?.toString() ?? 'N/A'),
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

  Widget buildInfoContainer(String fieldName, String info) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text widget
            Text(
              info,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            // Edit icon
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
              color: Colors.grey[700],
              onPressed: () {
                // Add your edit action here
                _showEditDialog(fieldName, info);
                print('Edit icon pressed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
