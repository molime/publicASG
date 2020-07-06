import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryElement {
  final String uid;
  String name;
  String subtitle;
  int cuenta;
  String img;
  DocumentReference prueba;
  String centro;

  CategoryElement({this.subtitle, this.cuenta, this.img, this.name, this.uid, this.prueba, this.centro});

  factory CategoryElement.fromDocument({DocumentSnapshot doc}) {
    return CategoryElement(
      subtitle: doc.data['subtitle'] != null ? doc.data['subtitle'] : null,
      uid: doc.documentID != null ? doc.documentID : null,
      cuenta: doc.data['cuenta'] != null ? doc.data['cuenta'] : null,
      img: doc.data['img'] != null ? doc.data['img'] : null,
      name: doc.data['name'] != null ? doc.data['name'] : null,
      prueba: doc.data['centroReference'] != null ? doc.data['centroReference'] : null,
      centro: doc.data['centro'] != null ? doc.data['centro'] : null,
    );
  }
}
