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

  addData(String userNumber, String path, downloadLinkMap, String fileType) {
    Firestore.instance
        .collection('users')
        .document(userNumber)
        .collection(fileType)
        .document(path)
        .setData(downloadLinkMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteData(String fileLink,String phoneNumber,String fileType,String fileName) async {
    StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(fileLink);
    await storageReference.delete().then((value) => print('deleted from Storage'));
    await Firestore.instance.collection('users').document(phoneNumber).collection(fileType).document(fileName).delete().whenComplete(() => print('deleted from FireStore'));
  }

  Stream<QuerySnapshot> getFileList(String phoneNumber, String fileType) {
    return Firestore.instance
        .collection("users")
        .document(phoneNumber)
        .collection(fileType)
        .snapshots();
  }
}
