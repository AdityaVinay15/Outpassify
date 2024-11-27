// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:outpassify/routes/app_route_constants.dart';

// class Resetpass extends StatefulWidget {
//   const Resetpass({super.key});

//   @override
//   State<Resetpass> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<Resetpass> with SingleTickerProviderStateMixin {
//   TextEditingController email = TextEditingController();
//   bool _isLoading = false; // State variable for loading indicator
//   late AnimationController _animationController; // Controller for blinking effect

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1), // Duration of one blink cycle
//     )..repeat(reverse: true); // Repeats the animation back and forth
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     email.dispose();
//     super.dispose();
//   }

//   Future<void> _checkForNotifications() async {
//     setState(() {
//       _isLoading = true; // Show loader when fetching data
//     });

//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Students')
//           .where('Email', isEqualTo: email.text)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         verifyemail();
//         showSnackBar(context);
//       } else {
//         print("No document found for your user mailllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
//       }
//     } catch (e) {
//       print('Error fetching notifications: $e');
//       // Handle errors if necessary
//     } finally {
//       setState(() {
//         _isLoading = false; // Hide loader after operation is complete
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Column(
//               children: [
//                 Container(
//                   color: Colors.white,
//                   height: screenHeight * 0.25,
//                   width: double.infinity,
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         'lib/images/logo3.png',
//                         width: screenWidth * 0.35,
//                         height: screenHeight * 0.25,
//                         fit: BoxFit.contain,
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             'OutPassIfy',
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.1,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Color(0x80CDD1E4),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(50.0),
//                         topRight: Radius.circular(50.0),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(screenWidth * 0.05),
//                       child: SingleChildScrollView(
//                         child: Container(
//                           padding: EdgeInsets.all(screenWidth * 0.05),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: screenHeight * 0.04),
//                               Text(
//                                 "Reset Password",
//                                 style: TextStyle(fontSize: screenWidth * 0.1),
//                               ),
//                               SizedBox(height: screenHeight * 0.03),
//                               Container(
//                                 height: screenHeight * 0.07,
//                                 width: screenWidth * 0.8,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   border: Border.all(color: Colors.white),
//                                   color: Colors.white,
//                                 ),
//                                 child: TextField(
//                                   controller: email,
//                                   decoration: InputDecoration(
//                                     prefixIcon: Icon(
//                                       Icons.person,
//                                       color: Colors.black,
//                                       size: screenWidth * 0.07,
//                                     ),
//                                     contentPadding: EdgeInsets.only(left: 10.0),
//                                     labelText: 'Enter Email',
//                                     fillColor: Colors.white,
//                                     labelStyle: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: screenWidth * 0.04,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: screenHeight * 0.05),
//                               Center(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     _checkForNotifications();
//                                   },
//                                   style: ButtonStyle(
//                                     shape: WidgetStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                     ),
//                                     backgroundColor:
//                                         WidgetStateProperty.all<Color>(
//                                       Colors.black,
//                                     ),
//                                     minimumSize: WidgetStateProperty.all<Size>(
//                                       Size(screenWidth * 0.5, screenHeight * 0.06),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'SEND MAIL',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: screenWidth * 0.045,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5), // Dark overlay
//               child: Center(
//                 child: AnimatedBuilder(
//                   animation: _animationController,
//                   builder: (context, child) {
//                     return Opacity(
//                       opacity: 0.5 + 0.5 * _animationController.value, // Blinking effect
//                       child: Image.asset(
//                         'lib/images/logo3.png', // Replace with your image path
//                         width: screenWidth * 0.3,
//                         height: screenWidth * 0.3,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void showSnackBar(BuildContext context) {
//     final snackBar = const SnackBar(
//       content: Text('Password Reset Email Sent'),
//       backgroundColor: Colors.green,
//     );

//     // Display the SnackBar
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   Future verifyemail() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()),
//     );
//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: email.text.trim());
//       showSnackBar(context);
//       GoRouter.of(context).pushNamed(MyAppRouteConstants.authName);
//     } catch (e) {
//       print('Error sending email: $e');
//       showSnackBar(context);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'dart:math';

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Resetpass>
    with SingleTickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  bool _isLoading = false; // State variable for loading indicator
  late AnimationController
      _animationController; // Controller for blinking effect
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true); // Repeats the animation back and forth
  }

  @override
  void dispose() {
    _animationController.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> _checkForNotifications() async {
    setState(() {
      _isLoading = true; // Show loader when fetching data
    });
    bool sentornot = false;
    try {
      const String chars =
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
      final Random rnd = Random();
      String password =
          List.generate(6, (index) => chars[rnd.nextInt(chars.length)]).join();
      // Send password reset email
      final studentsCollection = await FirebaseFirestore.instance
          .collection('Students')
          .where('Email', isEqualTo: email.text)
          .get();
      if (studentsCollection.docs.isNotEmpty) {
        // If documents are found, print the first one
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password,
        );
        await FirebaseAuth.instance.signOut();
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        // _animationController.dispose;
        _isLoading = false;
        _showCustomPopup(
          context,
          'Success',
          'Password reset email sent successfully to email.',
          Colors.green,
          Colors.white,
        );
      } else {
        // If no documents are found
        _isLoading = false;
        _showCustomPopup(
          context,
          'Error',
          'No user found with this email address.',
          Colors.red,
          Colors.white,
        );
        print('No student found with email: $email');
      }

      // Show success message
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'email-already-in-use') {
        print(
            "eeeeeeeeeeeeeeeemmmmmmmmmmmmmmmmmmmmmmmmaaaaaaaaaaaail alrdyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        _isLoading = false;
        _showCustomPopup(
          context,
          'Success',
          'Password reset email sent successfully to email.',
          Colors.green,
          Colors.white,
        );
        print(
            'The email address is already in use by another accounttttttttttttttttttttttttttttttttttttt.');
      } else {
        _isLoading = false;
        _showCustomPopup(
          context,
          'Error',
          'Failed to send password reset email: $e',
          Colors.red,
          Colors.white,
        );
      }
      print('Error sending the email: $e');
    } catch (e) {
      _showCustomPopup(
        context,
        'Error',
        'An unexpected error occurred: $e.',
        Colors.red,
        Colors.white,
      );
    }
  }

  void _showCustomPopup(BuildContext context, String title, String message,
      Color backgroundColor, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: textColor,
                size: 40,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
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
              color: textColor,
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Increase padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: backgroundColor.computeLuminance() > 0.5
                        ? Colors.green[700]
                        : Colors.black, // Text color for contrast
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/images/logo3.png',
                        width: screenWidth * 0.35,
                        height: screenHeight * 0.25,
                        fit: BoxFit.contain,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'OutPassIfy',
                            style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              color: Colors.black,
                            ),
                          ),
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
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.04),
                              Text(
                                "Reset Password",
                                style: TextStyle(fontSize: screenWidth * 0.1),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Container(
                                height: screenHeight * 0.07,
                                width: screenWidth * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: screenWidth * 0.07,
                                    ),
                                    contentPadding: EdgeInsets.only(left: 10.0),
                                    labelText: 'Enter Email',
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _checkForNotifications();
                                  },
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                      Size(screenWidth * 0.5,
                                          screenHeight * 0.06),
                                    ),
                                  ),
                                  child: Text(
                                    'VERIFY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.045,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Dark overlay
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.5 +
                          0.5 * _animationController.value, // Blinking effect
                      child: Image.asset(
                        'lib/images/logo3.png', // Replace with your image path
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
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
}
