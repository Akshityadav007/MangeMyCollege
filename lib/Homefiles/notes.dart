import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mmc/services/Helper.dart';
import 'package:mmc/services/database.dart';
import 'package:uuid/uuid.dart';
import '../fileViewer.dart';
import 'package:path/path.dart' as path;

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {

  File notes;
  String downloadUrl;
  bool uploading = false,longPressed = false;
  Database database = new Database();
  String phoneNumber = Helper.mynumber,fileName;

  Widget fileList() {
    return StreamBuilder(
        stream: database.getFileList(phoneNumber, "notes"),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data.documents.length == 0) {
              return Center(child: Text('No Files'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return fileTile(
                      snapshot.data.documents[index].data['fileDownloadLink'],
                      snapshot.data.documents[index].data['fileName']);
                },
              );
            }
          }
        });
  }

  Widget fileTile(String fileDownloadLink, String fileName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
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
              : Icon(Icons.insert_drive_file),
        ),
        title: Text(fileName),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileView(fileURL: fileDownloadLink),
            ),
          );
        },
        onLongPress: () {
          setState(() {
            longPressed = true;
          });
        },
        trailing: longPressed
            ? IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              database.deleteData(fileDownloadLink,phoneNumber, 'notes', fileName);
            })
            : Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }



  Future getFile() async {
    File files = await FilePicker.getFile().catchError((e) {
      Fluttertoast.showToast(msg: 'Oops!Something went wrong.'); //TODO: check toast
    });
    if (await files.exists()){
      fileName = path.basename(files.path);
      print(path.basename(files.path));
    }
    setState(() {
      notes = files;
    });
  }

  Future uploadFile(File notes) async {
    String _phoneNumber = await Helper.getPhoneNumberSharedPreferences();
    setState(() {
      phoneNumber = _phoneNumber;
    });
    String path = "$phoneNumber/" + "notes/" + fileName + '.pdf';

    final StorageReference ref = FirebaseStorage.instance.ref().child(path);
    final StorageUploadTask uploadTask = ref.putFile(notes);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadAddress = await taskSnapshot.ref.getDownloadURL();
    Map<String, dynamic> downloadLinkMap = {
      "fileDownloadLink": downloadAddress,
      "fileType": "notes",
      "fileName": fileName,
    };

    database.addData(_phoneNumber, fileName, downloadLinkMap, 'notes');
    setState(() {
      uploading = false;
      notes = null;
      path = null;
      fileName = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              longPressed
                  ? setState(() {
                longPressed = false;
              })
                  : Navigator.pop(context);
            },
        ),
        centerTitle: true,
        title: Text('Notes'),
        actions: <Widget>[
          Hero(
            tag: 'notes',
            child: CircleAvatar(
              radius: 25,
              child: Image.asset(
                'assets/images/notes.png',
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: notes == null
                  ? RaisedButton(
                onPressed: getFile,
                child: Text('Select File'),
              )
                  : RaisedButton(
                child: Text('Upload File'),
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile(notes);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  uploading
                      ? LinearProgressIndicator()
                      : SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(child: fileList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
