import 'package:flutter/material.dart';
import 'add_post.dart';
import 'view_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPost();
    }));
  }

  navigateToViewScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewPost(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddScreen,
          )
        ],
        title: Center(child: Text("eShop")),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.lime.shade700,
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return GestureDetector(
              onTap: () {
                navigateToViewScreen(snapshot.key);
              },
              child: Card(
                color: Colors.lime.shade200,
                elevation: 4.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: snapshot.value['photoUrl'] == "empty"
                                ? AssetImage('assets/logo.png')
                                : NetworkImage(
                                    snapshot.value['photoUrl'],
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${snapshot.value['postTitle']}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${snapshot.value['firstName']} ${snapshot.value['lastName']}",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "${snapshot.value['phone']}",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
