import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/pages/guarddesktopresetpassword.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Guarddesktoplogin extends StatefulWidget {
  @override
  _GuarddesktoploginState createState() => _GuarddesktoploginState();
}

class _GuarddesktoploginState extends State<Guarddesktoplogin>
    with SingleTickerProviderStateMixin {
  bool passwordObscured = true;
  bool isLoading = false; // Loading state variable
  final _email = TextEditingController();
  final _password = TextEditingController();
  late AnimationController _animationController; // Controller for blinking effect

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Duration of one blink cycle
    )..repeat(reverse: true); // Repeats the animation back and forth
  }
  String removeSquareBrackets(String input) {
  // Regular expression to match text within square brackets, including the brackets
  final RegExp regex = RegExp(r'\[.*?\]');
  
  // Replace all matches with an empty string
  return input.replaceAll(regex, '');
}

  @override
  void dispose() {
    _animationController.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void signUserIn() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      // Navigate to the next page if login is successful
      // Example: context.go('/dashboard'); // Replace with your desired route
    } catch (e) {
      // Handle error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${removeSquareBrackets(e.toString())}'),backgroundColor: Colors.red,),
      );
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                  decoration: BoxDecoration(
                    color: Color(0x80CDD1E4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Adjust font size for desktop
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.3, // Adjust width for desktop
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.white),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,
                                  color: Colors.black, size: screenWidth * 0.02),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              hintText: 'Enter Email', // Use hintText instead of labelText
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: screenWidth * 0.01),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.3, // Adjust width for desktop
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.white),
                            color: Colors.white,
                          ),
                          child: TextField(
                            obscureText: passwordObscured,
                            controller: _password,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,
                                  color: Colors.black, size: screenWidth * 0.02),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordObscured = !passwordObscured;
                                  });
                                },
                                icon: Icon(
                                  passwordObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              hintText: 'Password', // Use hintText instead of labelText
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: screenWidth * 0.01),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => GoRouter.of(context).pushNamed(
                                MyAppRouteConstants.guarddesktopresetpassword),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.01, // Adjust font size for desktop
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            signUserIn();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(screenWidth * 0.15, screenHeight * 0.08)),
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.01), // Adjust font size for desktop
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) // Display loader if isLoading is true
            Container(
              color: Colors.black.withOpacity(0.5), // Dark overlay
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.5 + 0.5 * _animationController.value, // Blinking effect
                      child: Image.asset(
                        'lib/images/logo3.png', // Replace with your image path
                        width: screenWidth * 0.2,
                        height: screenWidth * 0.2,
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
}
