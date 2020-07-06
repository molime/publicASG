import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/data/carts.dart';

GestureDetector canastaItem({BuildContext context, ShoppingCart canasta, isCanasta: false}) {
  return GestureDetector(
    onTap: Provider.of<CartsData>(context).ownerExists()
        ? () {
            if (Provider.of<CartsData>(context, listen: false)
                .isCartSelected(cartUid: canasta.uid)) {
              Provider.of<CartsData>(context, listen: false).clearCart();
            } else {
              Provider.of<CartsData>(context, listen: false)
                  .selectCart(shoppingCart: canasta);
            }
          }
        : null,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [Provider.of<CartsData>(context)
              .isCartSelected(cartUid: canasta.uid) ? BoxShadow(color: Colors.green, offset: Offset(10, 10)) : BoxShadow()],
          color: Colors.pink,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: new FittedBox(
          child: Material(
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF5AC035),
                            child: Icon(
                              Icons.shopping_basket,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            canasta.name,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          isCanasta ?
                          IconButton(
                            color: Colors.green,
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              if (Provider.of<CanastaData>(context, listen: false)
                                  .isCartSelected(cartUid: canasta.uid)) {
                                Provider.of<CanastaData>(context, listen: false).clearCart();
                              } else {
                                Provider.of<CartsData>(context, listen: false).clearCart();
                                Provider.of<OrdersData>(context, listen: false).clearSelectedOrder();
                                Provider.of<CanastaData>(context, listen: false)
                                    .selectCart(shoppingCart: canasta);
                              }
                            },
                          ) : Container(),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          canasta.shoppingCart.length,
                          (index) {
                            return Text(
                              canasta.shoppingCart[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          canasta.shoppingCart.length,
                          (index) {
                            return Text(
                              '\$${canasta.shoppingCart[index].price} (${canasta.shoppingCart[index].numAdded})',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${canasta.total}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}