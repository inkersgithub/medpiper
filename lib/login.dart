import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medpiper/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otpCode = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  OutlineInputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 3.0));

  bool isLoading = false;
  bool isOtpRequested = false;

  late String verificationId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login/Signup",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              MyTextFormField(
                label: 'Phone#',
                textEditingController: phoneNumber,
              ),
              const SizedBox(height: 16),
              MyTextFormField(
                label: 'OTP',
                textEditingController: otpCode,
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : ElevatedButton(
                      onPressed: isLoading
                          ? () {}
                          : () async {
                              if (!isOtpRequested) {
                                registerUser(context);
                              } else {
                                if (otpCode.text.trim().isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: otpCode.text.trim());

                                  _auth
                                      .signInWithCredential(credential)
                                      .then((value) {
                                    if (value.user != null) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                    number:
                                                        value.user?.phoneNumber,
                                                    isFromLogin: true,
                                                  )));
                                    }
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  isOtpRequested ? "Proceed" : "Request OTP",
                                  style: const TextStyle(fontSize: 15.0),
                                )),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future registerUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.text.trim(),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((value) {
            if (value.user != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                          number: value.user?.phoneNumber, isFromLogin: true)));
            }
          }).catchError((e) {
            if (kDebugMode) {
              print(e);
            }
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          setState(() {
            isLoading = false;
          });
          if (kDebugMode) {
            print(exception);
          }
        },
        codeSent: (String vId, [int? forceResendingToken]) {
          setState(() {
            isOtpRequested = true;
            isLoading = false;
            verificationId = vId;
          });
        },
        codeAutoRetrievalTimeout: (value) {},
        timeout: const Duration(seconds: 60));
  }
}

class MyTextFormField extends StatelessWidget {
  final String label;
  TextEditingController textEditingController;
  MyTextFormField(
      {Key? key, required this.label, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          labelStyle: const TextStyle(fontSize: 15.0, color: Colors.black),
          floatingLabelStyle:
              const TextStyle(fontSize: 15.0, color: Colors.black),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          )),
      controller: textEditingController,
    );
  }
}
