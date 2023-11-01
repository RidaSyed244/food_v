// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/test3.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailFetch {
  final String? email;
  EmailFetch({
    this.email,
  });

  EmailFetch copyWith({
    String? email,
  }) {
    return EmailFetch(
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
    };
  }

  factory EmailFetch.fromMap(Map<String, dynamic> map) {
    return EmailFetch(
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailFetch.fromJson(String source) =>
      EmailFetch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EmailFetch(email: $email)';

  @override
  bool operator ==(covariant EmailFetch other) {
    if (identical(this, other)) return true;

    return other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}

CollectionReference usersssData =
    FirebaseFirestore.instance.collection("Test3");

final providerrr =
    StreamProvider.autoDispose<QuerySnapshot>((ref) => usersssData.snapshots());

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(providerrr);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Admin Log-In "),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("Test3")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .update({"status": "Approved"});
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: user.when(data: (QuerySnapshot value) {
          return ListView.builder(
              itemCount: value.docs.length,
              itemBuilder: (context, index) {
                EmailFetch userModel = EmailFetch.fromMap(
                    value.docs[index].data() as Map<String, dynamic>);
                DocumentSnapshot idd = value.docs[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (idd["status"] == "Approved")
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Test3()));
                          },
                          child: Text("Navigate"))
                    //       Text("${userModel.email.toString()}",
                    //           style: TextStyle(
                    //               fontSize: 40,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.bold)),
                    //                TextButton(
                    // onPressed: () {
                    //   FirebaseFirestore.instance
                    //       .collection("Test3")
                    //       .doc(idd.id)
                    //       .update({"status": "Approved"});
                    // },
                    // child: Text("Submit")),
                  ],
                );
              });
        }, error: (error, stackTrace) {
          return Center(
            child: Text("$error",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          );
        }, loading: () {
          return Center(
            child: Text("Loading",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          );
        }));
  }
}
