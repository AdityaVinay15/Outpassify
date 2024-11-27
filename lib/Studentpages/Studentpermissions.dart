import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';

const Map<int, Map<String, dynamic>> statusMap = {
  0: {'text': 'Pending', 'color': Colors.yellow},
  1: {'text': 'Accepted', 'color': Colors.green},
  2: {'text': 'Declined', 'color': Colors.red},
};

class Studentpermissions extends StatefulWidget {
  const Studentpermissions({super.key});

  @override
  State<Studentpermissions> createState() => _StudentpermissionsState();
}

class _StudentpermissionsState extends State<Studentpermissions>
    with SingleTickerProviderStateMixin {
  User? user;
  int currentIndex = 0;
  bool isLoading = false; // Add loading state variable
  late AnimationController
      _animationController; // Controller for blinking effect

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true); // Repeats the animation back and forth
    _checkForNotifications();
    _deleteOldRequests();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

Future<void> _deleteOldRequests() async {
  print("I am in the deleteOld request data aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
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
        if(doc["Approvalstatus"]!=0)
        await sortedDocs[i].reference.delete();
      }
      print('Deleted $documentsToDelete old requestsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssseeeeeeeeeeeeeeeee.');
    } else {
      print('No old requests to deleteqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.');
    }
  } catch (e) {
    print('Error deleting old requestsaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $e');
  }
}


  Future<void> _checkForNotifications() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

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
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
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
  
  bool hasNotifications = false;

  Stream<List<Map<String, dynamic>>> getPermissionsStream() {
    return FirebaseFirestore.instance
        .collection('Requests')
        .where('Email', isEqualTo: user?.email)
        .snapshots()
        .map((querySnapshot) {
      List<Map<String, dynamic>> permissions = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Sort the list by Requestnumber (assuming it's an integer)
      permissions.sort((a, b) {
        int requestNumberA = a['Requestnumber'] ?? 0;
        int requestNumberB = b['Requestnumber'] ?? 0;
        return requestNumberB.compareTo(requestNumberA); // Descending order
      });

      return permissions;
    });
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
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.08,
                fontFamily: 'DancingScript'),
          ),
          leading: Container(
            height: screenHeight * 0.07,
            child: Image.asset(
              'lib/images/logo3.png',
              width: screenHeight * 0.3,
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
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0x80CDD1E4),
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: screenWidth * 0.2,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Center(
                      child: Text(
                    "MY PERMISSIONS",
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.08),
                  )),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: getPermissionsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: // Display loader if isLoading is true
                              Container(
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
                        return Center(child: Text('No permissions found.'));
                      } else {
                        final permissions = snapshot.data!;
                        return ListView.builder(
                          itemCount: permissions.length,
                          itemBuilder: (context, index) {
                            final permission = permissions[index];
                            final rollnumber = permission['Rollnumber'];
                            final date = permission['Permissiondate'] ?? 'N/A';
                            final purpose = permission['Purpose'] ?? 'N/A';
                            final time = permission['Permissiontime'] ?? 'N/A';
                            final statusCode =
                                permission['Approvalstatus'] ?? 0;
                            final studentpermissionsentdate=permission['Studentpermissionsentdate'] ?? 'N/A';
                            final statusData = statusMap[statusCode] ??
                                {
                                  'text': 'Unknown',
                                  'color': Colors.grey,
                                };

                            return GestureDetector(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  MyAppRouteConstants.studentreqinfo,
                                  pathParameters: {
                                    'rollnumber': rollnumber.toString(),
                                    'date': date.toString(),
                                    'time': time.toString(),
                                  },
                                );
                              },
                              child: Container(
  height: screenWidth * 0.2,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  child: Stack(
    children: [
      // This is the content you want to keep in the container
      Positioned.fill(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Center(
                child: Text(
                  date,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  purpose.length > 5
                      ? '${purpose.substring(0, 5)}...'
                      : purpose,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  statusData['text'],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: statusData['color'],
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // This positions permissionsentdate at the bottom right corner
      Positioned(
        bottom: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            studentpermissionsentdate.substring(11, 16) +
                                    '   ' +
                                    studentpermissionsentdate
                                        .substring(0, 10)
                                        .split('-')
                                        .reversed
                                        .join('/'),
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.02, // Adjust size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  ),
)

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
        ],
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
}
