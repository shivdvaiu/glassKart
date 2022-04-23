import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  

  UserModel(
      {required this.username, required this.email,});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        username: snapshot["username"],
        email: snapshot["email"],
        );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
      
      };
}

