import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/data/carts.dart';

class ClientListItem extends StatelessWidget {
  const ClientListItem({
    Key key,
    @required this.context,
    @required this.index,
    @required this.shoppingCart,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final ShoppingCart shoppingCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF5AC035),
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
            title: shoppingCart.name != null ? Text(shoppingCart.name) : Text('No tiene nombre'),
            subtitle: shoppingCart.numItems != null ? Text('${shoppingCart.numItems}') : Text('No tiene artículos'),
            trailing: Provider.of<CartsData>(context)
                .isCartSelected(cartUid: shoppingCart.uid)
                ? GestureDetector(
              onTap: () {
                Provider.of<CartsData>(context, listen: false)
                    .clearCart();
              },
              child: Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check_circle, color: Colors.white),
                ),
                label: Text("Seleccionado"),
              ),
            )
                : FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.0,
                    ),
                  ),
                ),
                child: Text(
                  'Seleccionar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                onPressed: () {
                  Provider.of<CartsData>(context, listen: false)
                      .selectCart(shoppingCart: shoppingCart);
                }),
          ),
        ],
      ),
    );
  }
}
