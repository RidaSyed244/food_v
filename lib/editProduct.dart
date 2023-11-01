import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'StateManagement/Userdata.dart';
import 'StateManagement/users.dart';
import 'add_Products.dart';

class EditProduct extends ConsumerStatefulWidget {
  const EditProduct(
      {super.key, required this.categoryIndex, required this.userdata});
  final categoryIndex;
  final userdata;

  @override
  ConsumerState<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends ConsumerState<EditProduct> {
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
          "Edit your Product",
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
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: ListView(
            children: [
              Text("You can edit your Product from here!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: productName,
                decoration: InputDecoration(
                  labelText: "Product Name",
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
                controller: productDescription,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: "Product Description",
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
                controller: productPrice,
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
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(userData.notifier)
                        .updateProductImageFromGallery();
                    ;
                  },
                  child: Text('Add new Image',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15.0,
                      )),
                )
              ]),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  child: MaterialButton(
                    onPressed: () async {
                      await ref.read(userData.notifier).updateProductImage(
                            context,
                            widget.categoryIndex,
                            widget.userdata,
                          );
                      productPrice.clear();
                      productDescription.clear();
                      productName.clear();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProducts(
                                    categoryUid: widget.categoryIndex,
                                    indexId: widget.userdata,
                                  )));
                    },
                    minWidth: 250.0,
                    height: 13.0,
                    child: Text('Update Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        )),
                  ),
                )
              ]),
            ],
          )),
    );
  }
}
