import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class abcd extends StatefulWidget {
  const abcd({super.key});

  @override
  State<abcd> createState() => _abcdState();
}

class _abcdState extends State<abcd> {
  int indexs = 0;
  Stream<QuerySnapshot>? _suggestionsStream;
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  var rollNumber;

  var reqnumber;

  Future<void> updatestatus() async {
    try {
      final querySnapshots = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: rollNumber)
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
        print('No document found with Rollnumber: $rollNumber');
      }
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _startListeningForNewRequests();
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

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _suggestionsStream = null;
      });
      return;
    }

    setState(() {
      _suggestionsStream = FirebaseFirestore.instance
          .collection('Guarddb')
          .where('Studentoutdate', isNotEqualTo: "") // Ensure this field is correct
          .snapshots();
    });
  }

  void _searchRollNumber() async {
    rollNumber = _controller.text.trim().toUpperCase();
    if (rollNumber == '') {
      _showSnackbar('Please enter a roll number.', Colors.red);
      return;
    }

    setState(() {
      _isSearching = true;
    });
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(rollNumber);
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Guarddb')
          .where('Rollnumber', isEqualTo: rollNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        print("////////////////////////////////");
        // print("Document data: ${doc.data()}");
        reqnumber = doc.data()['Requestnumber'];
        // print(reqnumber);
        // int re = '$reqnumber';
        updateApprovalStatus(reqnumber);
        _showSnackbar('Roll number found.', Colors.green);
      } else {
        // _showSnackbar('Roll number not found.', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

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

  //to delete in guarddb and update in requests
  Future<void> updateApprovalStatus(int req) async {
    try {
      CollectionReference requests =
          FirebaseFirestore.instance.collection('Requests');
      QuerySnapshot querySnapshot =
          await requests.where('Requestnumber', isEqualTo: req).get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        await doc.reference
            .update({'Studentindate': DateTime.now().toString()});
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference delreq = firestore.collection('Guarddb');

        try {
          await delreq.doc(rollNumber).delete();
          print('Document with ID $rollNumber deleted successfully.');
        } catch (e) {
          print('Error deleting document: $e');
        }
      }
      print('Approvalstatus updated successfully.');
    } catch (e) {
      print('Error updating Approvalstatus: $e');
    }
  }

  void _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0,
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
            onPressed: () {
              GoRouter.of(context)
                  .pushNamed(MyAppRouteConstants.guardinboxRouteName);
            },
            icon: Icon(
              Icons.notifications,
              size: MediaQuery.of(context).size.width *
                  0.1, // Adjust size as needed
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
      body: GestureDetector(
        onTap: () {
          setState(() {
            _suggestionsStream = null;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x80CDD1E4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("In-Status Enquiry",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.black)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.white),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _controller,
                            onChanged: _onTextChanged,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10.0),
                              prefixIcon: Icon(Icons.person,
                                  color: Colors.black, size: 30.0),
                              suffixIcon: Icon(Icons.search,
                                  color: Colors.grey, size: 30.0),
                              labelText: 'Enter Roll Number',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "*Enter in Uppercase only",
                              style: TextStyle(
                                color: Colors.red, // Set the text color to red
                                fontSize: MediaQuery.of(context).size.height *
                                    0.01, // Adjust the font size as needed
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        ElevatedButton(
                          onPressed: () {
                            if (!_isSearching) {
                              updatestatus();
                              _searchRollNumber();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF189C1E),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.05),
                          ),
                          child: Text('PROCEED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              )),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            if (!_isSearching) {
                              _searchRollNumber();
                            }
                            // Handle STUDENT INFO button press
                            print(";;;;;;;;;;;;;;;;;;;;;;;;;");
                            print(rollNumber);
                            // GoRouter.of(context).pushNamed(
                            //     MyAppRouteConstants.guardrollnumber,
                            //     pathParameters: rollNumber);
                            GoRouter.of(context).pushNamed(
                              MyAppRouteConstants.guardrollnumber,
                              pathParameters: {
                                'rollnumber': rollNumber,
                              },
                            );
                            print(
                                "SEntttttttttttttttttttttttttttttttttttttttttttttttttttttt");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF0000),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.05),
                          ),
                          child: Text('STUDENT INFO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              )),
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: () async {
                            // Handle CALL WARDEN button press
                            // final docSnapshot = await FirebaseFirestore.instance
                            //   .collection('Admins')
                            //   .where(user?.email)
                            //   .get();
                            print("pressedddddddddddddddddddddddddddddddd");
                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection("Admins")
                                    .limit(1) // Limit to one document
                                    .get();
                            String phnnum = querySnapshot
                                .docs.first['Contactnumber']
                                .toString();
                            FlutterPhoneDirectCaller.callNumber(phnnum);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5092FF),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.6,
                                MediaQuery.of(context).size.height * 0.05),
                          ),
                          child: Text('CALL WARDEN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              )),
                        ),
                      ],
                    ),
                    if (_suggestionsStream != null)
                      Positioned(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 60),
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _suggestionsStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: Text('No suggestions found.'));
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                final suggestions =
                                    snapshot.data!.docs.map((doc) {
                                  return ListTile(
                                    title: Text(doc['Rollnumber']),
                                    onTap: () {
                                      _controller.text = doc['Rollnumber'];
                                      setState(() {
                                        _suggestionsStream = null;
                                      });
                                    },
                                  );
                                }).toList();

                                return ListView(
                                  children: suggestions,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
}
