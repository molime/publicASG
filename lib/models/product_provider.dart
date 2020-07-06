import 'package:verdulera_app/models/product.dart';

import 'product_cart.dart';

class ProductProvider {
  final String uid;
  String name;
  String proveedor;
  String imageUrl;
  List<int> quantities;
  double cost;
  double price;
  double totalCost;
  double totalPrice;
  int totalQuant;

  ProductProvider({
    this.name,
    this.quantities,
    this.uid,
    this.totalCost,
    this.cost,
    this.totalQuant,
    this.totalPrice,
    this.price,
    this.proveedor,
    this.imageUrl,
  });

  factory ProductProvider.plain ({ProductCart productCart}) {
    return ProductProvider(
      name: null,
      uid: productCart.uid,
      proveedor: null,
      quantities: [productCart.numAdded],
      cost: 0,
      price: 0,
      totalCost: 0,
      totalPrice: 0,
      totalQuant: productCart.numAdded,
      imageUrl: null,
    );
  }

  factory ProductProvider.fromProductCart({ProductCart productCart}) {
    return ProductProvider(
      name: productCart.name,
      uid: productCart.uid,
      proveedor: productCart.proveedor,
      quantities: [productCart.numAdded],
      cost: productCart.costo,
      price: productCart.price,
      totalCost: productCart.costo * productCart.numAdded,
      totalPrice: productCart.price * productCart.numAdded,
      totalQuant: productCart.numAdded,
      imageUrl: productCart.imageUrl,
    );
  }

  factory ProductProvider.fromListProductCarts({List<ProductCart> products}) {
    ProductProvider productProvider = ProductProvider(
      name: products[0].name,
      uid: products[0].uid,
      proveedor: products[0].proveedor,
      quantities: [],
      cost: products[0].costo,
      price: products[0].price,
      totalCost: 0,
      totalPrice: 0,
      totalQuant: 0,
      imageUrl: products[0].imageUrl,
    );

    for (ProductCart productCart in products) {
      productProvider.quantities.add(productCart.numAdded);
      productProvider.totalQuant += productCart.numAdded;
      productProvider.totalCost += productCart.costo * productCart.numAdded;
      productProvider.totalPrice += productCart.price * productCart.numAdded;
    }

    return productProvider;
  }

  factory ProductProvider.fromProductProvider ({List<ProductProvider> products}) {
    ProductProvider productProviderReturn = ProductProvider(
      name: products[0].name,
      uid: products[0].uid,
      proveedor: products[0].proveedor,
      quantities: [],
      cost: products[0].cost,
      price: products[0].price,
      totalCost: 0,
      totalPrice: 0,
      totalQuant: 0,
      imageUrl: products[0].imageUrl,
    );

    for (ProductProvider productProvider in products) {
      productProviderReturn.quantities.add(productProvider.totalQuant);
      productProviderReturn.totalQuant += productProvider.totalQuant;
      productProviderReturn.totalCost += productProvider.cost * productProvider.totalQuant;
      productProviderReturn.totalPrice += productProvider.price * productProvider.totalQuant;
    }

    return productProviderReturn;
  }

  void addNum() {
    quantities[0]++;
    totalQuant++;
    totalCost += cost;
    totalPrice += price;
  }

  void minusNum() {
    quantities[0]--;
    totalQuant--;
    totalCost -= cost;
    totalPrice -= price;
  }

  void addProduct({ProductCart productCart}) {
    quantities.add(productCart.numAdded);
    totalCost += productCart.costo * productCart.numAdded;
    totalPrice += productCart.price * productCart.numAdded;
    totalQuant += productCart.numAdded;
  }

  void addProductProvider({ProductProvider productProvider}) {
    quantities.add(productProvider.totalQuant);
    totalCost += productProvider.cost * productProvider.totalQuant;
    totalPrice += productProvider.price * productProvider.totalQuant;
    totalQuant += productProvider.totalQuant;
  }

  String getQuantities() {
    String quantities = "";
    for (int i = 0; i < this.quantities.length; i++) {
      if (i < this.quantities.length - 1) {
        quantities += "${this.quantities[i].toString()}, ";
      } else {
        quantities += this.quantities[i].toString();
      }
    }
    return quantities;
  }

  void completeProductProvider ({ProductElement productElement}) {
    name = productElement.name;
    proveedor = productElement.proveedor;
    imageUrl = productElement.imageUrl;
    cost = productElement.costo;
    price = productElement.price;
    totalCost = productElement.costo * totalQuant;
    totalPrice = productElement.price * totalQuant;
  }

  Map productProviderJson() {
    return {
      'uid': uid,
      'name': name,
      'proveedor': proveedor,
      'quantities': quantities,
      'cost': cost,
      'price': price,
      'totalCost': totalCost,
      'totalPrice': totalCost,
      'totalQuant': totalQuant,
    };
  }

  Map productSimple() {
    return {
      'quantities': quantities,
      'cost': cost,
      'price': price,
      'totalCost': totalCost,
      'totalPrice': totalCost,
      'totalQuant': totalQuant,
    };
  }

  void changePriceSingle({double newPrice}) {
    totalPrice = totalQuant * newPrice;
    price = newPrice;
  }

  void changeCostoSingle({double newCosto}) {
    totalCost = totalQuant * newCosto;
    cost = newCosto;
  }
}
