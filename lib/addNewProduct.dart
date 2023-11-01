import 'package:flutter/material.dart';
import 'package:food_v/addSideItems.dart';
import 'package:food_v/add_Products.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'StateManagement/Userdata.dart';
import 'StateManagement/users.dart';

class AddNewProduct extends ConsumerStatefulWidget {
  const AddNewProduct(
      {super.key, required this.categoryIndex, required this.userdata});
  final categoryIndex;
  final userdata;
  @override
  ConsumerState<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends ConsumerState<AddNewProduct> {
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
          "Add a new Product",
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
          child: ListView(
            children: [
              Text("You can add a new Product\nfrom here!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 20,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(userData.notifier)
                            .productImageFromGallery();
                      },
                      child: Text('Add Image',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 15.0,
                          )),
                    )
                  ]),
                  // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //   TextButton(
                  //     onPressed: () async {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => AddSideItems(
                  //                   categoryUid: widget.categoryIndex,
                  //                   indexId: widget.userdata,
                  //             )));

                  //     },
                  //     child: Text('Add Side Items',
                  //         style: TextStyle(
                  //           color: Colors.orange,
                  //           fontSize: 15.0,
                  //         )),
                  //   )
                  // ]),
                ],
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
                      await ref.read(userData.notifier).takeProductImage(
                          context, widget.categoryIndex, widget.userdata);

                      productPrice.clear();
                      productDescription.clear();
                      productName.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProducts(
                                    categoryUid: widget.categoryIndex,
                                    indexId: widget.userdata,
                                  )));
                    },
                    minWidth: 230.0,
                    height: 13.0,
                    child: Text('Add Product',
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
