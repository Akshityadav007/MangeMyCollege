import 'package:flutter/material.dart';

class Batch extends StatefulWidget {
  @override
  _BatchState createState() => _BatchState();
}

class _BatchState extends State<Batch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Manage My College'),
        elevation: 5.0,
      ),
      body: Container(
        child: Center(
          child: Text('Your Batch'),
        ),
      ),
    );
  }
}
