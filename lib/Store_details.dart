// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'StateManagement/FetchData.dart';
import 'package:food_v/StateManagement/users.dart';
import 'package:food_v/settings.dart';

import 'StateManagement/Userdata.dart';

final usersDataForstoreDetails = FirebaseFirestore.instance
    .collection('All_Restraunts')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .snapshots()
    .map((event) => storeDetailss.fromMap(event.data()!));
final storeprovider =
    StreamProvider.autoDispose((ref) => usersDataForstoreDetails);

class StoreDetails extends ConsumerStatefulWidget {
  const StoreDetails({super.key});

  @override
  ConsumerState<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends ConsumerState<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeprovider);
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.orange,
          title: Text(
            "Store details",
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
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: store.when(
              data: (data) {
                return ListView(
                  children: [
                    SizedBox(height: 20.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          DPshowpicker(context, ref);
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: NetworkImage(
                                    data.restraunt_logo.toString(),
                                  ) ==
                                  true
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(55)),
                                  width: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                                  height: 100,
                                )
                              : CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(
                                    data.restraunt_logo.toString(),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Store Name",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: restrauntNameControll,
                      onSubmitted: (value) async {
                        ref.read(userData.notifier).UStoreName();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          hintText: data.restaurant_name.toString(),
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Delivery Time",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: deliveryTimeControll,
                      onSubmitted: (value) async {
                        ref.read(userData.notifier).UDeliveryTime();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.time_to_leave,
                            color: Colors.grey,
                          ),
                          hintText: data.deliver_time ?? ".... min",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Delivery",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: deliveryChargesControll,
                      onSubmitted: (value) async {
                        ref.read(userData.notifier).UDeliveryCharges();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.money,
                            color: Colors.grey,
                          ),
                          hintText: data.deliver_charges ?? 'Free Or Paid',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Orders",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: orderController,
                      onSubmitted: (value) {
                        ref.read(userData.notifier).UOrder();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          hintText: data.OrderType ?? "OrderIn Or TakeAway",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Phone Number",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: restrauntPhoneControll,
                      onSubmitted: (value) {
                        ref.read(userData.notifier).Uphone();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          hintText:
                              data.restraunt_Phone ?? "Enter phone number",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "About Store",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: restrauntAboutControll,
                      onSubmitted: (value) {
                        ref.read(userData.notifier).UAboutStore();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.restaurant_outlined,
                            color: Colors.grey,
                          ),
                          hintText: data.restraunt_About ?? "Enter About Store",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Store Address",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      minLines: 1,
                      maxLines: 7,
                      controller: restrauntAddressControll,
                      onSubmitted: (value) {
                        ref.read(userData.notifier).UAddress();
                      },
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.white,
                          ),
                          hintText:
                              data.restaurant_address ?? "Enter address here",
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          )),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }

  void DPshowpicker(context, WidgetRef ref) {
    showModalBottomSheet(
        context: context, builder: ((builder) => DPBottomSheet(context, ref)));
  }

  Widget DPBottomSheet(context, WidgetRef ref) {
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
                "Update Restraunt Logo",
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
                  onPressed: () async {
                    await ref
                        .read(userData.notifier)
                        .Updatetakephoto(ImageSource.camera);
                    Navigator.pop(context);
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
                  onPressed: () async {
                    await ref
                        .read(userData.notifier)
                        .Updatetakephoto(ImageSource.gallery);
                    Navigator.pop(context);
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
