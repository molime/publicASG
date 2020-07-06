import 'dart:collection';

import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/product_cart.dart';
import 'package:flutter/foundation.dart';

class CartsData extends ChangeNotifier {
  ShoppingCart _selectedCart;
  List<ShoppingCart> _clientCarts = [];

  ShoppingCart get selectedCart {
    return _selectedCart;
  }

  UnmodifiableListView<ShoppingCart> get clientCarts {
    return UnmodifiableListView(_clientCarts);
  }

  int selectedLength () {
    if (_selectedCart != null) {
      return _selectedCart.shoppingCart.length;
    } else {
      return 0;
    }
  }

  bool isContained ({String uid}) {
    if (_selectedCart != null) {
      return _selectedCart.owner == uid;
    } else {
      return false;
    }
  }

  bool ownerExists () {
    if (_selectedCart != null) {
      return _selectedCart.owner != null;
    } else {
      return false;
    }
  }

  bool isCartSelected ({cartUid}) {
    if (_selectedCart != null) {
      return _selectedCart.uid == cartUid;
    } else {
      return false;
    }
  }

  bool isProductContained ({String productUid}) {
    var containing;
    if (_selectedCart != null) {
      containing = _selectedCart.shoppingCart.indexWhere((element) => element.uid == productUid);
      return containing >= 0;
    } else {
      return false;
    }
  }

  int numProductAdded ({String productUid}) {
    return _selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid).numAdded;
  }

  void addCart ({String owner, List<ShoppingCart> shoppingCarts}) {
    if (_selectedCart != null) {
      _selectedCart.resetCartOwner(newOwner: owner);
      shoppingCarts != [] ? _clientCarts = shoppingCarts : _clientCarts = [];
      notifyListeners();
    } else {
      _selectedCart = ShoppingCart.fromSelecting(owner: owner);
      shoppingCarts != [] ? _clientCarts = shoppingCarts : _clientCarts = [];
      notifyListeners();
    }
  }

  List<Map> get shoppingJson {
    List<Map> productJson = [];
    for (ProductCart productCart in _selectedCart.shoppingCart) {
      productJson.add({
        'productUid': productCart.uid,
        'numAdded': productCart.numAdded,
      });
    }
    return productJson;
  }

  List<Map> get simpleShoppingJson {
    List<Map> productJson = [];
    for (ProductCart productCart in _selectedCart.shoppingCart) {
      final Map productAdd = productCart.toSimpleJson();
      productJson.add(productAdd);
    }
    return productJson;
  }

  void selectCart ({ShoppingCart shoppingCart}) {
    if (shoppingCart.owner != null) {
      _selectedCart = shoppingCart;
      notifyListeners();
    } else {
      ShoppingCart shoppingCartNew = shoppingCart;
      shoppingCartNew.addOwner(ownerUid: _selectedCart.owner);
      _selectedCart = shoppingCartNew;
      notifyListeners();
    }
  }

  void removeCart () {
    _selectedCart = null;
    _clientCarts = [];
    notifyListeners();
  }

  void clearCart () {
    _selectedCart = null;
    notifyListeners();
  }

  void addToCart ({ProductElement productElement}) {
    ProductCart productCart = ProductCart.fromProduct(productElement: productElement);
    _selectedCart.addProduct(productCart: productCart);
    notifyListeners();
  }

  void plusNum ({String productUid}) {
    _selectedCart.plusOne(productCart: _selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid));
    notifyListeners();
  }

  void minusNum ({String productUid}) {
    if (_selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid).numAdded > 1) {
      _selectedCart.minusOne(productCart: _selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid));
      notifyListeners();
    } else {
      _selectedCart.removeProduct(productCart: _selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid));
      notifyListeners();
    }
  }
}