//import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/categories_model.dart';
import 'package:restaurant_app/models/food_categories_model.dart';
import 'package:restaurant_app/pages/categories.dart';
import 'package:restaurant_app/provider/my_provider.dart';
import 'package:restaurant_app/utils/routes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoriesModel> categoriesList = [];

  List<FoodCategoriesModel> pizzaCategoriesList = [];
  List<FoodCategoriesModel> drinksCategoriesList = [];
  List<FoodCategoriesModel> mealsCategoriesList = [];

  Widget category() {
    return Column(
      children: categoriesList
          .map((e) =>
              mainContainerItems(name: e.categoryName, image: e.categoryImage))
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  confirmationForQuitting() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Do you really want to quit ?')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('click Ok to Quit, cancel to stay on the page'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }

  Widget mainContainerItems({@required String? name, @required String? image}) {
    return GestureDetector(
      onTap: () {
        print(name);
        if (name == "Pizza") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Categories(list: pizzaCategoriesList),
            ),
          );
        } else if (name == "Drinks") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Categories(list: drinksCategoriesList),
            ),
          );
        } else if (name == "Meals") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Categories(list: mealsCategoriesList),
            ),
          );
        }
      },
      child: Container(
        height: 200,
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
            Text(name!)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);

    provider.getCategories();
    categoriesList = provider.throwlist;

    provider.getPizzaCategoriesList();
    pizzaCategoriesList = provider.throwPizzaCategoriesList;

    provider.getDrinksCategoriesList();
    drinksCategoriesList = provider.throwDrinksCategoriesList;

    provider.getMealsCategoriesList();
    mealsCategoriesList = provider.throwMealsCategoriesList;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Restaurant App"),
          // actions: [
          //   CircleAvatar(
          //     backgroundImage: AssetImage("assets/images/reset.png"),
          //   )
          // ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: false,
            primary: false,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: categoriesList
                .map((e) => mainContainerItems(
                    name: e.categoryName, image: e.categoryImage))
                .toList(),
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/reset.png"),
                ),
                accountName: Text("Avinash Godvin D Almieda"),
                accountEmail: Text("avinashgodvin@gmail.com"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.loginRoute);
                },
              )
            ]),
          ),
        ),
      ),
      onWillPop: () async {
        confirmationForQuitting();
        return false;
      },
    );
  }
}
