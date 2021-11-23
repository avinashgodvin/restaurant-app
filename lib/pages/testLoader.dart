import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TestLoader extends StatefulWidget {
  @override
  _TestLoaderState createState() => _TestLoaderState();
}

class _TestLoaderState extends State<TestLoader> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Material(
      child: LoaderOverlay(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    print("pressed");
                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection("categories")
                        .get();

                    querySnapshot.docs.forEach((element) {
                      print(element.get("image"));
                      // DocumentSnapshot doc = element;
                      // print(doc.get("image"));
                    });
                  },
                  child: Text("press")),
            )
          ],
        ),
      ),
    );
  }
}
