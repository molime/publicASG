import 'package:cloud_firestore/cloud_firestore.dart';

final productRef = Firestore.instance.collection('product');

class ProductElement {
  final String uid;
  String category;
  String proveedor;
  String name;
  double price;
  double costo;
  String imageUrl;
  bool priceChange;
  bool costoChange;

  ProductElement({
    this.name,
    this.imageUrl,
    this.price,
    this.uid,
    this.category,
    this.proveedor,
    this.costo,
    this.costoChange,
    this.priceChange,
  });

  factory ProductElement.fromDocument({DocumentSnapshot doc}) {
    return ProductElement(
      name: doc.data['name'] != null ? doc.data['name'] : null,
      imageUrl: doc.data['imageUrl'] != null ? doc.data['imageUrl'] : null,
      price: doc.data['price'] != null ? doc.data['price'].toDouble() : null,
      uid: doc.documentID != null ? doc.documentID : null,
      category: doc.data['category'] != null ? doc.data['category'] : null,
      proveedor: doc.data['proveedor'] != null ? doc.data['proveedor'] : null,
      costo: doc.data['costo'] != null ? doc.data['costo'].toDouble() : null,
      priceChange: false,
      costoChange: false,
    );
  }

  Future<void> changePrice({double newPrice}) async {
    price = newPrice;
    await productRef.document(uid).updateData({'price': newPrice});
  }

  Future<void> changeCosto ({double newCosto}) async {
    costo = newCosto;
    await productRef.document(uid).updateData({'costo': newCosto});
  }

  void changePriceBool () {
    priceChange = true;
  }

  void changeCostoBool () {
    costoChange = true;
  }
}
