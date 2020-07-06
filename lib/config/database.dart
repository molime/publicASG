import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:verdulera_app/models/shopping_cart.dart';
import 'dart:async';
import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/client.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/provider.dart';

class DatabaseService extends ChangeNotifier {
  final Firestore _db = Firestore.instance;
  bool isLoggedIn = false;

  void logIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logOut() {
    isLoggedIn = false;
    notifyListeners();
  }

  bool isLoggedInUser() {
    return isLoggedIn;
  }

  /// Query a subcollection
  Stream<List<CategoryElement>> streamCategories() {
    var ref = _db.collection('categories').where('status', isEqualTo: 'active');
    /*Stream<List<CategoryElement>> streamCategory;
    auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        streamCategory = ref.snapshots().map((list) => list.documents
            .map((doc) => CategoryElement.fromDocument(doc: doc))
            .toList());
      } else {
        streamCategory = null;
      }
    });*/
    //return streamCategory;
    return ref.snapshots().map((list) => list.documents
        .map((doc) => CategoryElement.fromDocument(doc: doc))
        .toList());
  }

  Stream<List<ProductElement>> streamProducts() {
    var ref = _db.collection('product').where('status', isEqualTo: 'active');

    return ref.snapshots().map((list) => list.documents
        .map((doc) => ProductElement.fromDocument(doc: doc))
        .toList());
  }

//TODO: delete function below
  Stream<List<Client>> streamClients() {
    var ref = _db
        .collection('user')
        .where('type', isEqualTo: 'buyer')
        .where('status', isEqualTo: 'active');
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Client().clientForStream(
              doc: doc,
            ))
        .toList());
  }

  Stream<List<ProviderUser>> streamProviders() {
    var ref = _db
        .collection('user')
        .where('type', isEqualTo: 'provider')
        .where('status', isEqualTo: 'active');
    return ref.snapshots().map((list) => list.documents
        .map((doc) => ProviderUser.fromDocument(doc: doc))
        .toList());
  }

  Stream<List<Order>> streamOrders() {
    var ref = _db.collection('order').orderBy('deliverDate', descending: false);
    return ref.snapshots().map((list) => list.documents
        .map((doc) => Order.forStream(
              doc: doc,
            ))
        .toList());
  }

  Stream<List<ShoppingCart>> streamCanastas() {
    var ref = _db.collection('canastas');
    return ref.snapshots().map((list) => list.documents
        .map((doc) => ShoppingCart.forStream(
              doc: doc,
            ))
        .toList());
  }
}
