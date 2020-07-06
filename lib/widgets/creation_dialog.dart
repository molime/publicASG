import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/models/client.dart';

final _firestore = Firestore.instance;

Future showCheckoutDialog(
    {BuildContext context, String name, DateTime dateDeliver}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        String cartSummary = '';
        Provider.of<CartsData>(context, listen: false)
            .selectedCart
            .shoppingCart
            .forEach((cartProduct) {
          cartSummary += "· ${cartProduct.name}, \$${cartProduct.price}\n";
        });
        return AlertDialog(
            title: Text('Checkout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      'ARTÍCULOS (${Provider.of<CartsData>(context, listen: false).selectedCart.shoppingCart.length})\n',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0)),
                  Text('$cartSummary',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0)),
                  Text(
                      'TOTAL: \$${Provider.of<CartsData>(context, listen: false).selectedCart.total}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0))
                ],
              ),
            ),
            actions: [
              if (Provider.of<CartsData>(context).selectedCart.uid == null) ...[
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    false,
                  ),
                  color: Colors.red,
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                name == null
                    ? FlatButton(
                        onPressed: () => Navigator.pop(
                          context,
                          'confirmar',
                        ),
                        color: Colors.green,
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : FlatButton(
                        onPressed: () => Navigator.pop(
                          context,
                          'guardar',
                        ),
                        color: Colors.green,
                        child: Text(
                          'Confirmar y guardar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
              if (Provider.of<CartsData>(context).selectedCart.uid != null &&
                  !Provider.of<CartsData>(context).selectedCart.hasChanged) ...[
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    false,
                  ),
                  color: Colors.red,
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    'confirmar',
                  ),
                  color: Colors.green,
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              if (Provider.of<CartsData>(context).selectedCart.uid != null &&
                  Provider.of<CartsData>(context).selectedCart.hasChanged) ...[
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    false,
                  ),
                  color: Colors.red,
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    'confirmar',
                  ),
                  color: Colors.green,
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(
                    context,
                    'actualizar',
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Confirmar y guardar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ]);
      }).then((value) async {
    _saveCartProducts() async {
      await _firestore
          .collection('user')
          .document(
              Provider.of<CartsData>(context, listen: false).selectedCart.owner)
          .collection('shoppingCarts')
          .add({
        'name': name != null ? name : null,
        'owner':
            Provider.of<CartsData>(context, listen: false).selectedCart.owner,
        'products':
            Provider.of<CartsData>(context, listen: false).simpleShoppingJson,
        'productCount': Provider.of<CartsData>(context, listen: false)
            .selectedCart
            .numItems,
      });
    }

    _updateCartProducts() async {
      await _firestore
          .collection('user')
          .document(
              Provider.of<CartsData>(context, listen: false).selectedCart.owner)
          .collection('shoppingCarts')
          .document(
              Provider.of<CartsData>(context, listen: false).selectedCart.uid)
          .updateData({
        'products':
            Provider.of<CartsData>(context, listen: false).simpleShoppingJson,
        'productCount': Provider.of<CartsData>(context, listen: false)
            .selectedCart
            .numItems,
      });
    }

    Future<DocumentReference> _checkoutCartProducts() async {
      // create new order in Firebase
      return await _firestore.collection('order').add({
        'client':
            Provider.of<CartsData>(context, listen: false).selectedCart.owner,
        'clientName': Provider.of<List<Client>>(context, listen: false)
                    .firstWhere((element) =>
                        element.uid ==
                        Provider.of<CartsData>(context, listen: false)
                            .selectedCart
                            .owner)
                    .displayName !=
                null
            ? Provider.of<List<Client>>(context, listen: false)
                .firstWhere((element) =>
                    element.uid ==
                    Provider.of<CartsData>(context, listen: false)
                        .selectedCart
                        .owner)
                .displayName
            : '',
        'clientEmail': Provider.of<List<Client>>(context, listen: false)
                    .firstWhere((element) =>
                        element.uid ==
                        Provider.of<CartsData>(context, listen: false)
                            .selectedCart
                            .owner)
                    .email !=
                null
            ? Provider.of<List<Client>>(context, listen: false)
                .firstWhere((element) =>
                    element.uid ==
                    Provider.of<CartsData>(context, listen: false)
                        .selectedCart
                        .owner)
                .email
            : '',
        'deliverDate': dateDeliver,
        'createdDate': DateTime.now(),
        'products': Provider.of<CartsData>(context, listen: false).shoppingJson,
        'productCount': Provider.of<CartsData>(context, listen: false)
            .selectedCart
            .numItems,
        'utilidad': Provider.of<CartsData>(context, listen: false)
            .selectedCart
            .utilidad,
      });
    }

    if (value == 'confirmar') {
      await _checkoutCartProducts();
    } else if (value == 'guardar') {
      await _checkoutCartProducts();
      await _saveCartProducts();
    } else if (value == 'actualizar') {
      await _checkoutCartProducts();
      await _updateCartProducts();
    }
  });
}

Future showCanastaDialog({
  BuildContext context,
  String name,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      String cartSummary = '';
      Provider.of<CanastaData>(context, listen: false)
          .canasta
          .shoppingCart
          .forEach((cartProduct) {
        cartSummary += "· ${cartProduct.name}, \$${cartProduct.price}\n";
      });
      return AlertDialog(
        title: Text('Crear Canasta'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                  'ARTÍCULOS (${Provider.of<CanastaData>(context, listen: false).canasta.shoppingCart.length})\n',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0)),
              Text('$cartSummary',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0)),
              Text(
                  'TOTAL: \$${Provider.of<CanastaData>(context, listen: false).canasta.total}',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0))
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
            color: Colors.red,
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
            color: Colors.green,
            child: Text(
              Provider.of<CanastaData>(context, listen: false).canastaHasUid()
                  ? 'Actualizar'
                  : 'Crear',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  ).then((value) async {
    _createCanasta() async {
      await _firestore.collection('canastas').add({
        'name': name,
        'productCount':
            Provider.of<CanastaData>(context, listen: false).canasta.numItems,
        'products':
            Provider.of<CanastaData>(context, listen: false).simpleShoppingJson,
      });
    }

    _updateCanasta() async {
      await _firestore
          .collection('canastas')
          .document(
              Provider.of<CanastaData>(context, listen: false).canasta.uid)
          .updateData({
        'name': name,
        'productCount':
            Provider.of<CanastaData>(context, listen: false).canasta.numItems,
        'products':
            Provider.of<CanastaData>(context, listen: false).simpleShoppingJson,
      });
    }

    if (value) {
      if (Provider.of<CanastaData>(context, listen: false).canastaHasUid()) {
        await _updateCanasta();
      } else {
        await _createCanasta();
      }
      Provider.of<CanastaData>(context, listen: false).clearCart();
    }
  });
}

Future showOrderDialog({
  BuildContext context,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      String cartSummary = '';
      Provider.of<OrdersData>(context, listen: false)
          .selectedOrder
          .productsProviders
          .forEach((orderProduct) {
        cartSummary += "· ${orderProduct.name}, \$${orderProduct.price}\n";
      });
      return AlertDialog(
        title: Text('Crear Canasta'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                  'ARTÍCULOS (${Provider.of<OrdersData>(context, listen: false).selectedOrder.productsProviders.length})\n',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0)),
              Text('$cartSummary',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0)),
              Text(
                  'TOTAL: \$${Provider.of<OrdersData>(context, listen: false).selectedOrder.amount}',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0))
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
            color: Colors.red,
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
            color: Colors.green,
            child: Text(
              'Actualizar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  ).then((value) async {
    _updateOrder() async {
      await _firestore
          .collection('order')
          .document(
              Provider.of<OrdersData>(context, listen: false).selectedOrder.uid)
          .updateData({
        'productCount': Provider.of<OrdersData>(context, listen: false)
            .selectedOrder
            .productCount,
        'products':
            Provider.of<OrdersData>(context, listen: false).orderProductsJson(),
      });
    }

    if (value) {
      await _updateOrder();
      Provider.of<OrdersData>(context, listen: false).clearSelectedOrder();
    }
  });
}

Future showChangeNameDialog(
    {BuildContext context, TextEditingController nameController}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        //String name;
        return AlertDialog(
          title: Text(
            'Cambiar nombre',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  onChanged: (newName) {
                    setState(() {});
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'NOMBRE',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(
                context,
                'cerrar',
              ),
              color: Colors.red,
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed:
                  nameController.text == null || nameController.text == ''
                      ? () {}
                      : () => Navigator.pop(
                            context,
                            nameController.text,
                          ),
              color: nameController.text == null || nameController.text == ''
                  ? Colors.grey
                  : Colors.green,
              child: Text(
                'Actualizar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      });
    },
  ).then((value) async {

    if (value != 'cerrar') {
      Provider.of<UserData>(context, listen: false).changeName(newName: value);
    }
  });
}
