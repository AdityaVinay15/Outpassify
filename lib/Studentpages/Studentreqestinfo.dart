import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Studentrequestinfo extends StatefulWidget {
  final String rollnumber;
  final String date;
  final String time;
  const Studentrequestinfo(
      {super.key,
      required this.rollnumber,
      required this.date,
      required this.time});

  @override
  State<Studentrequestinfo> createState() => _StudentrequestinfoState();
}

class _StudentrequestinfoState extends State<Studentrequestinfo> {
  final TextEditingController _purposeController = TextEditingController();
  String declinepurpose = '';
  int indexs = 0;
  String buttonState = "initial"; // initial, accepted, declined
  String? name;
  String? rollNumber;
  String? permissionDate;
  String? permissionTime;
  String? purpose;
  String? profilepicture;
  int? approvalstatus;
  int? requestnumber;
  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];

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

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchnamepic();
    if (approvalstatus == 1) {
      buttonState = "accepted";
    } else if (approvalstatus == 2) {
      buttonState = "declined";
    } else {
      buttonState = "initial";
    }
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

  Future<void> fetchnamepic() async {
    try {
      final namepicshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: widget.rollnumber)
          .get();
      print("//////////////////////////");
      if (namepicshot.docs.isNotEmpty) {
        final doc = namepicshot.docs.first;
        setState(() {
          name = doc['Name'];
          profilepicture = doc['Profilepicture'];
          print(
              "//////////////////////PROFILE PIC FETCHED/////////////////////////");
          print(profilepicture);
        });
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Rollnumber', isEqualTo: widget.rollnumber)
          .where('Permissiondate', isEqualTo: widget.date)
          .where('Permissiontime', isEqualTo: widget.time)
          .get();
      print("//////////////////////////");
      print(querySnapshot.docs);

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          print("*******************************");

          rollNumber = doc['Rollnumber'];
          permissionDate = doc['Permissiondate'];
          permissionTime = doc['Permissiontime'];
          purpose = doc['Purpose'];
          approvalstatus = doc['Approvalstatus'];
          requestnumber = doc['Requestnumber'];
          declinepurpose = doc['Declinepurpose'];
          print(approvalstatus);
        });
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> updateApprovalStatus(int status) async {
    try {
      CollectionReference requests =
          FirebaseFirestore.instance.collection('Requests');
      QuerySnapshot querySnapshot = await requests
          .where('Rollnumber', isEqualTo: rollNumber)
          .where('Permissiondate', isEqualTo: widget.date)
          .where('Permissiontime', isEqualTo: widget.time)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          print("[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]");
          print(status);

          await doc.reference.update({'Approvalstatus': status});
          await doc.reference.update({'Declinepurpose': declinepurpose});
          if (status == 1)
            FirebaseFirestore.instance.collection('Guarddb').doc(rollNumber);
          await FirebaseFirestore.instance
              .collection('Guarddb')
              .doc(rollNumber)
              .set({
            'Rollnumber': rollNumber,
            'Permissiondate': permissionDate,
            'Permissiontime': permissionTime,
            'Requestnumber': requestnumber,
            'Studentindate': "",
            'Studentoutdate': "",
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

  @override
  Widget build(BuildContext context) {
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
    color:  Colors.red ,
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0x80CDD1E4), borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Center(
                    child: Text(
                  "PERMISSION",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                )),
              ),
              Container(
                height: 130,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            //NAME
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Center(
                                child: Center(
                                  child: Text(
                                    name ?? "Loading...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                rollNumber ?? "Loading...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: CircleAvatar(backgroundColor: Colors.grey[700],
                        radius: 60,
                        backgroundImage: profilepicture != null
                            ? NetworkImage(profilepicture!)
                            : AssetImage('assets/images/defaultavatar.jpeg')
                                as ImageProvider,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 45,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(13),
                      child: Center(
                        child: Text(
                          permissionDate ?? "Loading...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(13),
                      child: Center(
                        child: Text(
                          permissionTime ?? "Loading...",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    purpose ?? "Loading...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
  child: declinepurpose != "" 
    ? Container(
        height: MediaQuery.of(context).size.width * 0.20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        child: Text(
          declinepurpose!,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    : Container() // Empty container or alternative widget when `declinepurpose` is null
),
              Container(
                height: MediaQuery.of(context).size.width * 0.12,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  children: [
                    if (approvalstatus == 0) ...[
                      // Single button for pending when approvalstatus is 0
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 209, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(
                              'PENDING',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (approvalstatus == 1) ...[
                      // Single button for accepted when approvalstatus is 1
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(
                              'ACCEPTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (approvalstatus == 2) ...[
                      // Single button for declined when approvalstatus is 2
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(
                              'DECLINED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
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
