import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'StateManagement/FetchData.dart';
import 'StateManagement/users.dart';
import 'add_Products.dart';
import 'dashboard.dart';

class Products extends ConsumerStatefulWidget {
  const Products({super.key});

  @override
  ConsumerState<Products> createState() => _ProductsState();
}

class _ProductsState extends ConsumerState<Products> {
  @override
  Widget build(BuildContext context) {
    final category = ref.watch(streamProvid);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(
          "All Categories",
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
      body: category.when(data: (data) {
        return ListView.builder(
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            Category catogoryModel = Category.fromMap(
                data.docs[index].data() as Map<String, dynamic>);
            DocumentSnapshot categoryUid = data.docs[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.grey,
                          child: NetworkImage(catogoryModel.CategoryImage) ==
                                  true
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                )
                              : CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                      NetworkImage(catogoryModel.CategoryImage),
                                ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text("${catogoryModel.CategoryName}",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddProducts(
                                            indexId: index,
                                            categoryUid: categoryUid.id,
                                          )));
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }, error: (error, stackTrace) {
        return Center(
          child: Text("Error"),
        );
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
