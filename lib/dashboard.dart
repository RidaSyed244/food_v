import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_v/Orders.dart';
import 'package:food_v/Products.dart';
import 'package:food_v/Report.dart';
import 'package:food_v/Store_details.dart';
import 'package:food_v/TypeOfCategory.dart';
import 'package:food_v/acceptedOrders.dart';
import 'package:food_v/allFoodCategories.dart';
import 'package:food_v/dispatch_Orders.dart';
import 'package:food_v/settings.dart';
import 'package:food_v/signUp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'FreshPendingOrders.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // final dataa = ref.watch(provider);
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('All_Restraunts')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.data()?["status"] == "Pending") {
                      return Center(
                        child: Container(
                          height: 80,
                          width: 250,
                          color: Colors.orange,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Your account is not\nApproved yet!!!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    } else  if (snapshot.data?.data()?["status"] == "Disapproved") {
                      return Center(
                        child: Container(
                          height: 110,
                          width: 300,
                          color: Colors.orange,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Your account is Disapproved\n due to some reasons. Try Again!!!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      );
                    }
                     else {
                      return Container(
                        child: ListView(
                          children: [
                            Container(
                              // padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                      
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(6, 6, 3, 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 23,
                                          backgroundColor: Colors.grey,
                                          child: NetworkImage(
                                                      snapshot.data?.data()?[
                                                          "restraunt_logo"]) ==
                                                  true
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  width: 100,
                                                  height: 100,
                                                )
                                              : CircleAvatar(
                                                  radius: 55,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data?.data()?[
                                                          "restraunt_logo"]),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${snapshot.data?.data()?["restaurant_name"]}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Email: ${snapshot.data?.data()?["email"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Address: ${snapshot.data?.data()?["restaurant_address"].toString()}",
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Currency: ${snapshot.data?.data()?["restraunt_currency"].toString()}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Status: ${snapshot.data?.data()?["status"].toString()}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(238, 167, 52, 1),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 900,
                                child: StaggeredGridView.countBuilder(
                                    staggeredTileBuilder: (index) =>
                                        index % 2 == 0
                                            ? StaggeredTile.count(4, 1)
                                            : StaggeredTile.count(3, 1),
                                    itemCount: 6,
                                    crossAxisSpacing: 3,
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 12,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: (() {
                                          index == 0
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllCategories()))
                                              : index == 1
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Products()))
                                                  : index == 2
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FreshOrders()))
                                                      : index == 3
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AcceptedOrders()))
                                                          : index == 4
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              DispatchedOrders()))
                                                              : index == 5
                                                                  ? Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  Settingss()))
                                                                  : Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  SignUp()));
                                        }),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.orange,
                                              child: Center(
                                                child: Text(
                                                  index == 0
                                                      ? "All Categories"
                                                      : index == 1
                                                          ? "Products"
                                                          : index == 2
                                                              ? "Fresh Orders"
                                                              : index == 3
                                                                  ? "Accepted\nOrders"
                                                                  : index == 4
                                                                      ? "Dispatch Orders"
                                                                      : index == 5
                                                                          ? "Settings"
                                                                          : "",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    }))
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }
}
