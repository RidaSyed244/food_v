import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_Products.dart';

class AddSideItems extends StatefulWidget {
  const AddSideItems({
    super.key,
    required this.indexId,
    required this.categoryUid,
  });
  final indexId;
  final categoryUid;

  @override
  State<AddSideItems> createState() => _AddSideItemsState();
}

class _AddSideItemsState extends State<AddSideItems> {
  final sideItemName = TextEditingController();
  final sideItemPrice = TextEditingController();
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
          "Add Side Items",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddProducts(
                          categoryUid: '',
                          indexId: 0,
                        )));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView(children: [
          Text("You can add side items from here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: sideItemName,
            decoration: InputDecoration(
              labelText: "Item Name",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: sideItemPrice,
            decoration: InputDecoration(
              labelText: "Price",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Material(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: MaterialButton(
                onPressed: () async {
                  var sideItems = {
                    'sideItemName': sideItemName.text,
                    'sideItemPrice': int.parse(sideItemPrice.text),
                  };
                  await FirebaseFirestore.instance
                      .collection("Categories")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection("Category")
                      .doc(widget.categoryUid)
                      .collection('Products')
                      .doc(widget.indexId)
                      .update({
                    "SideItems": FieldValue.arrayUnion([sideItems]),
                  });
                  sideItemName.clear();
                  sideItemPrice.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProducts(
                                categoryUid: widget.categoryUid,
                                indexId: widget.indexId,
                              )));
                },
                minWidth: 230.0,
                height: 13.0,
                child: Text('Add Side item',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    )),
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
