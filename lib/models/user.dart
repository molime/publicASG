import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = Firestore.instance.collection('user');

class User {
  final String uid;
  final String email;
  String displayName;

  User({
    this.uid,
    this.email,
    this.displayName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc.documentID,
      email: doc.data['email'],
      displayName: doc.data['displayName'],
    );
  }

  void changeDisplayName({String newName}) async {
    await usersRef.document(uid).updateData(
      {
        'displayName': newName,
      },
    );
    displayName = newName;
  }
}
