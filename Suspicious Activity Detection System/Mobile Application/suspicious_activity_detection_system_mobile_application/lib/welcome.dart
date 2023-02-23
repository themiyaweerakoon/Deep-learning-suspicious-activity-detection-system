import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suspicious_activity_detection_system_mobile_application/homescreen.dart';
import 'package:suspicious_activity_detection_system_mobile_application/login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 221, 121),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "WELCOME",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("WELCOME",
                    style: TextStyle(
                        color: Color.fromARGB(255, 190, 124, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        letterSpacing: 10))
              ],
            ),
            ElevatedButton(
              child: Text("View Suspicious Activity Records",
                  style: const TextStyle(
                      color: Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return Color.fromARGB(255, 40, 109, 0);
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
            ),
            ElevatedButton(
              child: Text("Logout",
                  style: const TextStyle(
                      color: Color.fromARGB(221, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return Color.fromARGB(255, 255, 0, 0);
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
            ),
          ]),
        ));
  }
}
