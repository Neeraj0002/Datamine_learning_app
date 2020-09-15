import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData, uid) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userData)
        .catchError((e) {
      print(e);
    });
  }

  getUserInfo(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .catchError((e) => print(e));
  }

  /*searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }*/

  // ignore: missing_return
  /*Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }*/

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(chatRoomId)
        .collection(chatRoomId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance.collection('users').snapshots();
  }
}
