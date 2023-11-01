// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/StateManagement/users.dart';
import 'package:food_v/signUp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:food_v/Store_details.dart';
import 'package:food_v/TypeOfCategory.dart';
import 'package:food_v/dashboard.dart';

import 'All_Orders.dart';
import 'Ratings_Reviews.dart';
import 'StateManagement/FetchData.dart';

final currentUser = FirebaseAuth.instance.currentUser;
final userId =
    currentUser?.uid ?? ''; // Provide a default value if currentUser is null

final usersDataForDashboard = FirebaseFirestore.instance
    .collection('All_Restraunts')
    .doc(userId)
    .snapshots()
    .map((event) => RestrauntLogo.fromMap(event.data()!));

final provider =
    StreamProvider.autoDispose<RestrauntLogo>((ref) => usersDataForDashboard);

class Settingss extends ConsumerStatefulWidget {
  const Settingss({super.key});

  @override
  ConsumerState<Settingss> createState() => _SettingssState();
}

class _SettingssState extends ConsumerState<Settingss> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(provider);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
          child: data.when(
              data: (value) {
                return ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: NetworkImage(
                                      value.restraunt_logo.toString() ?? "",
                                    ) ==
                                    true
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(55)),
                                    width: 100,
                                    height: 100,
                                  )
                                : CircleAvatar(
                                    radius: 55,
                                    backgroundImage: NetworkImage(
                                      value.restraunt_logo.toString() ?? "",
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${value.restaurant_name.toString()}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text("Store Details"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreDetails()));
                      },
                    ),
                    ListTile(
                        title: Text("Types of Category"),
                        leading: Icon(Icons.category),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TypeOfCategory()));
                        }),
                    ListTile(
                        title: Text("Ratings and Reviews"),
                        leading: Icon(Icons.rate_review),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RatingsReviews()));
                        }),
                    ListTile(
                      title: Text("All_Orders"),
                      leading: Icon(Icons.food_bank_outlined),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllOrders()));
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    //  Spacer(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Material(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        child: MaterialButton(
                          onPressed: () async {
                            await ref.read(userData.notifier).signout().then(
                                (value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp())));
                            ;
                          },
                          minWidth: 230.0,
                          height: 13.0,
                          child: Text('LOG Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              )),
                        ),
                      )
                    ]),
                  ],
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => Center(child: CircularProgressIndicator()))),
    );
  }
}
