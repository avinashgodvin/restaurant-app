import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/utils/routes.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool emailAlreadyExists = false, isInternetAvailable = true;

  emailIdAlreadyExistsDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Emai id Already Exists')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Please try with a different email id '),
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

  accountCreatedSuccessfullyDialog() {
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
                    'Your account has been created successfuly , please login to continue ..'),
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

  Future<void> addUser() async {
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(emailController.text)
        .set({
          "name": nameController.text,
          "password": passwordController.text,
          "phone": phoneNumberController.text
        })
        .then((value) => {
              print("User Added"),
              context.loaderOverlay.hide(),
              accountCreatedSuccessfullyDialog()
            })
        .onError((error, stackTrace) => {print("Failed to add user")});
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

  Future<void> checkEmailIdAlredayExists() async {
    // print(nameController.text);
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(emailController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        emailAlreadyExists = true;
        print("Email id alreday exists ");
        context.loaderOverlay.hide();
        emailIdAlreadyExistsDialog();
      } else {
        emailAlreadyExists = false;
        print('No email id found , good to go');
      }
    });
  }

  checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      // print("internet disconnected");
      isInternetAvailable = false;
      showNetworkStatusDialog();
    } else {
      isInternetAvailable = true;
      // print('internet connected');
    }
  }

  void validation() {
    print(nameController.text);
    print(emailController.text);
    print(passwordController.text);
    print(confirmPasswordController.text);
    print(phoneNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
        child: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Container(
                  padding: EdgeInsets.only(right: 180),
                  child: Text("Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                      )),
                ),
                SizedBox(
                  height: 11,
                ),
                Container(
                  constraints: BoxConstraints(minHeight: 100, maxWidth: 350),
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: "Enter full name ",
                            labelText: "Full Name "),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name cannot be empty ";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: "Enter E-mail", labelText: "Email id "),
                          validator: (value) {
                            String p =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(p);
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty ";
                            } else if (!regExp.hasMatch(value)) {
                              return "Enter valid email address";
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                              hintText: "Enter Phone number",
                              labelText: "Mobile number "),
                          validator: (value) {
                            String p = r'(^[0-9]{10}$)';
                            RegExp regExp = new RegExp(p);
                            if (value == null || value.isEmpty) {
                              return "Phone number cannot be empty ";
                            } else if (!regExp.hasMatch(value)) {
                              return "Enter a valid phone address";
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Create password ",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty ";
                            } else if (value.length < 6) {
                              return "Password cannot be less than 6 characters";
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm password",
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
                          })
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Sign up btn Pressed");

                      register() async {
                        await checkInternetConnection();
                        if (isInternetAvailable) {
                          context.loaderOverlay.show();
                          await checkEmailIdAlredayExists();
                          if (!emailAlreadyExists) {
                            addUser();
                          }
                        }
                      }

                      validation();
                      if (_signUpFormKey.currentState!.validate()) {
                        register();
                      }
                    },
                    child: Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
