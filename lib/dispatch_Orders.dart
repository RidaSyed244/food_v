import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/dashboard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DispatchedOrders extends StatefulWidget {
  const DispatchedOrders({super.key});

  @override
  State<DispatchedOrders> createState() => _DispatchedOrdersState();
}

class _DispatchedOrdersState extends State<DispatchedOrders> {
  List fetchAllOrders = [];
  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  Stream<List<DocumentSnapshot>> get stream => _streamController.stream;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("All_Restraunts")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("All_Orders")
        .where("deliverStatus", isEqualTo: "false")
        .where("status", isEqualTo: "Accept")
        .where("Dispatch_Order", isEqualTo: "true")
        .snapshots()
        .listen((querySnapshot) {
      _streamController.add(querySnapshot.docs);
    });
  }

  LatLng userLocation = LatLng(0, 0);
  LatLng driverLocation = LatLng(0, 0);

  StreamSubscription<DocumentSnapshot>? locationSubscription;

  // @override
  // void dispose() {
  //   _streamController.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Dispatch Orders",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text("No data available."),
                  );
                }
                if (snapshot.hasData) {
                  List<Marker> userMarkers = [];
                  List<Polyline> polylines = [];
                  List<Marker> driverMarkers = [];
                  final allOrdersDelivered = snapshot.data!.every((result) {
                    final data = result.data() as Map<String, dynamic>;
                    return data["deliverStatus"] == "true";
                  });

                  if (allOrdersDelivered) {
                    // All orders are delivered, show a text message
                    return Center(
                      child: Container(
                        height: 100,
                        width: 250,
                        color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All orders are delivered.\nPlease wait for new orders.",
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

                  snapshot.data?.forEach((result) {
                    Map<String, dynamic> data =
                        result.data() as Map<String, dynamic>;
                    //       if (data["deliverStatus"] == "true")

                    userLocation =
                        LatLng(data["User_latitude"], data["User_longitude"]);
                    userMarkers.add(Marker(
                      markerId: MarkerId('User-${result.id}'),
                      position: userLocation,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: InfoWindow(
                        title: 'Customer',
                        // Customize this label as needed
                      ),
                    ));

                    driverLocation = LatLng(
                      data["Driver_latitude"],
                      data["Driver_longitude"],
                    );

                    driverMarkers.add(Marker(
                      markerId: MarkerId('Driver-${result.id}'),
                      position: driverLocation,
                      icon: BitmapDescriptor.defaultMarker,
                      infoWindow: InfoWindow(
                        title: 'Driver', // Customize this label as needed
                      ),
                    ));
                    // Check if the statusByDriver is "Accepted"
                    if (data["statusByDriver"] == "Accepted") {
                      polylines.add(Polyline(
                        polylineId: PolylineId('route-Driver-${result.id}'),
                        points: [userLocation, driverLocation],
                        color: Colors.green,
                      ));
                    }
                  });

                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: userLocation,
                            zoom: 16,
                          ),
                          markers: {
                            ...userMarkers,
                            Marker(
                              markerId: MarkerId('User'),
                              position: userLocation,
                            ),
                            ...driverMarkers,
                            Marker(
                              markerId: MarkerId('Driver'),
                              position: driverLocation,
                            ),
                          },
                          polylines: Set<Polyline>.from(polylines),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 410.0),
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final allOrders = snapshot.data![index];
                              fetchAllOrders = allOrders["products"] ?? [];
                              // DocumentSnapshot orderId = snapshot.data![index];
                              final time = allOrders["OrderTime"] as Timestamp;

                              DateTime dateTime = time.toDate();
                              String formattedDate =
                                  DateFormat('EEE, M/d/y').format(dateTime);
                              String formattedTime =
                                  DateFormat('h:mm a').format(dateTime);

                              for (var orderItem in fetchAllOrders) {
                                return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 20),
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
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.grey,
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.network(
                                                          orderItem[
                                                              "ProductImage"],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    orderItem["ProductName"],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   children: [
                                              //     if (orderItem["statusByDriver"] ==
                                              //         "Accepted")
                                              //       Icon(Icons.check_circle,
                                              //           color: Colors.green),
                                              //     if (orderItem["statusByDriver"] ==
                                              //         "Rejected")
                                              //       Icon(Icons.cancel, color: Colors.red),
                                              //     if (allOrders["status"] == "Pending")
                                              //       Icon(Icons.pending,
                                              //           color: Colors.orange),
                                              //   ],
                                              // )
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          DefaultTextStyle(
                                            style: const TextStyle(
                                                color: Colors.black54),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Description: ${orderItem["ProductDescription"]}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Special Instructions:  ${orderItem["ProductSpecialInstructions"]??"Not Added"}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Restraunt: ${orderItem["Store_Name"]}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Restraunt Location: ${orderItem["Store_Location"]}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 7,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order Time: ${formattedTime}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Order Date: ${formattedDate}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       "Your Location: ${allOrders["UserLocation"]} ",
                                                //       style: TextStyle(
                                                //         fontSize: 16,
                                                //         color: Colors.grey,
                                                //       ),
                                                //       maxLines: 2,
                                                //       overflow: TextOverflow.ellipsis,
                                                //     ),
                                                //   ],
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       "Your Name: ${allOrders["UserName"]} ",
                                                //       style: TextStyle(
                                                //         fontSize: 16,
                                                //         color: Colors.grey,
                                                //       ),
                                                //       maxLines: 2,
                                                //       overflow: TextOverflow.ellipsis,
                                                //     ),
                                                //   ],
                                                // ),
                                                if (orderItem
                                                    .containsKey("Side_Items"))
                                                  Column(
                                                    children: [
                                                      for (var sideItem
                                                          in orderItem[
                                                              "Side_Items"])
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Side Item:     ${sideItem["SideItemName"]}",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              "Price: ${sideItem["SideItemPrice"]}",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       "Restraunt Status: ${allOrders["status"]}",
                                                //       style: TextStyle(
                                                //         fontSize: 16,
                                                //         color: Colors.blue,
                                                //         fontWeight:
                                                //             FontWeight.w600,
                                                //       ),
                                                //       maxLines: 2,
                                                //       overflow:
                                                //           TextOverflow.ellipsis,
                                                //     ),
                                                //   ],
                                                // ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Driver Status: ${allOrders["statusByDriver"]}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              }
                            }),
                      )
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 450.0),
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 250,
                        color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Dispatch Orders yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // } else {
                //   return Center(
                //     child: Container(
                //       height: 80,
                //       width: 250,
                //       color: Colors.orange,
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           "No orders yet",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               fontSize: 20,
                //               color: Colors.white,
                //               fontWeight: FontWeight.w600),
                //         ),
                //       ),
                //     ),
                //   );
                // }
              }),
        ));
  }
}
