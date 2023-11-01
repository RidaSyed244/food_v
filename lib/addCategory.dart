import 'package:flutter/material.dart';
import 'package:food_v/allFoodCategories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'StateManagement/Userdata.dart';
import 'StateManagement/users.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
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
            "Add a new Category",
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
          padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: ListView(children: [
            Text("You can add a new Category from here!",
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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(userData.notifier)
                            .categoryImagefromGallery();
                      },
                      child: Text('Add Image',
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
                    await ref.read(userData.notifier).takeCategoryImage(
                          context,
                        );
                    categoryNameController.clear();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllCategories()));
                  },
                  minWidth: 150.0,
                  height: 13.0,
                  child: Text('Add Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      )),
                ),
              )
            ]),
          ]),
        ));
  }
}
