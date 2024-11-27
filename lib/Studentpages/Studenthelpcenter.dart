import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/components/newuser.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Studenthelpcenter extends StatefulWidget {
  const Studenthelpcenter({super.key});

  @override
  State<Studenthelpcenter> createState() => _Studenthelpcenter();
}

class _Studenthelpcenter extends State<Studenthelpcenter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int indexs = 0;
  final TextEditingController _feedbackController = TextEditingController();

  User? user;
  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Settings"),
    Text("Profile"),
  ];

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _checkForNotifications();
  }

  // Function to display the Snackbar using the Scaffold's key
  void _showSuccessPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.green[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Feedback Sent!',
              style: TextStyle(
                color: Colors.white,
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
            color: Colors.white,
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Increase padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      child: Text(
        'OK',
        style: TextStyle(
          color: Colors.green[700], // Text color for contrast
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
                  "Feedback",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08),
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10), // Adjust the padding as needed
                  child: TextField(
                    controller: _feedbackController,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.black),
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Enter your text',
                      labelStyle: TextStyle(color: Colors.black),
                      alignLabelWithHint: true, // Align the label with the hint
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide.none, // Remove the default border
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10), // Add padding inside the TextField
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.all(3),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(17)),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button tap
                    /*launchUrlString('mailto:x@gmail.com?''subject:OUTPASSIFY - SUPPORT''body:$_feedbackController'); */
                    sendEmail(
                        "adityauttaravilli@gmail.com",
                        _feedbackController.text.toString(),
                        user!.email.toString() + " Feedback",
                        "");
                    _feedbackController.clear();
                    print(
                        "sssssssnnnnnnnnakkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
 _showSuccessPopup(context, 'Feedback sent successfully!');                    print(
                        'Feedback senttttttttttttttttttttttttttttttttttttttttttttttttttttttttt!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
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
