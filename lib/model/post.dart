import 'package:firebase_database/firebase_database.dart';

class Post {
  String _id;
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  String _address;
  String _photoUrl;
  String _postTitle;
  String _postDetails;

  // Constructor for add
  Post(this._firstName, this._lastName, this._phone, this._email, this._address,
      this._photoUrl, this._postTitle, this._postDetails);

  // Constructor for edit
  Post.withId(
      this._id,
      this._firstName,
      this._lastName,
      this._phone,
      this._email,
      this._address,
      this._photoUrl,
      this._postTitle,
      this._postDetails);

  // Getters
  String get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get phone => this._phone;
  String get email => this._email;
  String get address => this._address;
  String get photoUrl => this._photoUrl;
  String get postTitle => this._postTitle;
  String get postDetails => this._postDetails;

  // Setters
  set firstName(String firstName) {
    this._firstName = firstName;
  }

  set lastName(String lastName) {
    this.lastName = lastName;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set email(String email) {
    this._email = email;
  }

  set address(String address) {
    this._address = address;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  set postTitle(String postTitle) {
    this._postTitle = postTitle;
  }

  set postDetails(String postDetails) {
    this._postDetails = postDetails;
  }

  Post.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._phone = snapshot.value['phone'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._photoUrl = snapshot.value['photoUrl'];
    this._postTitle = snapshot.value['postTitle'];
    this._postDetails = snapshot.value['postDetails'];
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
      "postTitle": _postTitle,
      "postDetails": _postDetails
    };
  }
}
