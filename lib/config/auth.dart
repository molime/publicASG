import 'package:firebase_auth/firebase_auth.dart';
import 'package:verdulera_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

Future<Map> signIn ({String email, String password, BuildContext context}) async {
  try {
    final user = await auth.signInWithEmailAndPassword(email: email, password: password);
    Map response = await getUserDatabase(uid: user.user.uid, context: context);
    return response;
  } catch (err) {
    return {'result': 'error', 'message': 'No se encontró un usuario registrado con la información proporcionada'};
  }
}

Future<Map> getUserDatabase ({String uid, BuildContext context}) async {
  final DocumentSnapshot user = await _db.collection('user').document(uid).get();
  if (user != null) {
    final User userDoc = User.fromDocument(user);
    if (user.data['type'] != 'admin') {
      auth.signOut();
      return {'result': 'error', 'message': 'No tienes permitido usar esta aplicación.'};
    }
    Provider.of<UserData>(context, listen: false).setUser(user: userDoc);
    return {'result': 'success', 'userDoc': userDoc};
  } else {
    auth.signOut();
    return {'result': 'error', 'message': 'No se encontró un usuario registrado con la información proporcionada'};
  }
}

Future<User> silentSignIn ({FirebaseUser fireUser, BuildContext context}) async {
  if (fireUser == null) {
    return null;
  }
  final DocumentSnapshot userDatabase = await _db.collection('user').document(fireUser.uid).get();

  if (userDatabase != null) {
    final User userDoc = User.fromDocument(userDatabase);
    if (userDatabase.data['type'] != 'admin') {
      auth.signOut();
      return null;
    }
    return userDoc;
  } else {
    auth.signOut();
    return null;
  }
}