import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:verdulera_app/models/product_cart.dart';
import 'package:verdulera_app/models/product.dart';

final shoppingCartRef = Firestore.instance.collection('shoppingCarts');

class ShoppingCart {
  List<ProductCart> shoppingCart = [];
  String owner;
  double total;
  int numItems;
  final String name;
  bool fromDatabase = false;
  final String uid;
  bool hasChanged;
  double costo;
  double utilidad;

  ShoppingCart({
    this.owner,
    this.total,
    this.shoppingCart,
    this.numItems,
    this.fromDatabase,
    this.name,
    this.uid,
    this.hasChanged,
    this.costo,
    this.utilidad,
  });

  factory ShoppingCart.forStream ({DocumentSnapshot doc}) {
    ShoppingCart newShoppingCart = ShoppingCart(
      owner: doc.data['owner'] != null ? doc.data['owner'] : null,
      total: 0,
      numItems: doc.data['productCount'] != null ? doc.data['productCount'] : null,
      shoppingCart: [],
      fromDatabase: true,
      name: doc.data['name'] != null ? doc.data['name'] : null,
      uid: doc.documentID,
      hasChanged: false,
      costo: 0,
      utilidad: 0,
    );

    if (doc.data['products'] != null) {
      for (dynamic docLoop in doc.data['products']) {
        final ProductCart productCartLoop =
        ProductCart.plain(
          productUid: docLoop['productUid'],
          numAdded: docLoop['numAdded'],
        );
        newShoppingCart.addProductSimple(productCart: productCartLoop);
      }
    }

    return newShoppingCart;
  }

  void plusOne({ProductCart productCart}) {
    productCart.addNum();
    numItems++;
    total += productCart.price;
    costo += productCart.costo;
    utilidad += productCart.price - productCart.costo;
  }

  void minusOne({ProductCart productCart}) {
    productCart.subtractNum();
    numItems--;
    total -= productCart.price;
    costo -= productCart.costo;
    utilidad -= productCart.price - productCart.costo;
  }

  void addProduct({ProductCart productCart}) {
    shoppingCart.add(productCart);
    numItems++;
    total += productCart.price;
    costo += productCart.costo;
    utilidad += productCart.price - productCart.costo;
  }

  void removeProduct({ProductCart productCart}) {
    shoppingCart.remove(productCart);
    numItems--;
    total -= productCart.price;
    costo -= productCart.costo;
    utilidad -= productCart.price - productCart.costo;
  }

  void resetCartOwner({String newOwner}) {
    shoppingCart.clear();
    owner = newOwner;
    total = 0;
    numItems = 0;
    costo = 0;
    utilidad = 0;
  }

  void addProductSimple ({ProductCart productCart}) {
    shoppingCart.add(productCart);
  }

  factory ShoppingCart.fromSelecting({String owner}) {
    return ShoppingCart(
      owner: owner,
      total: 0.0,
      numItems: 0,
      shoppingCart: [],
      uid: null,
      costo: 0.0,
      utilidad: 0.0,
    );
  }

  factory ShoppingCart.addCanasta() {
    return ShoppingCart(
      total: 0,
      numItems: 0,
      shoppingCart: [],
      costo: 0,
      utilidad: 0,
    );
  }

  void addOwner ({String ownerUid}) {
    owner = ownerUid;
  }

  void completeShoppingCart ({@required BuildContext context, List<ProductElement> productElements}) {
    if (total == 0 && costo == 0 && utilidad == 0) {
      for (ProductCart productCart in shoppingCart) {
        final ProductElement productElement = Provider.of<List<ProductElement>>(context, listen: false).firstWhere((element) => element.uid == productCart.uid);
        productCart.completeProduct(productElement: productElement);
        total += productCart.numAdded * productElement.price;
        costo += productCart.numAdded * productElement.costo;
        utilidad += (productCart.numAdded * productElement.price) - (productCart.numAdded * productElement.costo);
      }
    }
  }
}
