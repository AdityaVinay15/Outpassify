import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/Guardpages/Guarddashboard.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/Studentpages/unauthstudent.dart';
import 'package:outpassify/pages/login.dart';
import 'package:outpassify/pages/login_page.dart';
import 'package:outpassify/Adminpages/Admindashboard.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:path/path.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<void> gen(String? email, String collection) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS (optional)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? newToken = await messaging.getToken();
    print("New FCM Token: $newToken");

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final docRef = _firestore.collection(collection).doc(email);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final currentToken = docSnapshot.get('Devicetoken') as String?;

        // Only update if the new token is different from the current token
        if (currentToken != newToken) {
          await docRef.update({'Devicetoken': newToken});
          print('Token updated successfully');
        } else {
          print('Token is the same, no update needed');
        }
      } else {
        // If the document does not exist, create it with the new token
        await docRef.set({'Devicetoken': newToken});
        print('Document created and token saved');
      }
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<String?> fcmcheck(String role, String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(role)
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        return document.get('Devicetoken') as String?;
      } else {
        return null; // No document found
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      return null; // Error occurred
    }
  }

  Future<void> checkEmailAndNavigate(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(
              'Students') // Replace 'Students' with your collection name
          .where('Email', isEqualTo: email)
          .get();
      print(
          'cccchhhhhhhhheckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
      print(querySnapshot.docs.first.data());
      if (querySnapshot.docs.isEmpty) {
        // Email not found in Students collection
        print(
            "nnnnnooooooooooooooo onnnnnnnnnnnnnnneeeeeeeeeeeeeeeeeeeeeeeeeeee foundddddddddddddddddddddddddddddd");
        GoRouter.of(context as BuildContext)
            .pushNamed(MyAppRouteConstants.unauthstudent);
      }
    } catch (e) {
      print(
          "Erroooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor checking email in Students collection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // }

          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            final email = user?.email;

            if (email != null) {
              // Check Firestore collections to determine the user's role
              return FutureBuilder(
                future: getUserRole(email),
                builder: (context, AsyncSnapshot<String> roleSnapshot) {
                  // if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  //   return Center(
                  //     child: Image.asset(
                  //       'lib/images/logo3.png', // Replace with your image path
                  //       width: screenWidth * 0.2,
                  //       height: screenHeight * 0.2,
                  //     ),
                  //   );
                  // }

                  if (roleSnapshot.hasData) {
                    String role = roleSnapshot.data!;

                    if (role == 'admin' && screenWidth < 1000) {
                      print(
                          "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                      gen(email, 'Admins');
                      return Admindashboard();
                    } else if (role == 'guard') {
                      // gen(email, 'Guards');
                      return Gaurddashboard();
                    } else if (role == 'student' && screenWidth < 1000) {
                      print(
                          "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
                      gen(email, 'Students');
                      return Studentdashboard();
                    } else {
                      if (screenWidth >= 1000) return Guarddesktoplogin();
                      return LoginPage(); // Fallback for unrecognized roles
                    }
                  }
                  return LoginPage(); // Fallback in case of any error
                },
              );
            }
          }

          // Display appropriate login page based on screen size
          if (screenWidth >= 1000) {
            return Guarddesktoplogin();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }

  Future<String> getUserRole(String email) async {
    try {
      // Check if the user is an Admin
      var adminSnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .where('Email', isEqualTo: email)
          .get();
      if (adminSnapshot.docs.isNotEmpty) {
        return 'admin';
      }

      // Check if the user is a Guard
      var guardSnapshot = await FirebaseFirestore.instance
          .collection('Guards')
          .where('Email', isEqualTo: email)
          .get();
      if (guardSnapshot.docs.isNotEmpty) {
        return 'guard';
      }

      // Check if the user is a Student
      var studentSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Email', isEqualTo: email)
          .get();
      if (studentSnapshot.docs.isNotEmpty) {
        return 'student';
      }

      // Default case if the email is not found in any collection
      return 'unknown';
    } catch (e) {
      print('Error determining user role: $e');
      return 'unknown'; // Return unknown in case of an error
    }
  }
}
