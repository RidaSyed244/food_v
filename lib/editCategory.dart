import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'StateManagement/Userdata.dart';
import 'StateManagement/users.dart';
import 'allFoodCategories.dart';

class EditCategory extends ConsumerStatefulWidget {
  EditCategory({required this.categoryIndex, required this.userData});
  final int categoryIndex;
  final userData;

  @override
  ConsumerState<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends ConsumerState<EditCategory> {
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
          "Edit Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategories()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: ListView(children: [
          Text("You can edit your Category from here!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: categoryNameController,
            decoration: InputDecoration(
              labelText: "Category Name",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
              onPressed: () async {
                await ref.read(userData.notifier).updateCategoryImage();
              },
              child: Text('Edit Image',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 15.0,
                  )),
            )
          ]),
          SizedBox(
            height: 40,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Material(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: MaterialButton(
                onPressed: () async {
                  await ref.read(userData.notifier).updateCategoryImageNew(
                      context, widget.userData, widget.categoryIndex);
                  categoryNameController.clear();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllCategories()));
                },
                minWidth: 150.0,
                height: 13.0,
                child: Text('Edit Category',
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
