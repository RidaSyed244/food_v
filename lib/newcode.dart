import 'package:flutter/material.dart';
import 'package:food_v/logIn.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'StateManagement/Userdata.dart';

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
                  onTap: () {},
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
                  labelText: "Email",
                  labelStyle: TextStyle(
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
                  labelText: "Password",
                  labelStyle: TextStyle(
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
                  labelText: "Store name",
                  labelStyle: TextStyle(
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
                onTap: () {},
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
}
