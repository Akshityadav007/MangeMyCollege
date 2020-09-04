import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:mmc/fileViewer.dart';
import 'package:mmc/services/Helper.dart';
import 'package:mmc/services/database.dart';
import 'package:path/path.dart' as path;

class Pdf extends StatefulWidget {
  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  File pdf;
  String downloadUrl,fileName;
  bool uploading = false, longPressed = false;
  Database database = new Database();
  String phoneNumber = Helper.mynumber;

  Widget fileList() {
    return StreamBuilder(
        stream: database.getFileList(phoneNumber, "pdf"),
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
                  database.deleteData(fileDownloadLink,phoneNumber, 'pdf', fileName);
                })
            : Icon(Icons.check_circle_outline, color: Colors.green),
      ),
    );
  }

  Future getFile() async {
    File files = await FilePicker.getFile().catchError((e) {
      Fluttertoast.showToast(msg: 'Oops!Something went wrong.');
    });
    if (await files.exists()){
      fileName = path.basename(files.path);
      print(path.basename(files.path));
    }
    setState(() {
      pdf = files;
    });
  }

  Future uploadFile(File pdfFile) async {
    String _phoneNumber = await Helper.getPhoneNumberSharedPreferences();
    setState(() {
      phoneNumber = _phoneNumber;
    });
    String path = "$phoneNumber/" + "pdf/" + fileName + '.pdf';
    final StorageReference ref = FirebaseStorage.instance.ref().child(path);
    final StorageUploadTask uploadTask = ref.putFile(pdf);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadAddress = await taskSnapshot.ref.getDownloadURL();
    Map<String, dynamic> downloadLinkMap = {
      "fileDownloadLink": downloadAddress,
      "fileType": "pdf",
      "fileName": fileName,
    };

    database.addData(_phoneNumber, fileName, downloadLinkMap, 'pdf');

    setState(() {
      uploading = false;
      pdf = null;
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
        title: Text('PDF Notes'),
        actions: <Widget>[
          Hero(
            tag: 'pdf',
            child: CircleAvatar(
              radius: 24,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/pdf.png',
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
              child: pdf == null
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
                        uploadFile(pdf);
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
