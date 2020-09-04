import 'package:mmc/Switch/user.dart';
import 'package:mmc/phoneloginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MMC",
      theme: ThemeData(primarySwatch: Colors.green, primaryColor: Colors.green),
      home: HomePageLogin(),
    );
  }
}

class HomePageLogin extends StatefulWidget {
  @override
  _HomePageLoginState createState() => _HomePageLoginState();
}

class _HomePageLoginState extends State<HomePageLogin> {
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') == true) {
      print(prefs.getBool('isLoggedIn'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserPage()));
    }
  }

  loginWithGoogle() async {
    await GoogleSignIn().signIn().then(
      (user) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString("name", user.displayName);
        _prefs.setString("email", user.displayName);
        _prefs.setString("profile", user.photoUrl);
        _prefs.setString("userId", user.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(),
          ),
        );
      },
    ).catchError(
      (e) {
        print(
          e.toString(),
        );
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Oops! Something went wrong.'),
          ),
        );
      },
    );
  }

// login with phone number below

  Widget build(BuildContext context) {
    final data = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: data.height,
        width: data.width,
        child: Center(
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
                  height: 240,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 20),
                          Icon(Icons.phone_android,
                              size: 40, color: Colors.black45),
                          SizedBox(width: 15),
                          MaterialButton(
                            highlightElevation: 10.0,
                            minWidth: 200.0,
                            height: 45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneLogin(),
                              ),
                            ),
                            elevation: 5.0,
                            color: Colors.red,
                            child: Text(
                              "Login with Phone Number",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 20),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: 40,
                            width: 40,
                            alignment: Alignment.bottomLeft,
                            child: Image.asset('assets/images/GoogleIcon.ico'),
                          ),
                          SizedBox(width: 15),
                          MaterialButton(
                            highlightElevation: 10.0,
                            minWidth: 200.0,
                            height: 45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            onPressed: loginWithGoogle,
                            elevation: 5.0,
                            color: Colors.red,
                            child: Text(
                              "Sign In with google",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      FlatButton(padding: EdgeInsets.only(left: 40),
                        child: Text('Forgot Password?'),
                        onPressed: () => print(
                            "Tapped forgot password"), // TODO add function to the forgot password button
                        //color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
