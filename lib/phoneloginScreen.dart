import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mmc/Switch/user.dart';
import 'package:mmc/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  Database database = new Database();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber;
  var myPhoneController = TextEditingController();
  var otpControllar = TextEditingController();
  var status;
  String verifiedSmsCode;
  String verId;

  // number login

  showOtpDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text("Verify OTP"),
            content: TextField(
              controller: otpControllar,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                hintText: "Enter OTP",
                labelText: "OTP",
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              FlatButton(
                onPressed: () {
                  _onFormSubmitted(context);
                },
                child: Text("Verify OTP"),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ],
          );
        });
  }

  Future<FirebaseUser> _signInWithNumber() async {
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", false);
      print(authException.message);
    };

    final PhoneCodeAutoRetrievalTimeout onCodeTimeOut =
        (String verificationId) {
      setState(() {
        this.verId = verificationId;
      });
      print("TimeOut");
    };
    final PhoneCodeSent onCodeSent =
        (String verificationId, [int forceResendingToken]) {
      setState(() {
        this.verId = verificationId;
      });
      print("Code Sent");
      showOtpDialog(context);
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      _auth.signInWithCredential(auth).then((AuthResult value) async {
        if (value.user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
          prefs.setString("phoneNumber", myPhoneController.text);
          print('this is no. : ${myPhoneController.text}');
          otpControllar.clear();
          myPhoneController.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserPage()),
          );
        }
      });
    };

    _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeTimeOut);
  }

  void _onFormSubmitted(BuildContext context) async {
    print('Verify the Phone');
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: otpControllar.text);
    _auth.signInWithCredential(_authCredential).then((AuthResult value) async {
      if (value.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("phoneNumber", myPhoneController.text);
        String userInfo = myPhoneController.text;
        Map<String, String> userMap = {
          "phoneNumber": myPhoneController.text,
        };
        database.uploadUserInfo(userInfo, userMap);

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: data.size.height,
        width: data.size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'assets/images/books.jpg',
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.fitHeight,
            ),
            SingleChildScrollView(
              child: Container(
                height: 230,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: TextField(
                        controller: myPhoneController,
                        onChanged: (value) {
                          this.phoneNumber = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          hintText: "Phone Number",
                          labelText: "Enter your phone number",
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      child: MaterialButton(
                        highlightElevation: 10.0,
                        minWidth: 150.0,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        onPressed: _signInWithNumber,
                        elevation: 5.0,
                        color: Colors.red,
                        child: Text(
                          "Verify and Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
