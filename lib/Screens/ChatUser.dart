import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Components/widget.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatUser extends StatefulWidget {
  final String name;
  ChatUser({@required this.name});

  @override
  _ChatUserState createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  //Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  String groupChatId;
  String peerId = "dN4ypivFyXQwT1Dkd4zVkkVDtm52";
  Widget chatMessages() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? LayoutBuilder(builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight - 85,
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          message:
                              snapshot.data.documents[index].data()['content'],
                          sendByMe: Constants.firebaseId ==
                              snapshot.data.documents[index].data()['idFrom'],
                        );
                      }),
                );
              })
            : Container();
      },
    );
  }

  setChatTo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("firebaseId") ?? '';
    Constants.firebaseId = id;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});
    setState(() {
      print("running 1");
    });
  }

  addMessage(String message) {
    if (messageEditingController.text.isNotEmpty) {
      /*Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };*/
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': Constants.firebaseId,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': message,
          },
        );
      });

      setState(() {
        print("running 2");
        messageEditingController.clear();
      });
    } else {
      Fluttertoast.showToast(
          msg: "Nothing to send",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    groupChatId = '';
    setChatTo();

    /*DatabaseMethods().getChats(peerId).then((val) {
      setState(() {
        print("running 3");
        chats = val;
      });
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColorlight,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Chat"),
      ),
      body: Container(
        child: Stack(
          children: [
            groupChatId != '' ? chatMessages() : Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: appBarColorlight,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: messageEditingController,
                          style: simpleTextStyle(),
                          cursorColor: appbarTextColorLight,
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: appBarColorlight,
                      onPressed: () {
                        addMessage(messageEditingController.text);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))
                : BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
            color: sendByMe ? appBarColorlight : Colors.black),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
