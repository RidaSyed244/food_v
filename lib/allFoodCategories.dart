// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:food_v/editCategory.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:food_v/dashboard.dart';
import 'StateManagement/FetchData.dart';
import 'StateManagement/users.dart';
import 'addCategory.dart';

class AllCategories extends ConsumerStatefulWidget {
  @override
  ConsumerState<AllCategories> createState() => _ListingsState();
}

class _ListingsState extends ConsumerState<AllCategories> {
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
          "Add a Category",
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
      body: category.when(
        data: (data) {
          return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                Category categoryModel = Category.fromMap(
                    data.docs[index].data() as Map<String, dynamic>);

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
                              child:
                                  NetworkImage(categoryModel.CategoryImage) ==
                                          true
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          width: 100,
                                          height: 100,
                                        )
                                      : CircleAvatar(
                                          radius: 55,
                                          backgroundImage: NetworkImage(
                                              categoryModel.CategoryImage),
                                        ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("${categoryModel.CategoryName.toString()}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditCategory(
                                              categoryIndex: index,
                                              userData: data)));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Delete Category"),
                                            content: Text(
                                                "Are you sure you want to delete this category?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                      ))),
                                              TextButton(
                                                  onPressed: () async {
                                                    await ref
                                                        .read(userData.notifier)
                                                        .dleteCategory(
                                                            data, index);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Delete",
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                      ))),
                                            ],
                                          ));
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        error: (error, stackTrace) {
          return Center(
            child: Text("$error"),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
