import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {

  final DocumentSnapshot to;

  NotificationScreen({
    @required this.to,
  });

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  TextEditingController _messageController = TextEditingController();

  Firestore db = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() { 
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    FirebaseUser u = await auth.currentUser();
    setState(() {
      user = u;
    });
  }

  handleInput(String input) {
    print(input);

    db.collection("users").document(widget.to.documentID)
    .collection("notifications").add({
      "message": input,
      "title": user.email,
      "date": FieldValue.serverTimestamp()
    }).then((doc){
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.to.data["email"]),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Write message here",
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: handleInput(_messageController.text),
                ),
              ),
              FloatingActionButton(
                onPressed: (){
                  handleInput(_messageController.text);
                },
                child: Icon(
                  Icons.send
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}