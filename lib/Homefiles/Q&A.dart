import 'package:mmc/Switch/user.dart';
import 'package:flutter/material.dart';

class discussion extends StatefulWidget {
  @override
  _discussionState createState() => _discussionState();
}

class _discussionState extends State<discussion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussions'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Hero(
            tag: 'Q&A',
            child: CircleAvatar(
              radius: 25,
              child: Image.asset(
                'assets/images/Q&A.png',
                fit: BoxFit.cover,
              ),
              backgroundColor: Color(0xffDAF7A6),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
          child:  Center(
              child: Text('Under Construction'),
            ),
      ),
    );
  }
}
