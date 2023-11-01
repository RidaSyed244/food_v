// ignore_for_file: unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_v/StateManagement/users.dart';
import 'package:food_v/signUp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'StateManagement/Userdata.dart';
import 'dashboard.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
String? token;

class LogIn extends ConsumerStatefulWidget {
  const LogIn({super.key});

  @override
  ConsumerState<LogIn> createState() => _LogInState();
}

class _LogInState extends ConsumerState<LogIn> {
  void generateAndSaveToken() async {
    // Request permission for notifications
    await messaging.requestPermission();

    // Get the FCM token
    token = await messaging.getToken();
    print('FCM Token: $token');
  }

  void initState() {
    super.initState();
    generateAndSaveToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text(
            "Log In",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Log In",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "To edit restaurant details and check\nif the admin has approved your\nrestaurant,you can log in\nto your account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                ],
              ),
              SizedBox(
                height: 40.0,
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
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: emailControll,
                decoration: InputDecoration(
                  labelText: "Enter your email",
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
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: passwordControll,
                decoration: InputDecoration(
                  labelText: "Enter your Password",
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        final login =
                            await ref.read(userData.notifier).logInUser();
                        if (login != false) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("email", emailControll.text);
                        }
                        await ref.read(userData.notifier).getToken();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));

                        // if (approve.status == "Approved") {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Dashboard()));
                        // } else {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (context) => LogIn()));
                        // }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(seconds: 5),
                          content: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(238, 167, 52, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Text('Alert!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text('Your account is not Approved yet!!!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    },
                    minWidth: 230.0,
                    height: 13.0,
                    child: Text('LOG IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        )),
                  ),
                )
              ]),
            ],
          ),
        ));
  }
}
