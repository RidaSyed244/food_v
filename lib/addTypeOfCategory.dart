import 'package:flutter/material.dart';
import 'package:food_v/StateManagement/users.dart';
import 'package:food_v/TypeOfCategory.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'StateManagement/Userdata.dart';

class AddTypeOfCategory extends ConsumerStatefulWidget {
  const AddTypeOfCategory({super.key});

  @override
  ConsumerState<AddTypeOfCategory> createState() => _AddTypeOfCategoryState();
}

class _AddTypeOfCategoryState extends ConsumerState<AddTypeOfCategory> {
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
          "Add Type Of Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TypeOfCategory()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 70, 20, 0),
        child: ListView(
          children: [
            Text("You can add any type of Category from here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 60,
            ),
            TextFormField(
              controller: categoryTypeControll,
              decoration: InputDecoration(
                labelText: "Type of category",
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
              height: 40,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Material(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: MaterialButton(
                  onPressed: () async {
                    await ref.read(userData.notifier).addCategoryType();
                    categoryTypeControll.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TypeOfCategory()));
                  },
                  minWidth: 250.0,
                  height: 13.0,
                  child: Text('Add Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      )),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
