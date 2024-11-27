import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/components/newuser.dart';
import 'package:lottie/lottie.dart';


class Studentnodata extends StatefulWidget {
  const Studentnodata({super.key});

  @override
  State<Studentnodata> createState() => _Studentnodata();
}


class _Studentnodata extends State<Studentnodata> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/icons/studentnodata.json', // Replace with your actual path
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
