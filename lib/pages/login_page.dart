import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:restaurant_app/pages/shared_preference.dart';
import 'package:restaurant_app/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isInternetAvailable = true, emailExists = true;
  bool? value = false;

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

  wrongUsernameOrPasswordDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Wrong username or password')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Click forgot password to reset the password'),
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

  verifyPassword() async {
    String password;
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(emailController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      // print('Document data: ${documentSnapshot.get("password")}');
      password = documentSnapshot.get("password");
      if (passwordController.text == password) {
        context.loaderOverlay.hide();
        if (value != null && value == true) {
          UserSimplePreference.setRememberMeStatus(true);
        } else {
          UserSimplePreference.setRememberMeStatus(false);
        }
        Navigator.pushNamed(context, MyRoutes.homeRoute);
      } else {
        context.loaderOverlay.hide();
        wrongUsernameOrPasswordDialog();
      }
    });
  }

  Future<void> checkEmailIdExists() async {
    // print(nameController.text);
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(emailController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        emailExists = true;
        // print("Email id exists , good to go");
        // context.loaderOverlay.hide();
        // emailIdAlreadyExistsDialog();
      } else {
        emailExists = false;
        print('Wrong username or password');
        context.loaderOverlay.hide();
        wrongUsernameOrPasswordDialog();
      }
    });
  }

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

  checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      // print("internet disconnected");
      isInternetAvailable = false;
      showNetworkStatusDialog();
    } else {
      // print('internet connected');
      isInternetAvailable = true;
    }
  }

  Widget buildCheckbox() => Checkbox(
        value: value,
        onChanged: (value) {
          setState(() {
            this.value = value;
          });
          print(this.value);
        },
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: LoaderOverlay(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/login_image.png"),
                SizedBox(
                  height: 20,
                ),
                Text("Welcome ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 32.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            hintText: "Enter email id",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            String p =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(p);
                            if (value == null || value.isEmpty) {
                              return " email cannot be empty";
                            } else if (!regExp.hasMatch(value)) {
                              return "Enter valid email address";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter Password",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty ";
                            } else if (value.length < 6) {
                              return "Password cannot be less than 6 characters";
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            buildCheckbox(),
                            Text(
                              "Remember me",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 170, top: 10),
                          child: InkWell(
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: Colors.orange[600], fontSize: 12),
                            ),
                            onTap: () => {
                              print("Click forgot pwd btn"),
                              Navigator.pushNamed(
                                  context, MyRoutes.passwordResetRoute)
                            },
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () async {
                              print("Pressed Log in Button");

                              // print(emailController.text);

                              goToHome() async {
                                await checkInternetConnection();
                                if (isInternetAvailable) {
                                  context.loaderOverlay.show();
                                  await checkEmailIdExists();
                                  if (emailExists) {
                                    verifyPassword();
                                  }
                                }
                              }

                              if (_formKey.currentState!.validate()) {
                                goToHome();
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("New User ?"),
                                SizedBox(
                                  width: 7,
                                ),
                                InkWell(
                                  child: Container(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(color: Colors.red[400]),
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                      context, MyRoutes.signUpRoute),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
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
