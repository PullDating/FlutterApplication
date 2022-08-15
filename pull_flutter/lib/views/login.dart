import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pull_common/pull_common.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});

  PhoneNumber? phoneNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    _login() async {
      try {
        print("entered onpressed for login");
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber!.completeNumber,
            verificationCompleted: (PhoneAuthCredential credential) async {
              print("Attempting android only auto SMS");
              //ANDROID ONLY
              await FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
                context.go('home/cards')
              });
            },

            verificationFailed: (FirebaseAuthException e) {
              print("There was some sort of verification error with firebase");
              if(e.code == 'invalid-phone-number') {
                print("the phone number format was invalid.");
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Invalid phone number.')));
              } else {
                print(e.toString());
              }

              //TODO handle other errors
            },

            codeSent: (String verificationId, int? resendToken) {
              print("A verification code was sent. ");
              //pass on the verification id to the next screen
              context.go('/login/sms/${verificationId.toString()}');
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              //Auto Resolution Timed Out...
            }
        );
      } catch (e, s) {
        print("Some other error occured during the login screen");
        print(s);
      }
      //this is not how we're doing navigation.
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => OTPScreen(phoneFieldController.text, '/home/cards'))
      // );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/decorations/loginbackground.png"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 36.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Pull",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    width: 250,
                    child: IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        phoneNumber = phone;
                      },
                    )
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 25)),
                  ElevatedButton(
                      onPressed: () async {
                        print("onPress pressed.");
                        //Check to make sure that the person's phone number is valid
                        if(phoneNumber != null){
                          _login();
                        } else {
                          print("phone number was null.");
                        }
                      },
                      child: const Text("Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


