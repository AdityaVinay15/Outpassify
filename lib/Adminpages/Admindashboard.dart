import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:full_screen_image/full_screen_image.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import 'package:outpassify/routes/app_route_constants.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _AdmindashboardState extends State<Admindashboard>
    with SingleTickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  String name='';
  int currentIndex = 0;
  String imageUrl='';
  late AnimationController _animationController;

  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];
  late Future<DocumentSnapshot?> userData;

  @override
  void initState() {
    super.initState();
    if (user != null && user!.email != null) {
      userData = fetchUserData1(user!.email!);
    } else {
      userData = Future.value(null); // Handle null user
    }
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true);
    _checkForNotifications();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Properly dispose of the controller
    super.dispose();
  }

  Future<DocumentSnapshot?> fetchUserData1(String email) async {
  try {
    print("Fetching user data...");
    print(email);
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .doc(email)
        .get();

    if (docSnapshot.exists) {
      print("Document data fetched:");
      print(docSnapshot['Name']);
      var profilePicture = docSnapshot['Profilepicture'];
      if (profilePicture is String) {
        setState(() {
          name = docSnapshot['Name'] ?? 'User';
          imageUrl = profilePicture;
        });
      } else {
        print("Error: Profilepicture is not a String");
        // Handle error or use a default image URL
      }
    }
    return docSnapshot;
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                fontFamily: 'DancingScript'),
          ),
          actions: <Widget>[
            /*IconButton(
    onPressed: () {
      GoRouter.of(context)
          .pushNamed(MyAppRouteConstants.adminattendance); // Replace with your route name
    },
    icon: Image.asset(
      'assets/icons/scanface.png', // Replace with the correct path to your scan logo
      width: MediaQuery.of(context).size.width * 0.12, // Adjust size as needed
      height: MediaQuery.of(context).size.width * 0.12, // Maintain aspect ratio// Apply color filter if needed
    ),
  ),*/
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
        preferredSize: Size.fromHeight(70.0),
      ),
      body: SingleChildScrollView(
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
                    bottomRight: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  FutureBuilder<DocumentSnapshot?>(
                    future: userData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
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
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No user data available.'));
                      }

                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 10),
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
                                        'https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png',
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.white,
                              backgroundImage: imageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(imageUrl)
                                : CachedNetworkImageProvider('https://upload.wikimedia.org/wikipedia/commons/7/72/Default-welcomer.png'
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20), // Padding for the container
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "Hello, ${name ?? 'User'}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              child: Text(
                "Recent Notifications",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              height: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.80,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.80,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color(0x80CDD1E4),
                  borderRadius: BorderRadius.circular(20)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Requests')
                    .where('Approvalstatus', isEqualTo: 0)
                    .snapshots(),
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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No recent notifications.'));
                  }

                  final docs = snapshot.data!.docs;
                  docs.sort((a, b) {
                    int requestNumberA = a['Requestnumber'] ?? 0;
                    int requestNumberB = b['Requestnumber'] ?? 0;
                    return requestNumberB.compareTo(requestNumberA);
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final rollNumber =
                          doc['Rollnumber'] ?? 'Unknown'; // Default value
                      final permissionDate =
                          doc['Permissiondate'] ?? 'Unknown'; // Default value
                      final studentpermissionsentdate =
                          doc['Studentpermissionsentdate'] ?? '';
                      final formattedDate = permissionDate;
                      final truncatedDate =
                          studentpermissionsentdate.length > 16
                              ? studentpermissionsentdate.substring(10, 16)
                              : studentpermissionsentdate;

                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            MyAppRouteConstants.adminpermissionRouteName,
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.20,
                          width: MediaQuery.of(context).size.width * 0.80,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    rollNumber,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Want permission on',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 80, 132),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.001,
                                right: MediaQuery.of(context).size.width * 0.05,
                                child: Text(
                                  truncatedDate,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
