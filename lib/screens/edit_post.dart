import 'package:eShopV2/model/post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditPost extends StatefulWidget {
  final String id;
  EditPost(this.id);
  @override
  _EditPostState createState() => _EditPostState(id);
}

class _EditPostState extends State<EditPost> {
  String id;
  _EditPostState(this.id);

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _address = '';
  String _email = '';
  String _photoUrl;
  String _postTitle;
  String _postDetails;

  // handle text editing controller

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  bool isLoading = true;

  // firebase/db helper
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // get Post from firebase
    this.getPost(id);
  }

  getPost(id) async {
    Post post;
    _databaseReference.child(id).onValue.listen((event) {
      post = Post.fromSnapshot(event.snapshot);

      _fnController.text = post.firstName;
      _lnController.text = post.lastName;
      _poController.text = post.phone;
      _emController.text = post.email;
      _adController.text = post.address;
      _titleController.text = post.postTitle;
      _detailsController.text = post.postDetails;

      setState(() {
        _firstName = post.firstName;
        _lastName = post.lastName;
        _phone = post.phone;
        _email = post.email;
        _address = post.address;
        _photoUrl = post.photoUrl;
        _postTitle = post.postTitle;
        _postDetails = post.postDetails;
        isLoading = false;
      });
    });
  }

  // update Post
  updatePost(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _phone.isNotEmpty &&
        _postTitle.isNotEmpty &&
        _postDetails.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Post post = Post.withId(
          this.id,
          this._firstName,
          this._lastName,
          this._postTitle,
          this._postDetails,
          this._phone,
          this._email,
          this._address,
          this._photoUrl);
      await _databaseReference.child(id).set(post.toJson());
      navigateToLastScreen(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Field Required'),
            content: Text('All fields are required'),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // pick image

  Future pickImage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );

    File file = File(pickedFile.path);

    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  // upload image
  void uploadImage(File file, String fileName) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);

    storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();

      setState(() {
        _photoUrl = downloadUrl;
        print(downloadUrl);
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.lime.shade200,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("assets/logo.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _postTitle = value;
                          });
                        },
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Post Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _postDetails = value;
                          });
                        },
                        controller: _detailsController,
                        decoration: InputDecoration(
                          labelText: 'Post Details',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updatePost(context);
                        },
                        color: Colors.black,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
