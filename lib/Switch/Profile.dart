import 'package:flutter/material.dart';
import 'package:mmc/services/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Manage My College'),
        elevation: 5.0,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.clear();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
          )
        ],
      ),
      body: Container(
        height: data.size.height,
        width: data.size.width,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: data.size.height / 3,
                child: Center(
                  child: Text("Your pic"),
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                height: 50,
                width: 200,
                child: Card(
                  elevation: 2,
                  child: Align(
                    child: Text('Your Number : ${Helper.mynumber}'),
                  ),
                  shape: StadiumBorder(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
