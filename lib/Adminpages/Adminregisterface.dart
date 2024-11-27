import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class Adminregisterface extends StatefulWidget {
  const Adminregisterface({super.key});

  @override
  State<Adminregisterface> createState() => _Adminregisterface();
}

class _Adminregisterface extends State<Adminregisterface> {
  int indexs = 0;
  late ImagePicker imagePicker;
  File? _image;
  String? rollNumber;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }
  
  String? imageUrl;
  Future<void> uploadImageToFirebase(
      File image, String enteredRollNumber) async {
    try {
      // Query Firestore to find the document with the specified roll number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: enteredRollNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document is found, proceed with the image upload
        String docId = querySnapshot.docs.first.id;

        // Upload the image to Firebase Storage
        Reference reference = FirebaseStorage.instance
            .ref()
            .child("profilepictures/Students/$rollNumber.png");
        await reference.putFile(image);

        // Get the download URL of the uploaded image
        imageUrl = await reference.getDownloadURL();

        // Update the Profilepicture field in Firestore
        await FirebaseFirestore.instance
            .collection('Students')
            .doc(docId)
            .update({'Profilepicture': imageUrl});

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Image uploaded and Profile updated successfully!"),
          ),
        );

        print("Image URL updated in Firestore: $imageUrl");
        setState(() {
          imageUrl = imageUrl;
        });
      } else {
        // Handle case when no document is found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("No student found with the provided Roll Number."),
          ),
        );
      }
    } catch (e) {
      // Display error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to upload image: $e"),
        ),
      );
    }
  }

  Future<void> _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      if (rollNumber != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Students')
            .where('Rollnumber', isEqualTo: rollNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If roll number exists, get the document ID
          String docId = querySnapshot.docs.first.id;

          // Upload the image to Firebase Storage and update Firestore
          await uploadImageToFirebase(_image!, rollNumber!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
              content: Text("Roll number not found in Students collection."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text("Please enter a roll number."),
          ),
        );
      }
    }
  }

  doFaceDetection() async {
    //TODO remove rotation of camera images

    //TODO passing input to face detector and getting detected faces

    //TODO call the method to perform face recognition on detected faces
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Adminsettings"),
    Text("Profile"),
  ];
  int currentIndex = 0;

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        print("Homeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
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

  void signUserOut() {
    print("Otttttttttttttttttttttttttt");
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).pushNamed(MyAppRouteConstants.logout);
  }

  bool sw = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.2),
        child: AppBar(
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
            height: 50,
            child: Image.asset(
              'lib/images/logo3.png',
              width: 500,
            ),
          ),
          actions: <Widget>[
            // IconButton(
            //   onPressed: () {
            //     GoRouter.of(context)
            //         .pushNamed(MyAppRouteConstants.adminattendance);
            //   },
            //   icon: Image.asset(
            //     'assets/icons/scanface.png',
            //     width: MediaQuery.of(context).size.width * 0.12,
            //     height: MediaQuery.of(context).size.width * 0.12,
            //   ),
            // ),
            
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
                child: Center(
                    child: Text(
                  "Register Face",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08),
                )),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),

              // TextField for entering Roll Number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Roll Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    rollNumber = value;
                    // Handle roll number input here
                  },
                ),
              ),

              SizedBox(height: 20),

              _image != null
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: screenWidth - 50,
                      height: screenWidth - 50,
                      child: Image.file(_image!),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Image.asset(
                        'assets/icons/scanface.png',
                        width: screenWidth - 100,
                        height: screenWidth - 200,
                      ),
                    ),

              SizedBox(height: 20),

              // Section for choosing and capturing images
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(200))),
                      child: InkWell(
                        onTap: () {
                          _imgFromCamera();
                        },
                        child: SizedBox(
                          width: screenWidth / 2 - 70,
                          height: screenWidth / 2 - 70,
                          child: Icon(Icons.camera,
                              color: Colors.blue, size: screenWidth / 7),
                        ),
                      ),
                    )
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
          color: Color(0x80CDD1E4),
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
          backgroundColor: Colors.transparent,
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
        ),
      ),
    );
  }
}
