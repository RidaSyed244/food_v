// ignore_for_file: unused_local_variable
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_v/logIn.dart';
import 'package:food_v/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import '../signUp.dart';

File? photo;

final categoryNameController = TextEditingController();
final productName = TextEditingController();
final productDescription = TextEditingController();
final productPrice = TextEditingController();
final logoutAuth = FirebaseAuth.instance;
final emailControll = TextEditingController();
final orderController = TextEditingController();
final restrauntPhoneControll = TextEditingController();
final restrauntAboutControll = TextEditingController();
final passwordControll = TextEditingController();
final restrauntNameControll = TextEditingController();
final restrauntImageControll = TextEditingController();
final restrauntAddressControll = TextEditingController();
final currencyControll = TextEditingController();
final categoryTypeControll = TextEditingController();
final deliveryTimeControll = TextEditingController();
final deliveryChargesControll = TextEditingController();
final logInAuth = FirebaseAuth.instance;
PickedFile? imageFile;
final ImagePicker _picker = ImagePicker();
String data = '';
String? imageUrl;

class UserData extends StateNotifier {
  UserData() : super('');
  SignUp() async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailControll.text, password: passwordControll.text);
    User? user = result.user;

    return user;
  }

  signUpNewRestraunt() async {
    // var url = Uri.parse("http://localhost:51911/#/");
    // var response = await http.post(url, body: {
    //   'email': emailControll.text,

    // if (response.statusCode == 200) {
    //   // Data was sent successfully
    // } else {
    //   // An error occurred
    // }
  }
  getToken() {
    FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "token": token,
    });
  }

  Future logInUser() async {
    return await logInAuth.signInWithEmailAndPassword(
        email: emailControll.text, password: passwordControll.text);
  }

  Future signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    return await logoutAuth.signOut();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'RestrauntLogo/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future takephoto(BuildContext context) async {
    String fileName = basename(photo!.path);
    final destination = 'RestrauntLogo/$fileName';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      final imageUrl = await (await uploadTask).ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance
          .collection("All_Restraunts")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'email': emailControll.text,
        'password': passwordControll.text,
        'restaurant_name': restrauntNameControll.text,
        'restraunt_currency': currencyControll.text,
        'restaurant_address': searchLocationn.text,
        'restraunt_logo': imageUrl,
        "status": "Pending",
        "uid": FirebaseAuth.instance.currentUser?.uid,
      });
    } catch (e) {
      print(e);
    }
  }

  Future Updatetakephoto(ImageSource sourse) async {
    final pickedFile = await _picker.pickImage(source: sourse);
    if (pickedFile == null) return;
    String uniquefilename = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceroot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceroot.child('file');
    Reference referenceImagetoUpload = referenceDirImages.child(uniquefilename);
    try {
      await referenceImagetoUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImagetoUpload.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("All_Restraunts")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "restraunt_logo": imageUrl,
      });
      imageFile = pickedFile as PickedFile;
    } catch (e) {
      print(e);
    }
  }

  Future productImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadProductImage();
    } else {
      print('No image selected.');
    }
  }

  Future uploadProductImage() async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'ProductImage/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future takeProductImage(BuildContext context, categoryUid, indexId) async {
    String fileName = basename(photo!.path);
    final destination = 'ProductImage/$fileName';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      final productImageUrl = await (await uploadTask).ref.getDownloadURL();
      print(productImageUrl);

      await FirebaseFirestore.instance
          .collection("Categories")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Category")
          .doc(categoryUid)
          .collection('Products')
          .add({
        'productName': productName.text,
        'productPrice': int.parse(productPrice.text),
        'productImage': productImageUrl,
        'productDescription': productDescription.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateCategoryImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadUpdatedCategoryImage();
    } else {
      print('No image selected.');
    }
  }

  Future uploadUpdatedCategoryImage() async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'CategoryImage/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future updateCategoryImageNew(BuildContext context, data, index) async {
    String fileName = basename(photo!.path);
    final destination = 'CategoryImage/$fileName';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      final categoryImageUrl = await (await uploadTask).ref.getDownloadURL();
      print(categoryImageUrl);

      await FirebaseFirestore.instance
          .collection("Categories")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Category")
          .doc(data.docs[index].id)
          .update({
        "CategoryName": categoryNameController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "CategoryImage": categoryImageUrl
      });
    } catch (e) {
      print(e);
    }
  }
  // addNewCategory() {
  //   FirebaseFirestore.instance
  //       .collection("Categories")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('Category')
  //       .add({

  //   });
  //   // FirebaseFirestore.instance.collection("FilterCategories").add({
  //   //   "CategoryName": categoryNameController.text,
  //   // });
  // }

  // editCategoryName(data, index) {
  //   FirebaseFirestore.instance
  //       .collection("Categories")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('Category')
  //       .doc(data.docs[index].id)
  //       .update({"CategoryName": categoryNameController.text});
  // }

  dleteCategory(data, index) {
    FirebaseFirestore.instance
        .collection("Categories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Category')
        .doc(data.docs[index].id)
        .delete();
  }

  Future categoryImagefromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadCategoryImage();
    } else {
      print('No image selected.');
    }
  }

  Future uploadCategoryImage() async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'CategoryImage/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future takeCategoryImage(BuildContext context) async {
    String fileName = basename(photo!.path);
    final destination = 'CategoryImage/$fileName';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      final categoryImageUrl = await (await uploadTask).ref.getDownloadURL();
      print(categoryImageUrl);

      await FirebaseFirestore.instance
          .collection("Categories")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Category")
          .add({
        "CategoryName": categoryNameController.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "CategoryImage": categoryImageUrl
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateProductImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      uploadUpdatedProductImage();
    } else {
      print('No image selected.');
    }
  }

  Future uploadUpdatedProductImage() async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'ProductImage/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future updateProductImage(BuildContext context, categoryUid, products) async {
    String fileName = basename(photo!.path);
    final destination = 'ProductImage/$fileName';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {
          'picked-file-path': fileName,
        });
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(photo!.path), metadata);
    try {
      firebase_storage.UploadTask task = await Future.value(uploadTask);
      final productImageUrl = await (await uploadTask).ref.getDownloadURL();
      print(productImageUrl);

      FirebaseFirestore.instance
          .collection("Categories")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Category")
          .doc(categoryUid)
          .collection('Products')
          .doc(products)
          .update({
        'productName': productName.text,
        'productPrice': int.parse(productPrice.text),
        'productImage': productImageUrl,
        'productDescription': productDescription.text,
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      print(e);
    }
  }

  dleteProduct(categoryUid, products) {
    FirebaseFirestore.instance
        .collection("Categories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Category")
        .doc(categoryUid)
        .collection('Products')
        .doc(products)
        .delete();
  }

  getLocation() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Position datas = await determinedPosition();
      GetAddressfromLatLong(datas);
    }
  }

  determinedPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      return Future.error("Location service are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions denied forever");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void GetAddressfromLatLong(Position datas) async {
    List<Placemark> placeMark =
        await placemarkFromCoordinates(datas.latitude, datas.longitude);
    Placemark places = placeMark[0];
    var address = "${places.locality},${places.country}";
    // setState(() {
    data = address;
    // });
  }

  Uphone() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "restraunt_Phone": restrauntPhoneControll.text,
    });
  }

  UAboutStore() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "restraunt_About": restrauntAboutControll.text,
    });
  }

  UAddress() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "restraunt_address": searchLocationn.text,
    });
  }

  UOrder() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "OrderType": orderController.text,
    });
  }

  UStoreName() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "restaurant_name": restrauntNameControll.text,
    });
  }

  UDeliveryTime() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "deliver_time": deliveryTimeControll.text,
    });
  }

  UDeliveryCharges() async {
    await FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "deliver_charges": deliveryChargesControll.text,
    });
  }

  addCategoryType() {
    FirebaseFirestore.instance
        .collection("TypesOfCategory")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('CategoryType')
        .add({
      'categoryType': categoryTypeControll.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  dleteCategoryType(documentSnapshot) {
    FirebaseFirestore.instance
        .collection("TypesOfCategory")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('CategoryType')
        .doc(documentSnapshot)
        .delete();
  }
}
