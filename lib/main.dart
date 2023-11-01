// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_v/addNewProduct.dart';
import 'package:food_v/addSideItems.dart';
import 'package:food_v/settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_v/Products.dart';
import 'package:food_v/Store_details.dart';
import 'package:food_v/addCategory.dart';
import 'package:food_v/editCategory.dart';
import 'package:food_v/logIn.dart';
import 'package:food_v/signUp.dart';
import 'package:food_v/test.dart';
import 'package:food_v/test2.dart';
import 'package:food_v/test3.dart';
import 'All_Orders.dart';
import 'FreshPendingOrders.dart';
import 'Ratings_Reviews.dart';
import 'addTypeOfCategory.dart';
import 'dashboard.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: email == null ? SignUp() : Dashboard())));
}

Future<String?> getEmailFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}
// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});

//   @override
//   ConsumerState<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends ConsumerState<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     final homee=ref.watch(providd);
//     return MaterialApp(

//       home: email
//     );
//   }
// }
// FutureBuilder<String?>(
//       // Use a FutureBuilder to retrieve the email from shared preferences
//       future: getEmailFromSharedPreferences(),
//       builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading spinner while waiting for email from shared preferences
//           return CircularProgressIndicator();
//         } else {
//           String? email = snapshot.data;
//           // Check if email is null, if yes, navigate to signup page, else check status in Firebase
//           if (email == null) {
//             return SignUp();
//           } else {
//             return StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('All_Restraunts')
//                   .doc(FirebaseAuth.instance.currentUser?.uid)
//                   .snapshots(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Show a loading spinner while waiting for data from Firebase
//                   return CircularProgressIndicator();
//                 } else {
//                   if (snapshot.hasError) {
//                     // Show an error message if there's an error
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     String? status = snapshot.data?.data()?['status'];
//                     // Check if status is 'Approved', if yes, navigate to dashboard, else navigate to login page
//                     if (status == 'Approved') {
//                       return Dashboard();
//                     } else {
//                       return LogIn();
//                     }
//                   }
//                 }
//               },
//             );
//           }
//         }
//       },
//     ),
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:food_v/liveLocation.dart';
// import 'package:location/location.dart' as loc;
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(home: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final loc.Location location = loc.Location();
//   StreamSubscription<loc.LocationData>? _locationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//     // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
//     // location.enableBackgroundMode(enable: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('live location tracker'),
//       ),
//       body: Column(
//         children: [
//           TextButton(
//               onPressed: () {
//                 _getLocation();
//               },
//               child: Text('add my location')),
//           TextButton(
//               onPressed: () {
//                 _listenLocation();
//               },
//               child: Text('enable live location')),
//           TextButton(
//               onPressed: () {
//                 _stopListening();
//               },
//               child: Text('stop live location')),
//           Expanded(
//               child: StreamBuilder(
//             stream:
//                 FirebaseFirestore.instance.collection('location').snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               return ListView.builder(
//                   itemCount: snapshot.data?.docs.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title:
//                           Text(snapshot.data!.docs[index]['name'].toString()),
//                       subtitle: Row(
//                         children: [
//                           Text(snapshot.data!.docs[index]['latitude']
//                               .toString()),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(snapshot.data!.docs[index]['longitude']
//                               .toString()),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.directions),
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   MyMap(snapshot.data!.docs[index].id)));
//                         },
//                       ),
//                     );
//                   });
//             },
//           )),
//         ],
//       ),
//     );
//   }

//   _getLocation() async {
//     try {
//       final loc.LocationData _locationResult = await location.getLocation();
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': _locationResult.latitude,
//         'longitude': _locationResult.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _listenLocation() async {
//     _locationSubscription = location.onLocationChanged.handleError((onError) {
//       print(onError);
//       _locationSubscription?.cancel();
//       setState(() {
//         _locationSubscription = null;
//       });
//     }).listen((loc.LocationData currentlocation) async {
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': currentlocation.latitude,
//         'longitude': currentlocation.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     });
//   }

//   _stopListening() {
//     _locationSubscription?.cancel();
//     setState(() {
//       _locationSubscription = null;
//     });
//   }

//   _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       print('done');
//     } else if (status.isDenied) {
//       _requestPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }
