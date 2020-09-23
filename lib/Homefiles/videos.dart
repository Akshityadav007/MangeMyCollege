import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmc/services/Helper.dart';
import 'package:mmc/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController = TextEditingController();
  var linkAddController = TextEditingController();
  Database database = Database();
  bool longPressed = false, uploading = false;
  String _phoneNumber = Helper.mynumber, link, title;

  Widget fileList() {
    return StreamBuilder(
        stream: database.getFileList(_phoneNumber, "link"),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.documents.length == 0) {
              return Center(child: Text('No Link Saved'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return fileTile(
                      snapshot.data.documents[index].data['linkAddress'],
                      snapshot.data.documents[index].data['linkTitle']);
                },
              );
            }
          }
        });
  }

  Widget fileTile(String _tileSubtitle, String _tileTitle) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: longPressed
                ? IconButton(
                    icon: Icon(Icons.check_circle),
                    color: Colors.greenAccent,
                    onPressed: () {
                      setState(() {
                        longPressed = false;
                      });
                    },
                  )
                : Icon(Icons.link),
          ),
          title: Text(_tileTitle),
          subtitle: Text(_tileSubtitle),
          onTap: () {
            _launchURL(Uri.encodeFull(_tileSubtitle));
          },
          onLongPress: () {
            setState(() {
              longPressed = true;
            });
          },
          trailing: longPressed
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await database.deleteLinkData(_phoneNumber, _tileTitle);
                    longPressed = false;
                  })
              : Icon(Icons.check_circle_outline, color: Colors.green),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future uploadLinkData(String _link, String _title) async {
    Map<String, dynamic> linkMap = {
      "linkAddress": _link,
      "fileType": "link",
      "linkTitle": _title,
    };
    await database.addLinkData(_phoneNumber, linkMap, _title);
    _showSnack();
    setState(() {
      link = null;
      title = null;
      uploading = false;
      _textEditingController.clear();
      linkAddController.clear();
    });
  }

  _showSnack() {
    final snackBar = new SnackBar(
      content: Text('Link Added Successfully!'),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(),
            title: Text('Add Link Details'),
            content: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: "Enter title",
                      labelText: "Title",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: linkAddController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      hintText: "Enter link",
                      labelText: "Link",
                    ),
                  )
                ],
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
                onPressed: () async {
                  setState(() {
                    link = linkAddController.text;
                    title = _textEditingController.text;
                    uploading = true;
                  });
                  Navigator.pop(context);
                  await uploadLinkData(link, title);
                },
                child: Text("Add Link"),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
            onPressed: () {
              longPressed
                  ? setState(() {
                      longPressed = false;
                    })
                  : Navigator.pop(context);
            }),
      ),
      body: Container(
        height: data.height,
        width: data.width,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: data.width / 35),
              child: Center(
                child: RaisedButton(
                  child: Text('Add Link'),
                  onPressed: () {
                    return showAdd(context);
                  },
                ),
              ),
            ),
            Container(
                child: uploading
                    ? LinearProgressIndicator()
                    : SizedBox(
                        height: 10,
                      )),
            SingleChildScrollView(
              child: fileList(),
            )
          ],
        ),
      ),
    );
  }
}
