// ignore_for_file: unused_local_variable, unused_element

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/logIn.dart';
import 'package:food_v/settings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'StateManagement/Userdata.dart';
import 'StateManagement/users.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io' as io;

String sessionToken = '12345';
TextEditingController searchLocationn = TextEditingController();
var uuid = Uuid();
List<dynamic> placePrediction = [];

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestions(searchLocationn.text);
  }

  void getSuggestions(String input) async {
    String kPLACES_API_KEY = "AIzaSyB8Jj-czijVcqGI5gLyEi7Zb9s7VmyTPts";
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        "$baseUrl?input=$input&key=$kPLACES_API_KEY&sessiontoken=$sessionToken&components=country:in";

    final response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print("data");
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        placePrediction = jsonDecode(response.body.toString())["predictions"];
      });
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    searchLocationn.addListener(() {
      onChange();
    });
  }

  String _latitude = '';
  String _longitude = '';

  Future<void> _convertAddressToLatLng() async {
    String address = searchLocationn.text;
    if (address.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            _latitude = locations.first.latitude.toString();
            _longitude = locations.first.longitude.toString();
          });
          String fileName = basename(photo!.path);

          final destination = 'RestrauntLogo/$fileName';
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref(destination)
              .child('file');
          final metadata = firebase_storage.SettableMetadata(
              contentType: 'image/jpg',
              customMetadata: {
                'picked-file-path': fileName,
              });
          firebase_storage.UploadTask uploadTask;
          uploadTask = ref.putFile(io.File(photo!.path), metadata);

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
            'latitude': locations.first.latitude,
            'longitude': locations.first.longitude,
            'restraunt_logo': imageUrl,
            "status": "Pending",
            "uid": FirebaseAuth.instance.currentUser?.uid,
            "CategoryName":"",
          });
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeDetails = ref.watch(provider);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign-up to register your restraunt!",
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showpicker(context, ref);
                  },
                  child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Email*",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: emailControll,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Password*",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: passwordControll,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Store Name*",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: restrauntNameControll,
                decoration: InputDecoration(
                  hintText: "Store name",
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Store Address*",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              TextField(
                minLines: 1,
                maxLines: 5,
                style: TextStyle(color: Colors.black),
                controller: searchLocationn,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: searchLocationn.text != true
                      ? "Store Address"
                      : searchLocationn.text,
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Store Currency*",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: currencyControll,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: currencyControll.text != true
                      ? "Currency"
                      : currencyControll.text,
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    onSelect: (Currency currency) {
                      currencyControll.text = currency.symbol;
                      print('Select currency: ${currency.symbol}');
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: Color.fromRGBO(238, 167, 52, 1),
                            fontSize: 18),
                      )),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  child: MaterialButton(
                    onPressed: () async {
                      await ref.read(userData.notifier).SignUp();

                      await _convertAddressToLatLng();
                      // await ref.read(userData.notifier).takephoto(context);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    minWidth: 230.0,
                    height: 13.0,
                    child: Text('Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        )),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void showpicker(context, WidgetRef ref) {
    showModalBottomSheet(
        context: context, builder: ((builder) => BottomSheet(context, ref)));
  }

  void showLocationPicker(context, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        builder: ((builder) => LocationBottomSheet(context, ref)));
  }

  Widget LocationBottomSheet(context, WidgetRef ref) {
    return Container(
        height: 900,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            TextField(
              controller: searchLocationn,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: searchLocationn.text != true
                    ? "Restraunt Address"
                    : searchLocationn.text,
                helperStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Container(
              height: 350,
              child: ListView.builder(
                  itemCount: placePrediction.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(placePrediction[index]["description"]),
                      onTap: () {
                        setState(() {
                          searchLocationn.text =
                              placePrediction[index]["description"];
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
            ),
          ],
        ));
  }

  Widget BottomSheet(context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Choose Restraunt Logo",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.camera_enhance,
                    color: Colors.black,
                    size: 34,
                  ),
                  onPressed: () => {
                    ref.read(userData.notifier).imgFromCamera(),
                    Navigator.pop(context),
                  },
                  label: Text("Camera",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      )),
                ),
                SizedBox(
                  width: 40.0,
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 34,
                  ),
                  onPressed: () => {
                    ref.read(userData.notifier).imgFromGallery(),
                    Navigator.pop(context),
                  },
                  label: Text("Gallery",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      )),
                ),
              ],
            )
          ]),
    );
  }
}
