import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final bool  isSecure;
final String address;
  UserModel(
      {required this.username, required this.email,required this.isSecure,required this.address});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        username: snapshot["username"],
        email: snapshot["email"],
        isSecure: snapshot["isSecure"],
        address: snapshot["address"]
        );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "isSecure": isSecure,
      "address":address
      };
}

