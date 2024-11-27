import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

const Map<int, Map<String, dynamic>> statusMap = {
  0: {'text': 'New', 'color': Colors.yellow},
  1: {'text': 'Accepted', 'color': Colors.green},
  2: {'text': 'Declined', 'color': Colors.red},
};

class Admininbox extends StatefulWidget {
  const Admininbox({super.key});

  @override
  State<Admininbox> createState() => _AdmininboxState();
}

class _AdmininboxState extends State<Admininbox>
    with SingleTickerProviderStateMixin {
  User? user;
  int currentIndex = 0;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true);
    _checkForNotifications();
    _deleteOldRequests();
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
          if(doc["Approvalstatus"]!=0)
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
            height: 50,
            child: Image.asset(
              'lib/images/logo3.png',
              width: 500,
            ),
          ),
          actions: <Widget>[
            // IconButton(
            //   onPressed: () {
            //     GoRouter.of(context)
            //         .pushNamed(MyAppRouteConstants.adminattendance); // Replace with your route name
            //   },
            //   icon: Image.asset(
            //     'assets/icons/scanface.png', // Replace with the correct path to your scan logo
            //     width: MediaQuery.of(context).size.width * 0.12, // Adjust size as needed
            //     height: MediaQuery.of(context).size.width * 0.12, // Maintain aspect ratio
            //   ),
            // ),
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
        preferredSize: Size.fromHeight(70.0),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0x80CDD1E4), borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Center(
                  child: Text(
                "INBOX",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.08),
              )),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Requests')
                    .snapshots(),
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
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No permissions found.'));
                  } else {
                    final permissions = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'Rollnumber': data['Rollnumber'] ?? 'N/A',
                        'Permissiondate': data['Permissiondate'] ?? 'N/A',
                        'Approvalstatus': data['Approvalstatus'] ?? 0,
                        'Permissiontime': data['Permissiontime'] ?? '',
                        'Requestnumber': data['Requestnumber'] ?? 0,
                        'Purpose': data['Purpose'] ?? 'N/A',
                        'Studentpermissionsentdate':
                            data['Studentpermissionsentdate'] ?? "",
                      };
                    }).toList();

                    permissions.sort((a, b) {
                      int requestNumberA = a['Requestnumber'] ?? 0;
                      int requestNumberB = b['Requestnumber'] ?? 0;
                      return requestNumberB
                          .compareTo(requestNumberA); // Descending order
                    });

                    return ListView.builder(
                      itemCount: permissions.length,
                      itemBuilder: (context, index) {
                        final permission = permissions[index];
                        final rollnumber = permission['Rollnumber'];
                        final date = permission['Permissiondate'];
                        final statusCode = permission['Approvalstatus'];
                        final time = permission['Permissiontime'];
                        final statusData = statusMap[statusCode] ??
                            {
                              'text': 'Unknown',
                              'color': Colors.grey,
                            };
                        final studentpermissionsentdate =
                            permission['Studentpermissionsentdate'];

                        // Capture the current time as notification received time

                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).pushNamed(
                              MyAppRouteConstants.adminaccdecRouteName,
                              pathParameters: {
                                'rollnumber': rollnumber.toString(),
                                'date': date.toString(),
                                'time': time.toString(),
                              },
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          rollnumber,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          date,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
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
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 10,
                                  child: Text(
                                    studentpermissionsentdate.substring(11, 16) +
                                    '   ' +
                                    studentpermissionsentdate
                                        .substring(0, 10)
                                        .split('-')
                                        .reversed
                                        .join('/'),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
