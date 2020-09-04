import 'package:mmc/Homefiles/Q&A.dart';
import 'package:mmc/Homefiles/books.dart';
import 'package:mmc/Homefiles/videos.dart';
import 'package:flutter/material.dart';
import 'attendance.dart';
import 'notes.dart';
import 'pdf.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Manage My College'),
        elevation: 5.0,
      ),
      body: Container(
        height: data.size.height,
        width: data.size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      onPressed: () {
                        print("notes");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Notes()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 5, left: 5),
                        child: Hero(
                          tag: 'notes',
                          child: Image.asset(
                            'assets/images/notes.png',
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          print("pdf");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pdf()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, right: 5),
                          child: Hero(
                            tag: 'pdf',
                            child: Image.asset(
                              'assets/images/pdf.png',
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 5, left: 5.0),
                        child: FlatButton(
                          onPressed: () {
                            print("book");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Books()));
                          },
                          child: Hero(
                            tag: 'books',
                            child: Image.asset(
                              'assets/images/book.png',
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, right: 5),
                          child: FlatButton(
                            onPressed: () {
                              print("attendance");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Attendance()));
                            },
                            child: Hero(
                              tag: 'mark',
                              child: Image.asset(
                                'assets/images/attendance.png',
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 5, left: 5),
                        child: FlatButton(
                          onPressed: () {
                            print("Q&A");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => discussion()));
                          },
                          child: Hero(
                            tag: 'Q&A',
                            child: Image.asset(
                              'assets/images/Q&A.png',
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, right: 5),
                          child: FlatButton(
                            onPressed: () {
                              print("videos");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Videos()));
                            },
                            child: Hero(
                              tag: 'videos',
                              child: Image.asset(
                                'assets/images/videos.jpg',
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
