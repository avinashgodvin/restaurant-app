import 'package:flutter/material.dart';
import 'package:restaurant_app/pages/details_page.dart';
import 'package:restaurant_app/utils/routes.dart';

class BottomContainer extends StatelessWidget {
  String? image;
  String? name;
  int? price;
  BottomContainer(
      {@required this.name, @required this.image, @required this.price});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("You clicked onTap");
        Navigator.pushNamed(context, MyRoutes.detailsPage, arguments: {
          "name": name.toString(),
          "image": image.toString(),
          "price": price.toString()
        });
      },
      child: Container(
        height: 250,
        width: 180,
        decoration: BoxDecoration(
            color: Color.fromRGBO(247, 240, 240, 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: []),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(image!),
            ),
            Text(name!),
            Text("Rs. " + price.toString() + "/-")
          ],
        ),
      ),
    );
  }
}
