import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guarddesktopresetpassword extends StatefulWidget {
  const Guarddesktopresetpassword({super.key});

  @override
  State<Guarddesktopresetpassword> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Guarddesktopresetpassword> {
  TextEditingController email = TextEditingController();
  Future<void> _checkForNotifications() async {
    try {
      // Replace 'your_rollnumber' with the actual roll number or other criteria
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Email', isEqualTo: email.text)
          .get();
      print(
          "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
      print(email.text);
      print(querySnapshot.docs.isNotEmpty);
      if (querySnapshot.docs.isNotEmpty) {
        print(
            "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
        verifyemail();
        showSnackBar(context);
      } else {
        print(
            "FoundNottttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
            errorshowSnackBar(context);
      }
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(0),
              color: Colors.white,
              height: screenHeight * 0.25, // Adjust height for desktop
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/logo3.png',
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.2, // Adjust height for logo
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'OutPassIfy',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Adjust font size for desktop
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x80CDD1E4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Container(
                  // padding:
                  //     EdgeInsets.all(screenWidth * 0.05), // Adjust padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: Text(
                          "Reset Password",
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Container(
  height: screenHeight * 0.06,
  width: screenWidth * 0.3, // Adjusted width
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: Colors.white),
    color: Colors.white,
  ),
  child: Center(
    child: TextField(
      controller: email,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black,
          size: screenWidth * 0.02,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        hintText: 'Enter Email', // Use hintText instead of labelText
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: screenWidth * 0.01,
        ),
        border: InputBorder.none,
      ),
    ),
  ),
),

                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _checkForNotifications();
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.black,
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(Size(
                                screenWidth * 0.15,
                                screenHeight * 0.08)), // Adjust size
                          ),
                          child: Text(
                            'SEND MAIL',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth *
                                    0.01), // Adjust font size
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    final snackBar = const SnackBar(
      content: Text('Password Reset Email Sent'),
      backgroundColor: Colors.green,
    );

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
    void errorshowSnackBar(BuildContext context) {
    final snackBar = const SnackBar(
      content: Text('Incorrect Email'),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
    );

    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future verifyemail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      print(
          "Sent mainnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnllllllllllllllllllllyyyyyyyyyyy");
      showSnackBar(context);
      GoRouter.of(context).pushNamed(MyAppRouteConstants.authName);
    } catch (e) {
      print(
          "Notttttttttttttttttttttttttttttttttttttttttttttttttttttttttyyyyyyyyyyyffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }
  }
}
