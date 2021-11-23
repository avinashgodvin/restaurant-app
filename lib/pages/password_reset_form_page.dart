import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:restaurant_app/utils/routes.dart';

class PasswordRestFormPage extends StatefulWidget {
  @override
  _PasswordRestFormPageState createState() => _PasswordRestFormPageState();
}

class _PasswordRestFormPageState extends State<PasswordRestFormPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isInternetAvailable = true;

  final _formKey1 = GlobalKey<FormState>();
  String? email = "";

  showNetworkStatusDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('No internet')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Please check your internet connection'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  somethingWentWrongDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Oops')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Something went wrong !'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  passwordUpdatedSuccesfullyDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Successfull')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text(
                    'Your password has been changed successfully , please login to continue ..'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pushNamed(context, MyRoutes.loginRoute);
              },
            ),
          ],
        );
      },
    );
  }

  checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      // print("internet disconnected");
      isInternetAvailable = false;
      context.loaderOverlay.hide();
      showNetworkStatusDialog();
    } else {
      // print('internet connected');
      isInternetAvailable = true;
    }
  }

  Future<void> updatePassword() async {
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(email)
        .update({"password": passwordController.text})
        .then((value) => {
              print("Password updation successful"),
              context.loaderOverlay.hide(),
              passwordUpdatedSuccesfullyDialog(),
            })
        .onError((error, stackTrace) => {
              print("Failed to add user"),
              context.loaderOverlay.hide(),
              somethingWentWrongDialog(),
            });
  }

  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    email = routeData["email"];
    // print(email);
    return Material(
        child: LoaderOverlay(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 100, left: 30, right: 30),
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter new password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty ";
                      } else if (value.length < 6) {
                        return "Password cannot be less than 6 characters";
                      }
                      return null;
                    }),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Enter password again",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty ";
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "Passwords does not match";
                      }
                      return null;
                    }),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey1.currentState!.validate()) {
                      await checkInternetConnection();
                      if (isInternetAvailable) {
                        context.loaderOverlay.show();
                        updatePassword();
                      }
                    }
                  },
                  child: Text("Change Password"),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
