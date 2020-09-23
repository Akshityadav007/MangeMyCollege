import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  uploadUserInfo(user, userMap) {
    Firestore.instance
        .collection('users')
        .document(user)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addData(
      String userNumber, String path, downloadLinkMap, String fileType) async {
    await Firestore.instance
        .collection('users')
        .document(userNumber)
        .collection(fileType)
        .document(path)
        .setData(downloadLinkMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addLinkData(String userNumber, linkMap, String title) async {
    await Firestore.instance
        .collection('users')
        .document(userNumber)
        .collection('link')
        .document(title)
        .setData(linkMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addAttendanceData(String userNumber, attendanceMap) async {
    await Firestore.instance
        .collection('users')
        .document(userNumber)
        .collection('attendance')
        .document(userNumber + 'attendance')
        .setData(attendanceMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getAttendanceData(String userNumber) {
    Firestore.instance
        .collection('users')
        .document(userNumber)
        .collection('attendance')
        .document(userNumber + 'attendance')
        .snapshots();
  }

  deleteLinkData(String phoneNumber, String fileName) async {
    await Firestore.instance
        .collection('users')
        .document(phoneNumber)
        .collection('link')
        .document(fileName)
        .delete()
        .whenComplete(() => print('deleted from FireStore'));
  }

  deleteData(String fileLink, String phoneNumber, String fileType,
      String fileName) async {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(fileLink);
    await storageReference
        .delete()
        .then((value) => print('deleted from Storage'));
    await Firestore.instance
        .collection('users')
        .document(phoneNumber)
        .collection(fileType)
        .document(fileName)
        .delete()
        .whenComplete(() => print('deleted from FireStore'));
  }

  addMessage(messageMap) async {
    await Firestore.instance
        .collection('chatRoom')
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getChatList() {
    return Firestore.instance
        .collection('chatRoom')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getFileList(String phoneNumber, String fileType) {
    return Firestore.instance
        .collection("users")
        .document(phoneNumber)
        .collection(fileType)
        .snapshots();
  }
}
