import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/product_provider.dart';
import 'package:verdulera_app/models/provider.dart';
import 'package:verdulera_app/models/product_cart.dart';

final usersRef = Firestore.instance.collection('user');

class OrdersData extends ChangeNotifier {
  final List<ProductElement> products;

  OrdersData({this.products});

  List<Order> _orders = [];
  List<ProviderUser> _providers = [];
  List<String> _providerUids = [];
  Order _selectedOrder;
  List<ProductElement> _todayProducts = [];

  UnmodifiableListView<Order> get orders {
    return UnmodifiableListView(_orders);
  }

  UnmodifiableListView<ProviderUser> get providers {
    return UnmodifiableListView(_providers);
  }

  UnmodifiableListView<ProductElement> get todayProducts {
    return UnmodifiableListView(_todayProducts);
  }

  Order get selectedOrder {
    return _selectedOrder;
  }

  int selectedOrderLength() {
    if (_selectedOrder != null) {
      return _selectedOrder.productsProviders.length;
    } else {
      return 0;
    }
  }


  bool isOrderSelected({String orderUid}) {
    if (_selectedOrder != null) {
      return _selectedOrder.uid == orderUid;
    } else {
      return false;
    }
  }

  bool isProductContained({String productUid}) {
    var containing;
    if (_selectedOrder != null) {
      containing = _selectedOrder.productsProviders
          .indexWhere((element) => element.uid == productUid);
      return containing >= 0;
    } else {
      return false;
    }
  }

  int numProductAdded({String productUid}) {
    return _selectedOrder.productsProviders
        .firstWhere((element) => element.uid == productUid)
        .totalQuant;
  }

  void setSelectedOrder({
    Order order,
  }) {
    _selectedOrder = order;
    notifyListeners();
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }

  bool selectedOrderHasUid() {
    if (_selectedOrder != null) {
      return _selectedOrder.uid != null;
    } else {
      return false;
    }
  }

  void addTodayProducts ({ProductElement productElement}) {
    _todayProducts.add(productElement);
    notifyListeners();
  }

  void addToCart({ProductElement productElement}) {
    ProductCart productCart =
    ProductCart.fromProduct(productElement: productElement);
    ProductProvider productProvider =
    ProductProvider.fromProductCart(productCart: productCart);
    _selectedOrder.addProduct(productProvider: productProvider);
    notifyListeners();
  }

  void plusNum({String productUid}) {
    _selectedOrder.plusOne(
        productProvider: _selectedOrder.productsProviders
            .firstWhere((element) => element.uid == productUid));
    //_selectedCart.shoppingCart.firstWhere((element) => element.uid == productUid).addNum();
    notifyListeners();
  }

  void minusNum({String productUid}) {
    if (_selectedOrder.productsProviders
        .firstWhere((element) => element.uid == productUid)
        .totalQuant >
        1) {
      _selectedOrder.minusOne(
          productProvider: _selectedOrder.productsProviders
              .firstWhere((element) => element.uid == productUid));
      notifyListeners();
    } else {
      _selectedOrder.removeProduct(
          productProvider: _selectedOrder.productsProviders
              .firstWhere((element) => element.uid == productUid));
      notifyListeners();
    }
  }

  void createProviders(
      {List<DocumentSnapshot> docs,
        List<ProductProvider> products,
        @required BuildContext context}) async {

    for (ProductProvider productProvider in products) {
      if (_providers.indexWhere(
              (element) => element.uid == productProvider.proveedor) <
          0) {
        ProviderUser providerUser = Provider.of<List<ProviderUser>>(context,
            listen: false)
            .firstWhere((element) => element.uid == productProvider.proveedor);
        List<ProductProvider> productsProviderLoop =
        products.where((element) => element.proveedor == providerUser.uid).toList();
        providerUser.completeProvider(productsProviders: productsProviderLoop);
        _providers.add(providerUser);
      }
    }
    notifyListeners();
  }

  void addOrder({Order order}) {
    if (_orders.indexWhere((element) => element.uid == order.uid) < 0) {
      _orders.add(order);
      notifyListeners();
    }
  }

  void changeCost({String productUid, String proveedorUid, double newCosto}) {
    _providers.where((element) => element.uid == proveedorUid).forEach(
          (proveedor) {
        proveedor.recalculateTotal(
          productUid: productUid,
          newCosto: newCosto,
        );
      },
    );
    _orders
        .where((element) => element.uidListString.contains(productUid))
        .forEach(
          (order) {
        order.recalculateCosto(
          productUid: productUid,
          newCostoFunction: newCosto,
        );
      },
    );
    notifyListeners();
  }

  void changePrice({String productUid, double newPrice}) {
    _orders
        .where((element) => element.uidListString.contains(productUid))
        .forEach(
          (order) {
        order.recalculatePrice(
          productUid: productUid,
          newPrice: newPrice,
        );
      },
    );
    notifyListeners();
  }

  void backPage() {
    _orders.clear();
    _providers.clear();
    _providerUids.clear();
    _todayProducts.clear();
  }

  List<Map> providersJson() {
    List<Map> providers = [];
    for (ProviderUser providerUser in _providers) {
      providers.add(providerUser.providerJson());
    }
    return providers;
  }

  List<Map> ordersJson() {
    List<Map> orders = [];
    for (Order order in _orders) {
      orders.add(order.orderMap());
    }
    return orders;
  }

  List<Map> orderProductsJson() {
    List<Map> products = [];
    for (ProductProvider productProvider in selectedOrder.productsProviders) {
      products.add({
        'numAdded': productProvider.totalQuant,
        'productUid': productProvider.uid,
      });
    }
    return products;
  }
}
