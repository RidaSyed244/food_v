import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/Order_details.dart';
import 'package:food_v/dashboard.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class AcceptedOrders extends StatefulWidget {
  const AcceptedOrders({super.key});

  @override
  State<AcceptedOrders> createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  List<dynamic> fetchFreshOrders = [];
  var restrauntName;

  Future getRestrauntName() async {
    await FirebaseFirestore.instance
        .collection('All_Restraunts')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      setState(() {
        restrauntName = value.data()?['restaurant_name'];
        print(restrauntName);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRestrauntName();
  }

  sendOrderDispatchNot(token, productName) async {
    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      var body = {
        "to": token,
        "notification": {
          "title": "Order Dispatched",
          "body":
              "Your Order for ${productName} has been dispatched by the ${restrauntName}",
        },
      };

      var response = await post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              "key=AAAAbXwSTlU:APA91bEvCpFMnWOvco-UbHMGzWOsK8yTRqL1PxHwRBCjIKcRlsYKMb1mH-P9to-VkDcIsQUOhQPq0s1XoMdEZzbpFhrGGDfV1TRqQiWreVnUPPTnGfiK8Nrw4yX-bfxYTZuYrceTZ5SH",
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("Sending Notification to ${token}");

      print("Send Notification successfully");
    } catch (e) {
      print("Notification-Error: $e");
    }
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
          "Accepted Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("All_Restraunts")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("All_Orders")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final allOrders = snapshot.data!.docs[index];
                  fetchFreshOrders = allOrders["products"] ?? [];

                  final time = allOrders["OrderTime"] as Timestamp;

                  DateTime dateTime = time.toDate();
                  String formattedDate =
                      DateFormat('EEE, M/d/y').format(dateTime);

                  return Column(
                    children: [
                      for (var orderItem in fetchFreshOrders)
                        if (allOrders["status"] == "Accept"
                            // &&
                            //     allOrders["statusByDriver"] == "Accepted"
                            )
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.grey,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  orderItem["ProductImage"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            orderItem["ProductName"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  DefaultTextStyle(
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Description: ${orderItem["ProductDescription"]}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Special Instructions:  ${orderItem["ProductSpecialInstructions"]??""}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity: ${orderItem["ProductQuantity"]}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Restraunt Status: ${allOrders["status"]}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.orange,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        if (orderItem.containsKey("Side_Items"))
                                          Column(
                                            children: [
                                              for (var sideItem
                                                  in orderItem["Side_Items"])
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Side Item:     ${sideItem["SideItemName"]}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "Price: ${sideItem["SideItemPrice"]}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        Row(
                                          children: [
                                            Text(
                                              "Driver Status: ${allOrders["statusByDriver"]}",
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orange,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            if (allOrders["statusByDriver"] ==
                                                "Accepted")
                                              Text(
                                                "Driver Arrived: ${allOrders["driverArrived"]}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // const Text("\$\$"),
                                            // const Padding(
                                            //   padding: EdgeInsets
                                            //       .symmetric(
                                            //           horizontal:
                                            //               8),
                                            //   child:
                                            //       CircleAvatar(
                                            //     radius: 2,
                                            //     backgroundColor:
                                            //         Colors
                                            //             .black38,
                                            //   ),
                                            // ),
                                            // // Text(
                                            // // "${previousfood.foodType}"),
                                            // Spacer(),
                                            Text(
                                              "Price: ${orderItem["ProductPrice"]}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    238, 167, 52, 1),
                                              ),
                                            )
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //           vertical: 5),
                                        //       child: Text(
                                        //         "Restaurant:  ${orderItem["Store_Name"]}",
                                        //         style: TextStyle(
                                        //             fontSize: 16,
                                        //             color: Colors.grey),
                                        //         maxLines: 2,
                                        //         overflow: TextOverflow.ellipsis,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Text(
                                                "Total:  ${orderItem["totalPrice"]}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.orange),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Material(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(
                                                        productImage: orderItem[
                                                            "ProductImage"],
                                                        productName: orderItem[
                                                            "ProductName"],
                                                        prosuctQuantity: orderItem[
                                                            "ProductQuantity"],
                                                        productDescription:
                                                            orderItem[
                                                                "ProductDescription"],
                                                        personName: allOrders[
                                                            "UserName"],
                                                        personEmail: allOrders[
                                                            "UserEmail"],
                                                        orderTime: formattedDate
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                minWidth: 20.0,
                                                height: 8.0,
                                                child: Text(
                                                  'Order Details',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Material(
                                              color:
                                                  allOrders["driverArrived"] ==
                                                          "true"
                                                      ? Colors.green
                                                      : Colors.red,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          "All_Restraunts")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .collection("All_Orders")
                                                      .doc(allOrders.id)
                                                      .update({
                                                    "Dispatch_Order": "true",
                                                  });
                                                  await sendOrderDispatchNot(
                                                    allOrders["UserToken"],
                                                    orderItem["ProductName"],
                                                  );
                                                },
                                                minWidth: 20.0,
                                                height: 8.0,
                                                child: Text(
                                                  'Dispatch Order',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "No Orders Yet",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
