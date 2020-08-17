import 'package:chaton/helper/authentication.dart';
import 'package:chaton/helper/constants.dart';
import 'package:chaton/helper/helperfunctions.dart';
import 'package:chaton/services/auth.dart';
import 'package:chaton/services/database.dart';
import 'package:chaton/views/conversation_screen.dart';
import 'package:chaton/views/search.dart';
import 'package:chaton/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget ChatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    snapshot.data.documents[index].data["chatroomId"],
                    // .toString()
                    // .replaceAll("_", "")
                    // .replaceAll(Constants.myName, ""),
                    snapshot.data.documents[index].data["chatroomId"],
                  );
                },
              )
            : Container(
                child: Text(
                  "NO chat started",
                  style: mediumTextstyle(),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
        print(
            "we got the data + ${chatRoomsStream.toString()} this is name  ${Constants.myName} ");
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: Container(child: ChatRoomList()),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatroomId;
  ChatRoomTile(this.userName, this.chatroomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatroomId)));
      },
      child: Container(
        color: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: mediumTextstyle(),
              ),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: mediumTextstyle(),
            ),
          ],
        ),
      ),
    );
  }
}
