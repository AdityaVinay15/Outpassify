import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guardstudentinfo extends StatefulWidget {
  final String rollnumber;

  const Guardstudentinfo({super.key, required this.rollnumber});

  @override
  State<Guardstudentinfo> createState() => _GuardstudentinfoState();
}

class _GuardstudentinfoState extends State<Guardstudentinfo> with SingleTickerProviderStateMixin{
  User? user;
  late Future<Map<String, dynamic>> _userInfoFuture;
  int currentIndex = 0;
  String photo = "";
  String? downloadUrl;
  late StreamSubscription<QuerySnapshot> _subscription;
  bool hasNotifications = false;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _userInfoFuture = fetchUserData(widget.rollnumber);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true);
    _startListeningForNewRequests();
  }

  Future<void> downloadImageUrl(String imagePath) async {
    try {
      // Reference to the Firebase Storage location
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);

      // Get the download URL
      downloadUrl = await ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      // Trigger a rebuild to reflect the image URL
      setState(() {});
    } catch (e) {
      print("Error fetching download URL: $e");
    }
  }

  void _startListeningForNewRequests() {
    _subscription = FirebaseFirestore.instance
        .collection('Guarddb')
        .where('Studentoutdate', isEqualTo: '')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docChanges.any((change) => change.type == DocumentChangeType.added)) {
        setState(() {
          hasNotifications = true;
        });
      }
    });
  }

  Future<Map<String, dynamic>> fetchUserData(String rollnumber) async {
    try {
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: rollnumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        photo = querySnapshot.docs.first['Profilepicture']??'';
        await downloadImageUrl(photo);
        return querySnapshot.docs.first.data();
      } else {
        return Future.error('No user data found');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return Future.error(e);
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
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
                      'STUDENT INFO',
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: SingleChildScrollView(
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: _userInfoFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.5 + 0.5 * _animationController.value, // Blinking effect
                      child: Image.asset(
                        'lib/images/logo3.png', // Replace with your image path
                        width: screenWidth*0.2,
                        height: screenHeight*0.2,
                      ),
                    );
                  },
                ),);
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No user info found.'));
                            }

                            final userInfo = snapshot.data!;

                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
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
                                        radius: 100,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: downloadUrl != null
                                            ? NetworkImage(downloadUrl!)
                                            : const NetworkImage("https://via.placeholder.com/150"),
                                        onBackgroundImageError: (exception, stackTrace) {
                                          // Optionally handle the error or log it
                                          print("Eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerror loading image: $exception");
                                        },
                                      ),
                                    ),
                                  ),

                                ),
                                buildInfoContainer(userInfo['Name']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Rollnumber']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Year']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Branch']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Section']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Contactnumber']?.toString() ?? 'N/A'),
                                buildInfoContainer(userInfo['Parentcontactnumber']?.toString() ?? 'N/A'),
                              ],
                            );
                          },
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
    );
  }

  Widget buildInfoContainer(String info) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(15),
      child: Text(
        info,
        style: const TextStyle(color: Colors.black, fontSize: 18),
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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}









