import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/Products.dart';
import 'package:food_v/addTypeOfCategory.dart';
import 'package:food_v/settings.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'StateManagement/users.dart';

class TypeOfCategory extends ConsumerStatefulWidget {
  const TypeOfCategory({super.key});

  @override
  ConsumerState<TypeOfCategory> createState() => _TypeOfCategoryState();
}

class _TypeOfCategoryState extends ConsumerState<TypeOfCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text(
            "Types Of Category",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Settingss()));
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("TypesOfCategory")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('CategoryType')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final categoryType = snapshot.data?.docs[index];
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("${categoryType?["categoryType"]}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("Delete Category"),
                                                content: Text(
                                                    "Are you sure you want to delete this category?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                          ))),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await ref
                                                            .read(userData
                                                                .notifier)
                                                            .dleteCategoryType(
                                                                documentSnapshot
                                                                    .id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Delete",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                          ))),
                                                ],
                                              ));
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTypeOfCategory()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.orange,
        ));
  }
}
