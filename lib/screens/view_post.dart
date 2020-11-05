import 'package:eShopV2/model/post.dart';
import 'package:eShopV2/screens/contact_details.dart';
import 'package:eShopV2/screens/edit_post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPost extends StatefulWidget {
  final String id;
  ViewPost(this.id);
  @override
  _ViewPostState createState() => _ViewPostState(id);
}

class _ViewPostState extends State<ViewPost> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String id;
  _ViewPostState(this.id);
  Post _post;
  bool isLoading = true;

  getPost(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _post = Post.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.getPost(id);
  }

  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call $number';
    }
  }

  smsAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send sms to $number';
    }
  }

  deletePost() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.lime.shade200,
            title: Text("Delete?"),
            content: Text("Delete Post?"),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                color: Colors.black,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _databaseReference.child(id).remove();
                  navigateToLastScreen();
                },
              ),
            ],
          );
        });
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPost(id);
    }));
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_post.postTitle),
      ),
      backgroundColor: Colors.lime.shade700,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  Container(
                      height: 200.0,
                      child: Image(
                        //
                        image: _post.photoUrl == "empty"
                            ? AssetImage("assets/logo.png")
                            : NetworkImage(_post.photoUrl),
                        fit: BoxFit.contain,
                      )),
                  //name
                  Card(
                    color: Colors.lime.shade200,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                iconSize: 30.0,
                                icon: Icon(Icons.perm_identity_outlined),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ContactDetails(this.id);
                                      },
                                    ),
                                  );
                                }),
                            Container(
                              width: 10.0,
                            ),
                            SizedBox(
                              child: Text(
                                "${_post.firstName} ${_post.lastName}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ],
                        )),
                  ),
                  //post details
                  Card(
                    color: Colors.lime.shade200,
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Flexible(
                          child: Container(
                            height: 300,
                            child: Text(
                              _post.postDetails,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
      ),
    );
  }
}
