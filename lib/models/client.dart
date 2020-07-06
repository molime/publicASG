import 'package:flutter/cupertino.dart';
import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verdulera_app/models/product.dart';

final usersRef = Firestore.instance.collection('user').where({'type': 'buyer'});

class Client {
  final String uid;
  final String email;
  final String customerId;
  final String displayName;
  List<ShoppingCart> shoppingCart = [];
  List<Order> orderList;
  String type;

  Client({
    this.uid,
    this.email,
    this.customerId,
    this.displayName,
    this.shoppingCart,
    this.type,
    this.orderList,
  });

  Client clientForStream ({DocumentSnapshot doc}) {
    Client client = Client.fromDocument(doc: doc);

    getCartsStream(client: client);

    getOrdersStream(client: client);

    return client;
  }

  factory Client.fromDocument({DocumentSnapshot doc}) {
    return Client(
      uid: doc.documentID != null ? doc.documentID : null,
      email: doc.data['email'] != null ? doc.data['email'] : null,
      customerId:
      doc.data['customerId'] != null ? doc.data['customerId'] : null,
      displayName:
      doc.data['displayName'] != null ? doc.data['displayName'] : null,
      shoppingCart: [],
      type: doc.data['type'] != null ? doc.data['type'] : null,
      orderList: [],
    );
  }

  void getOrdersStream({Client client}) async {
    Query ordersRef = Firestore.instance
        .collection('order')
        .where('client', isEqualTo: client.uid);
    QuerySnapshot clientOrders = await ordersRef.getDocuments();
    if (clientOrders.documents.length > 0) {
      for (DocumentSnapshot doc in clientOrders.documents) {
        Order order = Order.forStream(
          doc: doc,
        );
        client.orderList.add(order);
      }
    } else {
      client.orderList = [];
    }
  }

  void getCartsStream ({Client client}) async {
    CollectionReference cartsRef = Firestore.instance
        .collection('user')
        .document(client.uid)
        .collection('shoppingCarts');
    QuerySnapshot clientCarts = await cartsRef.getDocuments();
    if (clientCarts.documents.length > 0) {
      for (DocumentSnapshot doc in clientCarts.documents) {
        client.shoppingCart.add(
          ShoppingCart.forStream(
            doc: doc,
          ),
        );
      }
    } else {
      client.shoppingCart = [];
    }
  }

  void completeClient ({List<ProductElement> products, @required BuildContext context}) {
    for (Order order in orderList) {
      order.completeOrder(productElements: products, context: context,);
    }
    for (ShoppingCart shoppingCart in shoppingCart) {
      shoppingCart.completeShoppingCart(productElements: products, context: context,);
    }
  }
}
