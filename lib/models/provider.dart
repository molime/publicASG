import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_provider.dart';

final usersRef = Firestore.instance.collection('user');

class ProviderUser {
  final String uid;
  final String email;
  String displayName;
  List<ProductProvider> products;
  double total;
  int numProducts;
  String type;

  ProviderUser({
    this.uid,
    this.email,
    this.displayName,
    this.numProducts,
    this.products,
    this.total,
    this.type,
  });

  factory ProviderUser.fromDocument({DocumentSnapshot doc}) {
    return ProviderUser(
      uid: doc.documentID,
      email: doc.data['email'] != null ? doc.data['email'] : null,
      displayName:
      doc.data['displayName'] != null ? doc.data['displayName'] : null,
      products: [],
      total: 0,
      numProducts: 0,
      type: doc.data['type'] != null ? doc.data['type'] : null,
    );
  }

  void completeProvider ({List<ProductProvider> productsProviders}) {
    List<String> productsUids = [];

    if (this.total == 0 && this.numProducts == 0 && this.products.length == 0) {
      for (ProductProvider productCart in productsProviders) {
        if (!productsUids.contains(productCart.uid)) {
          productsUids.add(productCart.uid);
        }
      }

      for (String productUid in productsUids) {
        List<ProductProvider> productsCartsLoop = productsProviders.where((element) => element.uid == productUid).toList();
        ProductProvider productProviderLoop = ProductProvider.fromProductProvider(products: productsCartsLoop);
        this.products.add(productProviderLoop);
      }

      for (ProductProvider productProviderFinalLoop in this.products) {
        this.total += productProviderFinalLoop.totalCost;
        this.numProducts += productProviderFinalLoop.totalQuant;
      }
    }
  }

  Map providerJson() {
    List<Map> productsJson = [];
    for (ProductProvider productProvider in products) {
      productsJson.add(productProvider.productProviderJson());
    }
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'products': productsJson,
      'total': total,
      'numProducts': numProducts,
    };
  }

  Map providerJsonSimple () {
    List<Map> productsJson = [];
    for (ProductProvider productProvider in products) {
      productsJson.add(productProvider.productSimple());
    }
    return {
      'products': productsJson,
    };
  }

  void recalculateTotal ({String productUid, double newCosto}) {
    products.firstWhere((element) => element.uid == productUid).changeCostoSingle(newCosto: newCosto);
    double newTotal = 0;
    for (ProductProvider productProviderLoop in products) {
      newTotal += productProviderLoop.totalCost;
    }
    total = newTotal;
  }
}
