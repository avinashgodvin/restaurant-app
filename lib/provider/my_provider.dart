import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/models/categories_model.dart';
import 'package:restaurant_app/models/food_categories_model.dart';

class MyProvider extends ChangeNotifier {
  List<CategoriesModel> categoriesList = [];
  CategoriesModel? categoriesModel;

  Future<void> getCategories() async {
    List<CategoriesModel> newCategoriesList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("categories").get();

    querySnapshot.docs.forEach((element) {
      categoriesModel = CategoriesModel(
        categoryImage: element.get("image"),
        categoryName: element.get("name"),
      );
      // print(categoriesModel!.categoryImage);
      newCategoriesList.add(categoriesModel!);
      categoriesList = newCategoriesList;
    });
    notifyListeners();
  }

  get throwlist {
    return categoriesList;
  }

  ///////////////////////////// pizzza categories list ///////////////////////////////////

  List<FoodCategoriesModel> pizzaCategoriesList = [];
  FoodCategoriesModel? pizzaCategoriesModel;
  Future<void> getPizzaCategoriesList() async {
    List<FoodCategoriesModel> newPizzaCategoriesList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodcategories")
        .doc("IJq1G9wAd88z8oBSg8LP")
        .collection("Pizza")
        .get();

    querySnapshot.docs.forEach((element) {
      pizzaCategoriesModel = FoodCategoriesModel(
          image: element.get("image"),
          name: element.get("name"),
          price: element.get("price"));

      newPizzaCategoriesList.add(pizzaCategoriesModel!);
      pizzaCategoriesList = newPizzaCategoriesList;
    });
  }

  get throwPizzaCategoriesList {
    return pizzaCategoriesList;
  }

/////////////////////////////// Drinks categroies list ///////////////////////////
  List<FoodCategoriesModel> drinksCategoriesList = [];
  FoodCategoriesModel? drinksCategoriesModel;

  Future<void> getDrinksCategoriesList() async {
    List<FoodCategoriesModel> newDrinksCategoriesList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodcategories")
        .doc("IJq1G9wAd88z8oBSg8LP")
        .collection("Drinks")
        .get();

    querySnapshot.docs.forEach((element) {
      drinksCategoriesModel = FoodCategoriesModel(
          image: element.get("image"),
          name: element.get("name"),
          price: element.get("price"));

      newDrinksCategoriesList.add(drinksCategoriesModel!);
      drinksCategoriesList = newDrinksCategoriesList;
    });
  }

  get throwDrinksCategoriesList {
    return drinksCategoriesList;
  }

/////////////////////////////// Meals categroies list ///////////////////////////
  List<FoodCategoriesModel> mealsCategoriesList = [];
  FoodCategoriesModel? mealsCategoriesModel;

  Future<void> getMealsCategoriesList() async {
    List<FoodCategoriesModel> newMealsCategoriesList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("foodcategories")
        .doc("IJq1G9wAd88z8oBSg8LP")
        .collection("Meals")
        .get();

    querySnapshot.docs.forEach((element) {
      mealsCategoriesModel = FoodCategoriesModel(
          image: element.get("image"),
          name: element.get("name"),
          price: element.get("price"));

      newMealsCategoriesList.add(mealsCategoriesModel!);
      mealsCategoriesList = newMealsCategoriesList;
    });
  }

  get throwMealsCategoriesList {
    return mealsCategoriesList;
  }
}
