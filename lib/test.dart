// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//we use UserModel from map to json and json to map because we are using FutureProvider and it is not able to convert map to json and json to map
//so we are using UserModel to convert map to json and json to map and then we are using UserModel in FutureProvider
//with streamProvider we can use map to json and json to map directly but with FutureProvider we can't use map to json and json to map directly

class CatetgoryName {
  final String UserEmail;
  CatetgoryName({
    required this.UserEmail,
  });



  CatetgoryName copyWith({
    String? UserEmail,
  }) {
    return CatetgoryName(
      UserEmail: UserEmail ?? this.UserEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'UserEmail': UserEmail,
    };
  }

  factory CatetgoryName.fromMap(Map<String, dynamic> map) {
    return CatetgoryName(
      UserEmail: map['UserEmail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CatetgoryName.fromJson(String source) => CatetgoryName.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CatetgoryName(UserEmail: $UserEmail)';

  @override
  bool operator ==(covariant CatetgoryName other) {
    if (identical(this, other)) return true;
  
    return 
      other.UserEmail == UserEmail;
  }

  @override
  int get hashCode => UserEmail.hashCode;
}

//not using.snapshot here becuse it wll giver error of type mismatch as we are using FutureProvider
CollectionReference userData =
    FirebaseFirestore.instance.collection("Users");
//also using here {} not good as it will give error of type mismatch as we are using FutureProvider
final dbProvider = StreamProvider<QuerySnapshot>((ref) => userData.snapshots());

class GETDBSTREAM extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //as Stream is scary .stream is good
    final finalStream = ref.watch(dbProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Update to DB"),
        ),
        body: finalStream.when(data: (QuerySnapshot value) {
          //here we are using UserModel to convert map to json and json to map
          //without it we can't use map to json and json to map directly
          CatetgoryName userModel = CatetgoryName.fromMap(
              value.docs[0].data() as Map<String, dynamic>);
          return Center(
            child: Column(
              children: [
                Text(userModel.UserEmail.toString()),
              ],
            ),
          );
        }, loading: () {
          return Center(child: CircularProgressIndicator());
        }, error: (Object error, StackTrace stackTrace) {
          return Center(child: Text(error.toString()));
        }));
  }
}
