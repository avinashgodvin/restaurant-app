import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:restaurant_app/auth.config.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:restaurant_app/utils/routes.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _otpController = TextEditingController();
  bool isInternetAvailable = true,
      emailExists = true,
      otpFieldVisible = false,
      isVerifyOtpBtnVisible = false;
  //formEnabled = true     ;

  // Declare the object
  EmailAuth emailAuth = new EmailAuth(
    sessionName: "Restaurant App ",
  );

  void _changed(bool visibility) {
    setState(() {
      otpFieldVisible = visibility;
    });
  }

  showVerifyOtpBtn() {
    setState(() {
      isVerifyOtpBtnVisible = true;
    });
  }

  // void _formEnabled(bool enable) {
  //   setState(() {
  //     formEnabled = enable;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //emailAuth.config(remoteServerConfiguration);
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.text, otpLength: 5);
    if (result) {
      print("OTP sent");
      context.loaderOverlay.hide();
      otpSentDialog();
    } else {
      print("failed to send OTP");
    }
  }

  void verifyOtp() async {
    bool res = emailAuth.validateOtp(
        recipientMail: _emailController.text, userOtp: _otpController.text);
    if (res) {
      print("OTP verified");
      otpVerifiedDialog();
    } else {
      print("Invalid OTP");
      invalidOtpDialog();
    }
  }

  otpSentDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('OTP sent')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('OTP has been sent to your emaid id'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _changed(true);
                // _formEnabled(false);
                showVerifyOtpBtn();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  otpVerifiedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('OTP Verification successful')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('OTP has been verified successfully'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                context.loaderOverlay.hide();
                // Navigator.of(context).pop();
                Navigator.pushNamed(context, MyRoutes.passwordResetFormRoute,
                    arguments: {"email": _emailController.text});
              },
            ),
          ],
        );
      },
    );
  }

  invalidOtpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('invalid OTP ')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text('Please enter correct OTP '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                context.loaderOverlay.hide();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  emailNotRegisteredDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child:
                  const Text('Dint find any account associated to this Email')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('No internet.'),
                Text(
                    'Please enter email id with which u have registered for the app '),
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

  validateEmail() {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    if (!regExp.hasMatch(_emailController.text) ||
        _emailController.text.isEmpty) {
      print("not valid email address");
    }
  }

  Future<void> checkEmailIdExists() async {
    // print(nameController.text);
    await FirebaseFirestore.instance
        .collection("registeredUsers")
        .doc(_emailController.text)
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
        emailNotRegisteredDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LoaderOverlay(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Image.asset("assets/images/reset.png"),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey1,
                  child: TextFormField(
                    // enabled: formEnabled ? true : false,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Enter email",
                        // labelText: "Email id",
                        suffixIcon: TextButton(
                            onPressed: () async {
                              print("Send OTP clicked");

                              await checkInternetConnection();
                              if (_formKey1.currentState!.validate()) {
                                print("valid form");
                                if (isInternetAvailable) {
                                  FocusScope.of(context).unfocus();
                                  context.loaderOverlay.show();
                                  await checkEmailIdExists();
                                  if (emailExists) {
                                    // await emailAuth
                                    //     .config(remoteServerConfiguration);
                                    sendOtp();
                                  }
                                }
                              }
                            },
                            child: Text("Send OTP"))),
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
                ),
                SizedBox(
                  height: 20,
                ),
                otpFieldVisible
                    ? TextFormField(
                        controller: _otpController,
                        decoration: InputDecoration(hintText: "Enter OTP"),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: isVerifyOtpBtnVisible,
                  child: ElevatedButton(
                    onPressed: () async {
                      print("verify OTP clicked");
                      await checkInternetConnection();
                      if (isInternetAvailable) {
                        FocusScope.of(context).unfocus();
                        context.loaderOverlay.show();

                        verifyOtp();
                      }
                    },
                    child: Text("Verify OTP"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
