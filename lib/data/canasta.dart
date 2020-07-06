import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/product_cart.dart';
import 'package:flutter/foundation.dart';

class CanastaData extends ChangeNotifier {
  ShoppingCart _canasta;

  ShoppingCart get canasta {
    return _canasta;
  }

  int canastaLength () {
    if (_canasta != null) {
      return _canasta.shoppingCart.length;
    } else {
      return 0;
    }
  }

  bool isCartSelected ({cartUid}) {
    if (_canasta != null) {
      return _canasta.uid == cartUid;
    } else {
      return false;
    }
  }

  bool isProductContained ({String productUid}) {
    var containing;
    if (_canasta != null) {
      containing = _canasta.shoppingCart.indexWhere((element) => element.uid == productUid);
      return containing >= 0;
    } else {
      return false;
    }
  }

  int numProductAdded ({String productUid}) {
    return _canasta.shoppingCart.firstWhere((element) => element.uid == productUid).numAdded;
  }

  List<Map> get simpleShoppingJson {
    List<Map> productJson = [];
    for (ProductCart productCart in _canasta.shoppingCart) {
      final Map productAdd = productCart.toSimpleJson();
      productJson.add(productAdd);
    }
    return productJson;
  }

  void selectCart ({ShoppingCart shoppingCart}) {
    _canasta = shoppingCart;
    notifyListeners();
  }

  void clearCart () {
    _canasta = null;
    notifyListeners();
  }

  bool canastaHasUid () {
    if (_canasta != null) {
      return _canasta.uid != null;
    } else {
      return false;
    }
  }

  void addToCart ({ProductElement productElement}) {
    ProductCart productCart = ProductCart.fromProduct(productElement: productElement);
    _canasta.addProduct(productCart: productCart);
    notifyListeners();
  }

  void plusNum ({String productUid}) {
    _canasta.plusOne(productCart: _canasta.shoppingCart.firstWhere((element) => element.uid == productUid));
    notifyListeners();
  }

  void minusNum ({String productUid}) {
    if (_canasta.shoppingCart.firstWhere((element) => element.uid == productUid).numAdded > 1) {
      _canasta.minusOne(productCart: _canasta.shoppingCart.firstWhere((element) => element.uid == productUid));
      notifyListeners();
    } else {
      _canasta.removeProduct(productCart: _canasta.shoppingCart.firstWhere((element) => element.uid == productUid));
      notifyListeners();
    }
  }
}