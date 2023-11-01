import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'Userdata.dart';

final userData=StateNotifierProvider((ref) => UserData());
final categoryData = FirebaseFirestore.instance
    .collection("Categories")
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection('Category');

final streamProvid = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return categoryData.snapshots();
});
final currentLocation = StateNotifierProvider((ref) => UserData());
final productData = FirebaseFirestore.instance
    .collection("Categories")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection("Category")
    .doc()
    .collection('Products');