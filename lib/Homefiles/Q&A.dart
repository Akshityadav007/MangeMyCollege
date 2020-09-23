import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmc/services/Helper.dart';
import 'package:mmc/services/database.dart';

class Discussion extends StatefulWidget {
  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController _chatTextController = TextEditingController();
  Database database = Database();

  Widget chatMessages() {
    return Container(
        padding: EdgeInsets.only(bottom: 60),
        child: StreamBuilder(
            stream: database.getChatList(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  strokeWidth: 1.5,
                );
              } else {
                if (snapshot.data.documents.length == 0) {
                  return Center(child: Text('No Messages'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return messageTile(
                          snapshot.data.documents[index].data['message'],
                          snapshot.data.documents[index].data['sendBy']);
                    },
                  );
                }
              }
            }));
  }

  Widget messageTile(String message, String number) {
    return Container(
      padding: EdgeInsets.only(
          left: number == Helper.mynumber ? 0 : 5,
          right: number == Helper.mynumber ? 10 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: number == Helper.mynumber
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: number == Helper.mynumber
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        color:
            number == Helper.mynumber ? Colors.yellow[50] : Colors.green[200],
        child: Stack(
          children: <Widget>[
            Positioned(
              top: number != Helper.mynumber ? 0 : null,
              bottom: number == Helper.mynumber ? 0 : null,
              right: number == Helper.mynumber ? 0 : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: number == "1234567890"
                    ? Text(
                        'Admin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    : Text(
                        "+91$number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
              ),
            ),
            Container(
              width: 200,
              padding: EdgeInsets.only(
                top: number != Helper.mynumber ? 20 : 10,
                right: number != Helper.mynumber ? 0 : 20,
                left: number == Helper.mynumber ? 12 : 40,
                bottom: number == Helper.mynumber ? 20 : 10,
              ),
              child: Text(
                message,
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(String _message) {
    if (_message.isNotEmpty) {
      Map<String, dynamic> _messageMap = {
        'message': _message,
        'sendBy': Helper.mynumber,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      database.addMessage(_messageMap);
      setState(() {
        _message = null;
        _chatTextController.clear();
      });
    } else if (_message.isEmpty || _chatTextController.text.isEmpty) {
      _showSnack();
    } else {
      _showErrorSnack();
    }
  }

  _showSnack() {
    final snackbar = new SnackBar(
      content: Text('Please Type Something'),
      duration: Duration(seconds: 1),
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  _showErrorSnack() {
    final snackbar = new SnackBar(
      content: Text('Oops! Something went wrong'),
      duration: Duration(seconds: 2),
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
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
        color: Colors.green[50],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 12,
                child: Row(
                  children: [
                    Card(
                      shape: StadiumBorder(),
                      elevation: 2,
                      child: Container(
                        height: 50,
                        width: 290,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  controller: _chatTextController,
                                  autofocus: true,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: 'Type Something..'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.green,
                      shape: CircleBorder(),
                      elevation: 2,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          sendMessage(_chatTextController.text);
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                        ),
                      ),
                    )
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
