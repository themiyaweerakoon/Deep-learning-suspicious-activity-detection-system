import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suspicious_activity_detection_system_mobile_application/notificationservice.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_launcher/url_launcher_string.dart';

///// Main Screen Implementation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return const Scaffold();
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

///// Firebase firestore connection configuration
  final CollectionReference _suspicious_activities =
      FirebaseFirestore.instance.collection('suspicious_activities');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 245, 172),
        appBar: AppBar(
          title: const Text("Suspicious Activities"),
          foregroundColor: const Color.fromARGB(255, 114, 86, 0),
          actions: <Widget>[
            ///// Delete Button Implementation
            IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.delete_forever_rounded,
                color: Color.fromARGB(255, 255, 0, 0),
                size: 32,
              ),
              ///// SnackBar popup message
              onPressed: () {
                final snackBar = SnackBar(
                  content: const Text('All Records Removed!!!'),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                ///// Firebase firestore Query to delete all current suspicious records
                FirebaseFirestore.instance
                    .collection('suspicious_activities')
                    .snapshots()
                    .forEach((querySnapshot) {
                  for (QueryDocumentSnapshot docSnapshot
                      in querySnapshot.docs) {
                    docSnapshot.reference.delete();
                  }
                });
              },
            ),
            ///// Notification Button Implementation
            IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.notification_add_rounded,
                  color: Color.fromARGB(255, 131, 0, 143),
                  size: 32,
                ),
                ///// SnackBar popup message
                onPressed: () {
                  final snackBar = SnackBar(
                    content: const Text('Notification Activated'),
                    action: SnackBarAction(
                      label: '',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  ///// Firebase firestore Query to get all suspicious activity count
                  FirebaseFirestore.instance
                      .collection('suspicious_activities')
                      .get()
                      .then((value) => {
                            ///// Show all suspicious activity count as a notification by calling the "Notification Service" class
                            NotificationService().showNotification(
                                1,
                                "Suspicious Activity Detection System",
                                "Suspicious Incident Count: ${value.docs.length}",
                                1)
                          });
                })
          ],
        ),
        ///// Main Body of the Application
        body: StreamBuilder(
            stream: _suspicious_activities.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              // ignore: avoid_print
              print(streamSnapshot.data!.docs.length);
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length, //number of rows
                  itemBuilder: (context, index) {
                    ///// Firebase firestore configuration to access the documents
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        title: const Text(
                          "Suspicious Activity Detected!!!",
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        ///// Get the list of suspicious activity date and time from the firestore
                        subtitle: Text(
                          documentSnapshot['datetime'],
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        // ignore: prefer_const_constructors
                        ///// get the suspicious activity image snapshot from the firestore (snapshot image public URL)
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              Image.network(documentSnapshot['image']).image,
                          child: GestureDetector(
                            ///// Show the snapshot images using public URLs
                            onTap: () => launchUrlString(
                                ""),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(30),
                        textColor: Colors.white,
                        tileColor: Color.fromARGB(255, 0, 70, 5),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
