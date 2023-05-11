
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karunamitra/screens/co_admin/co_admin_home.dart';
import '../screens/admin/admin_home.dart';
import '../screens/Service_provider/service_home.dart';
import '../screens/home/home.dart';
import '../screens/user/user_home.dart';
import 'widgets.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);
 
  @override
 
  _MySplashScreenState createState() => _MySplashScreenState();
}
class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      //if user is logged in already
      if (firebaseAuth.currentUser != null) {
        String userEmail = firebaseAuth.currentUser!.email!;
        String userUID = firebaseAuth.currentUser!.uid;
        // Query the "users" collection
        var usersSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Query the "coadmin" collection
        var coAdminSnapshot = await FirebaseFirestore.instance
            .collection("coadmin")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Query the "service" collection
          var serviceSnapshot = await FirebaseFirestore.instance
            .collection("service")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
            // Query the "admins" collection
        var adminsSnapshot = await FirebaseFirestore.instance
            .collection("admin")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Navigate to the corresponding screen based on the collection that contains the user's document
        if (usersSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const UsersHome()));

        } else if (serviceSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const ServiceHome()));

        } else if (coAdminSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const CoAdminHome()));
        }
         else if (adminsSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AdminHome()));
        }
      }
      //if user is NOT logged in already
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // circularProgress(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/bck1.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Karuna Mitra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 122, 18),
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}

