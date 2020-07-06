import 'package:verdulera_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final productRef = Firestore.instance.collection('product');

class ProductCart {
  final String uid;
  String category;
  String proveedor;
  String name;
  double price;
  double costo;
  String imageUrl;
  int numAdded;

  ProductCart({
    this.name,
    this.imageUrl,
    this.price,
    this.uid,
    this.category,
    this.proveedor,
    this.costo,
    this.numAdded,
  });

  factory ProductCart.plain({String productUid, int numAdded}) {
    return ProductCart(
      uid: productUid,
      numAdded: numAdded,
    );
  }

  ProductCart productCartFromUid(
      {String productUid, int numAdded, List<ProductElement> products}) {
    ProductElement productElement =
    products.firstWhere((product) => product.uid == productUid);
    ProductCart productCart = ProductCart.forStreamProvider(
        productElement: productElement, numAdded: numAdded);
    return productCart;
  }

  factory ProductCart.forStreamProvider(
      {ProductElement productElement, int numAdded}) {
    return ProductCart(
      name: productElement.name,
      imageUrl: productElement.imageUrl,
      price: productElement.price,
      costo: productElement.costo,
      uid: productElement.uid,
      category: productElement.category,
      proveedor: productElement.proveedor,
      numAdded: numAdded,
    );
  }

  factory ProductCart.fromProduct({ProductElement productElement}) {
    return ProductCart(
      name: productElement.name,
      imageUrl: productElement.imageUrl,
      price: productElement.price,
      costo: productElement.costo,
      uid: productElement.uid,
      category: productElement.category,
      proveedor: productElement.proveedor,
      numAdded: 1,
    );
  }

  void addNum() {
    numAdded++;
  }

  void subtractNum() {
    numAdded--;
  }

  void completeProduct ({ProductElement productElement}) {
    name = productElement.name;
    imageUrl = productElement.imageUrl;
    price = productElement.price;
    costo = productElement.costo;
    category = productElement.category;
    proveedor = productElement.proveedor;
  }

  Map toSimpleJson() {
    return {
      'productUid': uid,
      'numAdded': numAdded,
    };
  }
}
