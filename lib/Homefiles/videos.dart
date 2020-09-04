import 'package:flutter/material.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        centerTitle: true,
        actions: <Widget>[
          Hero(
            tag: 'videos',
            child: CircleAvatar(
              radius: 24,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/videos.jpg',
                  fit: BoxFit.cover,
                  height: 40,
                ),
              ),
              backgroundColor: Color(0xffDAF7A6),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Center(
          child: Text('Under Construction'),
        ),
      ),
    );
  }
}
