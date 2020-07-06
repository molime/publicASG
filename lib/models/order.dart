import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/product_cart.dart';
import 'package:verdulera_app/models/product_provider.dart';

final orderRef = Firestore.instance.collection('order');
final _firestore = Firestore.instance;

class Order {
  double amount = 0;
  double costo = 0;
  final String uid;
  final DateTime createdDate;
  final DateTime deliveryDate;
  int productCount;
  double utilidad;
  final List<dynamic> productUidList;
  final List<String> uidListString;
  List<ProductProvider> productsProviders;
  final String clientUid;
  final String clientEmail;
  final String clientName;
  final String pdf;

  Order({
    this.uid,
    this.clientUid,
    this.amount,
    this.utilidad,
    this.createdDate,
    this.deliveryDate,
    this.productCount,
    this.productUidList,
    this.uidListString,
    this.productsProviders,
    this.costo,
    this.clientEmail,
    this.clientName,
    this.pdf,
  });

  factory Order.forStream({DocumentSnapshot doc}) {
    Order order = Order(
      uid: doc.documentID,
      clientUid: doc.data['client'] != null ? doc.data['client'] : null,
      amount: 0,
      utilidad: 0,
      createdDate: doc.data['createdDate'] != null
          ? doc.data['createdDate'].toDate()
          : null,
      deliveryDate: doc.data['deliverDate'] != null
          ? doc.data['deliverDate'].toDate()
          : null,
      productCount:
      doc.data['productCount'] != null ? doc.data['productCount'] : null,
      costo: 0,
      clientEmail:
      doc.data['clientEmail'] != null ? doc.data['clientEmail'] : null,
      clientName: doc.data['clientName'] ?? null,
      pdf: doc.data['pdf'] != null ? doc.data['pdf'] : null,
      productUidList: [],
      uidListString: [],
      productsProviders: [],
    );
    for (dynamic doc in doc.data['products']) {
      order.productUidList.add(doc['productUid']);
      order.uidListString.add(doc['productUid'].toString());
      ProductCart productCart = ProductCart.plain(
        productUid: doc['productUid'],
        numAdded: doc['numAdded'],
      );
      order.productsProviders
          .add(ProductProvider.plain(productCart: productCart));
    }
    return order;
  }

  List<ProductElement> todayOrders(
      {@required BuildContext context}) {
    DateTime now = DateTime.now();

    List<ProductProvider> productProvidersCreate = [];
    List<ProductElement> products = [];

    List<Order> orders =
        Provider.of<List<Order>>(context, listen: false).where((order) =>
            DateTime(
              order.deliveryDate.year,
              order.deliveryDate.month,
              order.deliveryDate.day,
            ) ==
            DateTime(
              now.year,
              now.month,
              now.day,
            )).toList();

    if (orders.length < 1) {
      return products;
    }

    for (Order order
        in orders) {
      order.completeOrder(context: context);
      if (Provider.of<OrdersData>(context, listen: false)
              .orders
              .indexWhere((element) => element.uid == order.uid) <
          0) {
        Provider.of<OrdersData>(context, listen: false).addOrder(order: order);
      }

      for (ProductProvider productProvider in order.productsProviders) {
        productProvidersCreate.add(productProvider);
        if (products
                .indexWhere((element) => element.uid == productProvider.uid) <
            0) {
          ProductElement productElement =
              Provider.of<List<ProductElement>>(context, listen: false)
                  .firstWhere((element) => element.uid == productProvider.uid);
          Provider.of<OrdersData>(context, listen: false).addTodayProducts(productElement: productElement);
          products.add(productElement);
        }
      }
    }

    Provider.of<OrdersData>(context, listen: false)
        .createProviders(products: productProvidersCreate, context: context);

    return products;
  }

  void recalculatePrice({String productUid, double newPrice}) {
    productsProviders
        .firstWhere((element) => element.uid == productUid)
        .changePriceSingle(newPrice: newPrice);
    double newAmount = 0;
    double newUtilidad = 0;
    for (ProductProvider productProviderLoop in productsProviders) {
      newAmount += productProviderLoop.totalPrice;
      newUtilidad +=
          productProviderLoop.totalPrice - productProviderLoop.totalCost;
    }
    amount = newAmount;
    utilidad = newUtilidad;
  }

  void recalculateCosto({String productUid, double newCostoFunction}) {
    productsProviders
        .firstWhere((element) => element.uid == productUid)
        .changeCostoSingle(newCosto: newCostoFunction);
    double newCosto = 0;
    double newUtilidad = 0;
    for (ProductProvider productProviderLoop in productsProviders) {
      newCosto += productProviderLoop.totalCost;
      newUtilidad +=
          productProviderLoop.totalPrice - productProviderLoop.totalCost;
    }
    costo = newCosto;
    utilidad = newUtilidad;
  }

  List<Map> products() {
    List<Map> productsJson = [];
    for (ProductProvider productProvider in productsProviders) {
      productsJson.add(productProvider.productSimple());
    }
    return productsJson;
  }

  Map orderMap() {
    return {
      'uid': uid,
      'clientUid': clientUid,
      'revenue': amount,
      'profit': utilidad,
      'createdDate': createdDate,
      'deliveryDate': deliveryDate,
      'productCount': productCount,
      'productUids': uidListString,
      'products': products(),
      'costo': costo,
      'clientEmail': clientEmail,
      'clientName': clientName,
    };
  }

  void addProduct({ProductProvider productProvider}) {
    uidListString.add(productProvider.uid);
    productUidList.add(productProvider.uid);
    productsProviders.add(productProvider);
    productCount += productProvider.totalQuant;
    amount += productProvider.totalPrice;
    costo += productProvider.totalCost;
    utilidad += productProvider.totalPrice - productProvider.totalCost;
  }

  void plusOne({ProductProvider productProvider}) {
    productsProviders
        .firstWhere((element) => element.uid == productProvider.uid)
        .addNum();
    productCount++;
    amount += productProvider.price;
    costo += productProvider.cost;
    utilidad += productProvider.price - productProvider.cost;
  }

  void minusOne({ProductProvider productProvider}) {
    productsProviders
        .firstWhere((element) => element.uid == productProvider.uid)
        .minusNum();
    productCount--;
    amount -= productProvider.price;
    costo -= productProvider.cost;
    utilidad -= productProvider.price - productProvider.cost;
  }

  void removeProduct({ProductProvider productProvider}) {
    productsProviders.remove(productProvider);
    productCount--;
    amount -= productProvider.price;
    costo -= productProvider.cost;
    utilidad -= productProvider.price - productProvider.cost;
  }

  void completeOrder(
      {@required BuildContext context, List<ProductElement> productElements}) {
    if (amount == 0 && costo == 0 && utilidad == 0) {
      for (ProductProvider productProvider in productsProviders) {
        ProductElement productElement =
        Provider.of<List<ProductElement>>(context, listen: false)
            .firstWhere((element) => element.uid == productProvider.uid);
        productProvider.completeProductProvider(productElement: productElement);
        amount += productElement.price * productProvider.totalQuant;
        costo += productElement.costo * productProvider.totalQuant;
        utilidad += (productElement.price * productProvider.totalQuant) -
            (productElement.costo * productProvider.totalQuant);
      }
    }
  }
}