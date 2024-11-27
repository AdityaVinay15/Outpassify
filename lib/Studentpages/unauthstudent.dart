import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:outpassify/pages/login.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Unauthstudent extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {

  //   return PopScope(onPopInvoked: (didPop) => GoRouter.of(context).pushNamed(MyAppRouteConstants.logout),
  //     child: Scaffold(
  //       appBar: PreferredSize(
  //       child: AppBar(
  //           scrolledUnderElevation: 0,
  //           elevation: 0,
  //           centerTitle: true,
  //           title: Text(
  //             "OutPassIfy",
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: MediaQuery.of(context).size.width * 0.08,
  //                 fontFamily: 'DancingScript'),
  //           ),
  //           leading: Container(
  //             height: MediaQuery.of(context).size.height * 0.07,
  //             child: Image.asset(
  //               'lib/images/logo3.png',
  //               width: MediaQuery.of(context).size.height * 0.3,
  //             ),
  //           ),
  //           backgroundColor: Color(0x80CDD1E4),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(35),
  //                   bottomRight: Radius.circular(35))),
  //         ),
  //         preferredSize: const Size.fromHeight(70.0),
  //       ),
  //       body: GestureDetector(
  //         child: Center(
  //           child: Container(
  //             width: 250, // Diameter of the circle
  //             height: 250, // Diameter of the circle
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.red, // Background color
  //             ),
  //             child: Center(
  //               child: ElevatedButton(
  //                 onPressed: () async {
  //                   // Handle button press
  //                   await _handleEmailNotFound(context);
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.transparent, // Make button background transparent
  //                   elevation: 0, // Remove button shadow
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(70), // Circular shape
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'Please Click Me, \nI will get you to Login page.',
  //                   style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15), // Text color
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.07,
            child: Image.asset(
              'lib/images/logo3.png',
              width: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          backgroundColor: Color(0x80CDD1E4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
        ),
        preferredSize: const Size.fromHeight(70.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stack containing Lottie Animation and Click Me text
            Stack(
              alignment: Alignment.center,
              children: [
                // Lottie Animation
                GestureDetector(
                  onTap: () {
                    // Navigate to the LoginPage when animation is clicked
                    _handleEmailNotFound(context);
                  },
                  child: Lottie.asset(
                    'assets/icons/studentnodata.json', // Replace with your actual path
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                // "Click Me" Text with Low Intensity
                Opacity(
                  opacity: 0.7, // Adjust opacity to control intensity
                  child: Text(
                    'CLICK ME',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.black, // Customize color as needed
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black
                              .withOpacity(0.5), // Optional text shadow
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Space between animation and the text
            // Message Below the Animation
            Text(
              'Sorry!, couldn\'t find your account,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red, // Customize text color as needed
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Click above to route to the login page',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red, // Customize text color as needed
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _handleEmailNotFound(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Delete the user's account
      await user.delete();
      // Sign out the user
      await FirebaseAuth.instance.signOut();
      // Navigate to a sign-in page or home page
      GoRouter.of(context).pushNamed(MyAppRouteConstants.logout);

    } else {
      _showCustomPopup(
        context,
        'Error',
        'No user is currently logged in.',
        Colors.red,
        Colors.white,
      );
    }
    print(
        "calllllllllllllllllllllllllllllllllleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddd");
  } catch (e) {
    _showCustomPopup(
      context,
      'Error',
      'Failed to delete user: $e',
      Colors.red,
      Colors.white,
    );
    print('Error deleting user: $e');
  }
}

void _showCustomPopup(BuildContext context, String title, String message,
    Color bgColor, Color textColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: textColor)),
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: bgColor,
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: TextStyle(color: textColor)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
