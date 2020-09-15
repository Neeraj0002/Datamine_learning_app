import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/ChatUser.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Screens/ChatScreen2.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(snapshot.data.documents[index].data()['nickname']);
                  return snapshot.data.documents[index].id !=
                          Constants.firebaseId
                      ? ChatRoomsTile(
                          userName:
                              snapshot.data.documents[index].data()['nickname'],
                          chatRoomId: snapshot.data.documents[index].id,
                        )
                      : Container();
                })
            : Container();
      },
    );
  }

  setCurrentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.firebaseId = prefs.getString("firebaseId");
  }

  @override
  void initState() {
    setCurrentId();
    Constants.myName = "Admin";
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColorlight,
        title: Text("Admin Datamine"),
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if (Constants.email == "admin.torc@gmail.com") {
            return ChatAdmin(
              chatRoomId: chatRoomId,
              name: userName,
            );
          } else {
            return ChatUser(
              name: userName,
            );
          }
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: appBarColorlight,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(userName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: appBarColorlight,
                          fontSize: 14,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(userName,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
