import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final email = TextEditingController();

class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,
                  children: [
            TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Test3")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .update({"status": "Approved"});
                },
                child: Text("Submit")),
            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Name',
              ),
              onSubmitted: (value) {
                FirebaseFirestore.instance
                    .collection("Test3")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set({"email": email.text, "status": "pending"});
              },
            ),
                  ],
                ),
          )),
    );
  }
}

class FetchTest3 extends StatefulWidget {
  const FetchTest3({super.key});

  @override
  State<FetchTest3> createState() => _FetchTest3State();
}

class _FetchTest3State extends State<FetchTest3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Test3").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(""),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
