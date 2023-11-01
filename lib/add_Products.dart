import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/StateManagement/users.dart';
import 'package:food_v/Products.dart';
import 'package:food_v/addNewProduct.dart';
import 'package:food_v/addSideItems.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'editProduct.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

final productStream = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return productData.snapshots();
});

class AddProducts extends ConsumerStatefulWidget {
  final indexId;
  final categoryUid;
  const AddProducts(
      {Key? key, required this.indexId, required this.categoryUid})
      : super(key: key);

  @override
  ConsumerState<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends ConsumerState<AddProducts> {
  List sideItems = [];
  @override
  Widget build(BuildContext context) {
    // final products = ref.watch(productStream);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(
          "All Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Products()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Categories")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("Category")
              .doc(widget.categoryUid)
              .collection('Products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data!.docs[index].data();
                    DocumentSnapshot products = snapshot.data!.docs[index];
                    sideItems = product["SideItems"] ?? [];
                    final featuredItem = product['Featured_Items'] == "true";

                    return Column(
                      children: [
                        // for (var i = 0; i < productsssInList.length; i++)
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 23,
                                          backgroundColor: Colors.grey,
                                          child: NetworkImage(
                                                    product['productImage']
                                                        .toString(),
                                                  ) ==
                                                  true
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              55)),
                                                  width: 100,
                                                  height: 100,
                                                )
                                              : CircleAvatar(
                                                  radius: 55,
                                                  backgroundImage: NetworkImage(
                                                    product['productImage']
                                                        .toString(),
                                                  ),
                                                ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "${product['productName'].toString()}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("Categories")
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection("Category")
                                                  .doc(widget.categoryUid)
                                                  .collection('Products')
                                                  .doc(products.id)
                                                  .update({
                                                "Featured_Items": "true"
                                              });
                                            },
                                            icon: Icon(Icons.star,
                                                color: featuredItem
                                                    ? Colors.orange
                                                    : Colors.grey)),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Description: ${product['productDescription'].toString()}",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Column(children: [
                                      if (product.containsKey("SideItems"))
                                        Column(
                                          children: [
                                            for (var sideItem in sideItems)
                                              Row(
                                                children: [
                                                  Text(
                                                    "Side Item: ${sideItem["sideItemName"]}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "Price: ${sideItem["sideItemPrice"]}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Material(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6.0),
                                            ),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditProduct(
                                                              categoryIndex: widget
                                                                  .categoryUid,
                                                              userdata:
                                                                  products.id,
                                                            )));
                                              },
                                              minWidth: 20.0,
                                              height: 8.0,
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Material(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6.0),
                                            ),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(userData.notifier)
                                                    .dleteProduct(
                                                        widget.categoryUid,
                                                        products.id);
                                              },
                                              minWidth: 20.0,
                                              height: 8.0,
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
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
                                                            AddSideItems(
                                                              categoryUid: widget
                                                                  .categoryUid,
                                                              indexId:
                                                                  products.id,
                                                            )));
                                              },
                                              minWidth: 20.0,
                                              height: 8.0,
                                              child: Text(
                                                'Add Side\nItems',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ])
                                  ],
                                ),
                              ]),
                            )),
                      ],
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewProduct(
                        categoryIndex: widget.categoryUid,
                        userdata: widget.indexId,
                      )));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
