import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:pull_common/pull_common.dart';
import 'package:intl_phone_field/phone_number.dart';

class OTPScreen extends ConsumerStatefulWidget {

  const OTPScreen({Key? key, required this.verificationId, required this.phone}) : super(key: key);
  final String verificationId;
  final PhoneNumber phone;

  @override
  ConsumerState<OTPScreen> createState() => OTPScreenState();
}

class OTPScreenState extends ConsumerState<OTPScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('SMS Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify Phone number',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsRetrieverApi,
              onSubmitted: (pin) async {

                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: widget.verificationId, smsCode: pin))
                      .then((value) async
                  {
                    print(value);
                    if (value.user != null) {
                      try{
                        PullRepository repo = PullRepository(ref.read);
                        await repo.loginRequest(await value.user!.getIdToken(),widget.phone.completeNumber).then((value) => {
                          if(value == true){
                            context.go('/home/cards')
                          } else {
                            context.go('/createProfile/name')
                          }

                        });
                      }catch (e){
                        print("There was an error somewhere in the profile creation.");
                        print(e);
                        return;
                      }

                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                  //.showSnackBar(const SnackBar(content: Text('Code is Wrong')));
                      .showSnackBar( SnackBar(content: Text(e.toString())));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_verifyPhone();
  }

  //i moved this stuff to login because it needs to happen when they enter their phone number.
  // _verifyPhone() async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       //phoneNumber: '+${widget.phone}',
  //
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance
  //             .signInWithCredential(credential)
  //             .then((value) async {
  //           _verifyUser(value);
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //          ScaffoldMessenger.of(context)
  //            .showSnackBar(const SnackBar(content: Text('Verification Failed')));
  //       },
  //       codeSent: (String? verificationID, int? resendToken) {
  //         setState(() {
  //           _verificationCode = verificationID;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationID) {
  //         setState(() {
  //           _verificationCode = verificationID;
  //         });
  //       },
  //       timeout: const Duration(seconds: 120));
  // }

  void _verifyUser(userObject) {
    if (userObject.user != null) {
      context.push('/');
    } else {
      //final authResult = await repository.authenticate(AuthRequest.phone(phoneFieldController.text));

      //context.go('/createProfile/name');

      /* if (!authResult.userExists) {
                          router.go('/createAccount/add_photos');
                          return;
                        }*/
    }
  }
}
