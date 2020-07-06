import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/client.dart';
import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/screens/crud/create_client.dart';

class ClientListItem extends StatelessWidget {
  const ClientListItem({
    Key key,
    @required this.context,
    @required this.index,
    @required this.client,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF5AC035),
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
            title: client.displayName != null
                ? Text(client.displayName)
                : Text('No tiene nombre'),
            subtitle: client.email != null
                ? Text(client.email)
                : Text('No tiene correo'),
            trailing: Provider.of<CartsData>(context)
                    .isContained(uid: client.uid)
                ? GestureDetector(
                    onTap: () {
                      Provider.of<CartsData>(context, listen: false)
                          .removeCart();
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
                      Provider.of<CanastaData>(context, listen: false)
                          .clearCart();
                      Provider.of<OrdersData>(context, listen: false).clearSelectedOrder();
                      Provider.of<CartsData>(context, listen: false).addCart(
                          owner: client.uid,
                          shoppingCarts: client.shoppingCart);
                    }),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateClient(
                          client: client,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
