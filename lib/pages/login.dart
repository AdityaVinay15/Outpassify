
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  bool passwordObscured = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false; // State variable for loading indicator
  late AnimationController _animationController; // Controller for blinking effect

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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  String removeSquareBrackets(String input) {
  // Regular expression to match text within square brackets, including the brackets
  final RegExp regex = RegExp(r'\[.*?\]');
  
  // Replace all matches with an empty string
  return input.replaceAll(regex, '');
}
  void signUserIn() async {
    setState(() {
      _isLoading = true; // Show loader when login starts
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      // Navigate to the next page if login is successful
      // Add navigation code here if needed
    } catch (e) {
      // Handle login error, e.g., show a dialog or snackbar
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
            
            removeSquareBrackets(e.toString())),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader when login is complete
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
                                "Login",
                                style: TextStyle(fontSize: screenWidth * 0.15),
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
                                  controller: _email,
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
                                  obscureText: passwordObscured,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: screenWidth * 0.07,
                                    ),
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
                                    contentPadding: EdgeInsets.only(left: 10.0),
                                    labelText: 'Password',
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenWidth * 0.04,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => GoRouter.of(context)
                                        .pushNamed(MyAppRouteConstants.resetpass),
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade900,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : signUserIn, // Disable button when loading
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                      Size(screenWidth * 0.5, screenHeight * 0.06),
                                    ),
                                  ),
                                  child: Text(
                                    'LOGIN',
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
                      opacity: 0.5 + 0.5 * _animationController.value, // Blinking effect
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
}
