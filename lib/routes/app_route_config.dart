import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:outpassify/Adminpages/Adminaboutus.dart';
import 'package:outpassify/Adminpages/Adminaccdec.dart';
import 'package:outpassify/Adminpages/Adminattendance.dart';
import 'package:outpassify/Adminpages/Admindashboard.dart';
import 'package:outpassify/Adminpages/Adminhelpcenter.dart';
import 'package:outpassify/Adminpages/Admininbox.dart';
import 'package:outpassify/Adminpages/Admininfo.dart';
import 'package:outpassify/Adminpages/Adminmanagestudents.dart';
import 'package:outpassify/Adminpages/Adminpastattendance.dart';
import 'package:outpassify/Adminpages/Adminregisterface.dart';
import 'package:outpassify/Adminpages/Adminreport.dart';
import 'package:outpassify/Adminpages/Adminscanface.dart';
import 'package:outpassify/Adminpages/Adminsettings.dart';
import 'package:outpassify/Guardpages/Guardaboutus.dart';
import 'package:outpassify/Guardpages/Guardhelpcenter.dart';
import 'package:outpassify/Studentpages/Studentaboutus.dart';
import 'package:outpassify/Studentpages/Studenthelpcenter.dart';
import 'package:outpassify/Guardpages/GuardInbox.dart';
import 'package:outpassify/Guardpages/Guarddashboard.dart';
import 'package:outpassify/Guardpages/Guardinfo.dart';
import 'package:outpassify/Guardpages/Guardinstatus.dart';
import 'package:outpassify/Guardpages/Guardsetting.dart';
import 'package:outpassify/Guardpages/Guardstudentinfo.dart';
import 'package:outpassify/Guardpages/Guardstudentrequest.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/Studentpages/Studentinfo.dart';
import 'package:outpassify/Studentpages/Studentpermissions.dart';
import 'package:outpassify/Studentpages/Studentreport.dart';
import 'package:outpassify/Studentpages/Studentreqestinfo.dart';
import 'package:outpassify/Studentpages/Studentsettings.dart';
import 'package:outpassify/Studentpages/unauthstudent.dart';
import 'package:outpassify/components/Studentnodata.dart';
import 'package:outpassify/pages/Resetpassword.dart';
import 'package:outpassify/pages/auth_page.dart';
import 'package:outpassify/pages/guarddesktopresetpassword.dart';
import 'package:outpassify/routes/app_route_constants.dart';


class MyApprouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      name: MyAppRouteConstants.authName,
      path: '/',
      pageBuilder: (context, state) {
        return MaterialPage(child: AuthPage());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.resetpass,
      path: '/resetpass',
      pageBuilder: (context, state) {
        return MaterialPage(child: Resetpass());
      },
    ),
      
    GoRoute(
      name: MyAppRouteConstants.homeRouteName,
      path: '/home',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentdashboard());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.studentpermissionRouteName,
      path: '/studentpermission',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentpermissions());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.studentsettingsName,
      path: '/studentsettings',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentsettings());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.studentinfoName,
      path: '/studentinfo',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentinfo());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.studentreport,
      path: '/studentreport',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentreport());
      },
    ),
     GoRoute(
  name: MyAppRouteConstants.logout,
  path: '/logout',
  pageBuilder: (context, state) {
    FirebaseAuth.instance.signOut();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).goNamed(MyAppRouteConstants.authName);
    });

    return MaterialPage(child: SizedBox.shrink());
  },
),

    GoRoute(
      name: MyAppRouteConstants.adminRouteName,
      path: '/admin',
      pageBuilder: (context, state) {
        return MaterialPage(child: Admindashboard());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminpermissionRouteName,
      path: '/adminpermission',
      pageBuilder: (context, state) {
        return MaterialPage(child: Admininbox());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminsettingsRouteName,
      path: '/adminsettings',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminsettings());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.admininfoRouteName,
      path: '/admininfo',
      pageBuilder: (context, state) {
        return MaterialPage(child: Admininfo());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminaccdecRouteName,
      path: '/adminaccdec/:rollnumber/:date/:time',
      builder: (context, state) {
        final rollnumber = state.pathParameters['rollnumber']!;
        final date = state.pathParameters['date']!;
        final time = state.pathParameters['time']!;
        return Adminaccdec(
          rollnumber: rollnumber,
          date: date,
          permissionTime: time,
        );
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminhelpcenter,
      path: '/adminhelpcenter',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminhelpcenter());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminaboutus,
      path: '/adminaboutus',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminaboutus());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.requestaccepted,
      path: '/request',
      pageBuilder: (context, state) {
        return MaterialPage(child: Admininbox());
      },
    ),
     GoRoute(
      name: MyAppRouteConstants.adminpremissionsreport,
      path: '/adminpremissionreport',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminreport());
      },
    ),
    
    
    GoRoute(
      name: MyAppRouteConstants.adminattendance,
      path: '/adminattendance',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminattendance());
      },
    ),
    
    GoRoute(
      name: MyAppRouteConstants.adminpastattendance,
      path: '/adminpastattendance',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminpastattendance());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardRouteName,
      path: '/guard',
      pageBuilder: (context, state) {
        return MaterialPage(child: Gaurddashboard());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardstatusRouteName,
      path: '/guardstatus',
      pageBuilder: (context, state) {
        return MaterialPage(child: Guardinstatus());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardsettingsRouteName,
      path: '/guardsettings',
      pageBuilder: (context, state) {
        return MaterialPage(child: Guardsetting());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardinfoRouteName,
      path: '/guardinfo',
      pageBuilder: (context, state) {
        return MaterialPage(child: Gaurdinfo());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardinboxRouteName,
      path: '/guardinbox',
      pageBuilder: (context, state) {
        return MaterialPage(child:abcd());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardrollnumber,
      path: '/guardstudentinfo/:rollnumber',
      builder: (context, state) {
        final rollNumber = state.pathParameters['rollnumber']!;
        print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
        print(rollNumber);
        return Guardstudentinfo(rollnumber: rollNumber);
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardstudentinfo,
      path: '/guardstudentinfo/:rollnumber/:date/:time',
      builder: (context, state) {
        final rollnumber = state.pathParameters['rollnumber']!;
        final date = state.pathParameters['date']!;
        final time = state.pathParameters['time']!;
        return Guardstudentrequest(
          rollnumber: rollnumber,
          date: date,
          time: time,
        );
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.studentreqinfo,
      path: '/studentreqinfo/:rollnumber/:date/:time',
      builder: (context, state) {
        final rollnumber = state.pathParameters['rollnumber']!;
        final date = state.pathParameters['date']!;
        final time = state.pathParameters['time']!;
        return Studentrequestinfo(
          rollnumber: rollnumber,
          date: date,
          time: time,
        );
      },
    ),
     GoRoute(
      name: MyAppRouteConstants.guardhelpcenter,
      path: '/guardhelpcenter',
      pageBuilder: (context, state) {
        return MaterialPage(child: Guardhelpcenter());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.guardaboutus,
      path: '/guardaboutus',
      pageBuilder: (context, state) {
        return MaterialPage(child: Guardaboutus());
      },
    ),
      GoRoute(
      name: MyAppRouteConstants.guarddesktopresetpassword,
      path: '/studentdesktopresetpassword',
      pageBuilder: (context, state) {
        return MaterialPage(child: Guarddesktopresetpassword());
      },
    ),
    GoRoute(
      name: MyAppRouteConstants.adminmanagestudentsdata,
      path: '/adminmanagestudentsdata',
      pageBuilder: (context, state) {
        return MaterialPage(child: Adminmanagestudents());
      },
    ),
     GoRoute(
      name: MyAppRouteConstants.helpcenter,
      path: '/helpcenter',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studenthelpcenter());
      },
    ),
         GoRoute(
      name: MyAppRouteConstants.studentaboutus,
      path: '/Aboutus',
      pageBuilder: (context, state) {
        return MaterialPage(child: Studentaboutus());
      },
    ),
     GoRoute(
      name: MyAppRouteConstants.unauthstudent,
      path: '/unauthstudent',
      pageBuilder: (context, state) {
        return MaterialPage(child: Unauthstudent());
      },
    ),
  ]);
}
