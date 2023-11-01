import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_v/settings.dart';

import 'StateManagement/FetchData.dart';

class RatingsReviews extends StatefulWidget {
  const RatingsReviews({super.key});

  @override
  State<RatingsReviews> createState() => _RatingsReviewsState();
}

class _RatingsReviewsState extends State<RatingsReviews> {
  List ratingReviewData = [];

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
            "Ratings & Reviews",
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("All_Restraunts")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection("RatingsandReviews")
                    .snapshots(),
                builder: (context, snapshot) {
                  // return ListView.builder(
                  //     itemCount: snapshot.data?.docs.length,
                  //     itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisExtent: 190),
                      // controller: scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        AllRatingAndReview ratingsOfFood =
                            AllRatingAndReview.fromMap(
                                snapshot.data!.docs[index].data());

                        final allReviewImages = snapshot.data!.docs[index];
                        ratingReviewData = allReviewImages["imageUrls"] ?? [];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Column(children: [
                                    //   // CircleAvatar(
                                    //   //   radius: 15,
                                    //   //   child: Container(
                                    //   //     height: 15,
                                    //   //     width: 15,
                                    //   //     decoration: BoxDecoration(
                                    //   //       shape: BoxShape.circle,
                                    //   //       image: DecorationImage(
                                    //   //         image: AssetImage(ratingsOfFood),
                                    //   //         fit: BoxFit.cover,
                                    //   //       ),
                                    //   //     ),
                                    //   //   ),
                                    //   // ),
                                    // ]),
                                    // SizedBox(
                                    //   width: 13,
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ratingsOfFood.Name.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 25,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(238, 167, 52, 1),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          ratingsOfFood.Rating.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        ratingsOfFood.Review.toString(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ratingReviewData.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 3.5 / 3,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                ratingReviewData[index]
                                                    ["ImageUrls"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }
}
