import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/routes.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1;

  orderPlacedSuccessfullyDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Order placed successfully')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Your order has been placed successfully , Thank you'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.homeRoute);
              },
            ),
          ],
        );
      },
    );
  }

  confirmOrderDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Confirm the Order')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Click confirm to confirm order'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CONIFIRM'),
              onPressed: () {
                orderPlacedSuccessfullyDialog();
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    var name = routeData["name"];
    String price = routeData["price"].toString();
    var image = routeData["image"];
    int itemPrice = int.parse(price);

    // print(image);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(image.toString()),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name.toString(),
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                  Text(
                      "This pizza is made with adhrenece to all the necessary standard proecdure.",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //print("- pressed");
                              setState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.remove),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            quantity.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              //print("+ pressed");
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Rs . " + price.toString() + " /-",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Pizza is a Substance consisting essentially of protein, carbohydrate, fat, and other nutrients used in the body of an organism to sustain growth and vital processes and to furnish energy.",
                      style: TextStyle(
                        color: Colors.grey[100],
                      )),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text("ORDER  NOW",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Rs . " + "${itemPrice * quantity}" + " /-",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 1,
                            ),
                          ],
                        ),
                        onPressed: () {
                          print("clicked order btn");
                          confirmOrderDialog();
                        }),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
