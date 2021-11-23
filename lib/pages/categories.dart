import 'package:flutter/material.dart';
import 'package:restaurant_app/models/food_categories_model.dart';
import 'package:restaurant_app/utils/routes.dart';
import 'package:restaurant_app/widgets/bottom_container.dart';

import 'details_page.dart';

class Categories extends StatelessWidget {
  List<FoodCategoriesModel> list = [];
  Categories({required this.list});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.homeRoute);
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: false,
        primary: false,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: list
            .map((e) =>
                BottomContainer(name: e.name, image: e.image, price: e.price))
            .toList(),
      ),
    );
  }
}
