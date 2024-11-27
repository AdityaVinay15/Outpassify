import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/components/Noticationsserver.dart';
import 'package:outpassify/components/export.dart';
import 'package:outpassify/components/sheetscolumn.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Adminaccdec extends StatefulWidget {
  final String rollnumber;
  final String date;
  final String permissionTime;
  const Adminaccdec(
      {super.key,
      required this.rollnumber,
      required this.date,
      required this.permissionTime});

  @override
  State<Adminaccdec> createState() => _AdminaccdecState();
}

class _AdminaccdecState extends State<Adminaccdec> {
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
  String? Studentcontactnumber;
  String? Parentcontactnumber;
  String? emails;
  String? permissionsentdate;
  int? status;
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

  Future<void> updatestatus() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('Students').doc(emails);
      await docRef.update({
        "Status": 1,
      });
      print('Field updated successfully.');
    } catch (e) {
      print('Error updating field: $e');
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
              "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
          Studentcontactnumber = doc['Contactnumber'].toString();
          Parentcontactnumber = doc['Parentcontactnumber'].toString();
          print(Parentcontactnumber);
          print(Studentcontactnumber);
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
          .where('Permissiontime', isEqualTo: widget.permissionTime)
          .get();
      print("//////////////////////////");
      print(querySnapshot.docs);

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          print(
              "***********************************************************************************");

          rollNumber = doc['Rollnumber'];
          permissionDate = doc['Permissiondate'];
          permissionTime = doc['Permissiontime'];
          purpose = doc['Purpose'];
          approvalstatus = doc['Approvalstatus'];
          requestnumber = doc['Requestnumber'];
          emails = doc['Email'];
          permissionsentdate = doc['Studentpermissionsentdate'];
          declinepurpose = doc['Declinepurpose'];
          // print(doc['Studentpermissionsentdate']);
          // print(approvalstatus);
          // print(permissionsentdate);
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
          .where('Permissiontime', isEqualTo: widget.permissionTime)
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

  Future<void> getFieldValue(String Status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection("Students").doc(emails).get();
      if (documentSnapshot.exists) {
        var deviceToken = documentSnapshot.get("Devicetoken");
        PushNotificationService.sendNotification(
            deviceToken.toString(), context, Status, _purposeController.text);
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
                color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.08, fontFamily: 'DancingScript'),
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          elevation: 0,
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
                height: MediaQuery.of(context).size.width * 0.2,
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Center(
                    child: Text(
                  "PERMISSION",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Aligns the child at the center horizontally
                                children: [
                                  Text(
                                    name ?? "Loading...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                    InstaImageViewer(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImagePage(
                                     imageUrl: profilepicture.toString() ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s',
                                  ),
                                ),
                              );
                        },
                        child: Container(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: profilepicture != null
                                ? NetworkImage(profilepicture!)
                                : AssetImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_VQvuRo4SyQr1uhvdXwmgJYYX5pj7Yr_qcw&s')
                                    as ImageProvider,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              /////////////////////////////////////////////////////////////
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () async {
                          final url = 'tel:$Studentcontactnumber';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 20, // Adjust size as needed
                              ),
                            ),
                            SizedBox(width: 10), // Space between icon and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Number',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 17, 80, 132),
                                    fontSize: 5, // Small font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        5), // Space between label and number
                                Text(
                                  Studentcontactnumber ?? "Loading...",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () async {
                          final url = 'tel:$Parentcontactnumber';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 20, // Adjust size as needed
                              ),
                            ),
                            SizedBox(width: 10), // Space between icon and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Parent Contact Number',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 17, 80, 132),
                                    fontSize: 5, // Small font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        5), // Space between label and number
                                Text(
                                  Parentcontactnumber ?? "Loading...",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
              if (approvalstatus == 0)
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: TextField(
                      controller: _purposeController, // Assign the controller
                      decoration: InputDecoration(
                        hintText: 'Purpose for declining.. (*Optional)',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              if (approvalstatus == 2)
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      declinepurpose ?? "Loading...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Container(
                height: MediaQuery.of(context).size.width * 0.12,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Row(
                  children: [
                    if (approvalstatus == 0) ...[
                      // Two buttons side by side when approvalstatus is 0
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              updatestatus();
                              getFieldValue("Accepted");
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {
                                updateApprovalStatus(
                                    1); // Update status to accepted
                                buttonState =
                                    "accepted"; // Update the button state
                                declinepurpose =
                                    _purposeController.text; // Capture purpose
                                GoRouter.of(context).pushNamed(
                                    MyAppRouteConstants
                                        .adminpermissionRouteName);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(
                              'ACCEPT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              print(
                                  "Check the dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                              print(rollNumber);
                              print(permissionsentdate);
                              final feedback = {
                                SheetsColumn.Rollnumber: rollNumber,
                                SheetsColumn.Email: emails,
                                SheetsColumn.Purpose: purpose,
                                SheetsColumn.Declinepurpose: declinepurpose,
                                SheetsColumn.Studentpermissionsentdate:
                                    permissionsentdate,
                                SheetsColumn.Aacceptdate: "None",
                                SheetsColumn.Approvalstatus: "Declined",
                                SheetsColumn.Studentoutdate: "None",
                                SheetsColumn.Studentindate: "None"
                              };
                              await FirebaseFirestore.instance
                              .collection('Students')
                              .doc(emails)
                              .update({'Status': 0});
                              await SheetsFlutter.insert([feedback]);
                              getFieldValue("Declined");
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {
                                updateApprovalStatus(
                                    2); // Update status to declined
                                buttonState =
                                    "declined"; // Update the button state
                                declinepurpose =
                                    _purposeController.text; // Capture purpose
                                GoRouter.of(context).pushNamed(
                                    MyAppRouteConstants
                                        .adminpermissionRouteName);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: Text(
                              'DECLINE',
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
              )
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
