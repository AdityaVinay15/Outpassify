import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/routes/app_route_constants.dart';

class Adminattendance extends StatefulWidget {
  const Adminattendance({super.key});

  @override
  State<Adminattendance> createState() => _Adminattendance();
}

class _Adminattendance extends State<Adminattendance> {
  int indexs = 0;
  @override
  void initState() {
    super.initState();
  }

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

  bool sw = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.2),
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
          color: Color(0x80CDD1E4),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5), // Reduced padding
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "Attendance Management",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5), // Reduced padding
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green, width: 1.5),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07), // 75% of width
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Present',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07), // 75% of width
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Absent',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Reduced space between containers and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                    GoRouter.of(context).pushNamed(MyAppRouteConstants.adminfacescan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.width * 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07), // 75% of width
                      ),
                    ),
                    child: Text('Scan', style: TextStyle(color: Colors.white,fontSize:MediaQuery.of(context).size.width * 0.05)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(MyAppRouteConstants.adminregisterface);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.width * 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07), // 75% of width
                      ),
                    ),
                    child: Text('Register', style: TextStyle(color: Colors.white,fontSize:MediaQuery.of(context).size.width * 0.05)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pushNamed(MyAppRouteConstants.adminpastattendance);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.width * 0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07), // 75% of width
                      ),
                    ),
                    child: Text('Past', style: TextStyle(color: Colors.white,fontSize:MediaQuery.of(context).size.width * 0.05)),
                  ),
                ],
              ),
              SizedBox(height: 10),
               // Space between buttons and search box
              Container(
                height: MediaQuery.of(context).size.width * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "Today's Attendance",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    filled: true, // Enables background color
                    fillColor: Colors.white, // Sets background color to white
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0), // Adjust radius as needed
                      borderSide: BorderSide.none, // Removes the border
                    ),
                    hintText: 'Search by Roll Number',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            height: MediaQuery.of(context).size.width * 0.4, // Adjust height as needed
            width: double.infinity,
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    Expanded(
                      flex: 2, // Adjust this flex if needed
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          'Roll Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1, // Adjust this flex if needed
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Space between header and list
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Example item count
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2, // Same flex as header for alignment
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('21A31AA4352',style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),), // Replace with actual data
                            ),
                          ),
                          Expanded(
                            flex: 1, // Same flex as header for alignment
                              child: Center(
                                child: Checkbox(
                                  value: true, // Update this based on actual data
                                  onChanged: (bool? value) {},
                                  activeColor: Color.fromARGB(255, 209, 40, 6),
                                ),
                              ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
    ),
  ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02), // Reduced padding
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
