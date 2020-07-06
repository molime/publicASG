import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/canasta.dart';

import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/screens/cart_screen.dart';
import 'package:verdulera_app/screens/crud/create_canasta.dart';
import 'package:verdulera_app/screens/crud/update_order.dart';

IconButton cartIconButton({BuildContext context}) {
  return Provider.of<OrdersData>(context).selectedOrder == null
      ? IconButton(
          onPressed: Provider.of<CartsData>(context).ownerExists()
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                }
              : null,
          icon: Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_basket,
                  size: 24.0,
                  color: Provider.of<CartsData>(context).ownerExists()
                      ? Theme.of(context).primaryColor
                      : Color(
                          0xffa29aac,
                        ),
                ),
                onPressed: null,
              ),
              Provider.of<CartsData>(context).selectedLength() == 0
                  ? Container()
                  : Positioned(
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          Positioned(
                            top: 3.0,
                            right: 4.0,
                            child: Center(
                              child: Text(
                                Provider.of<CartsData>(context)
                                    .selectedCart
                                    .numItems
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        )
      : IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateOrder(),
              ),
            );
          },
          icon: Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_basket,
                  size: 24.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: null,
              ),
              Provider.of<OrdersData>(context).selectedOrderLength() == 0
                  ? Container()
                  : Positioned(
                      child: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          Positioned(
                            top: 3.0,
                            right: 4.0,
                            child: Center(
                              child: Text(
                                Provider.of<OrdersData>(context)
                                    .selectedOrder
                                    .productCount.toString(),
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        );
}

IconButton canastaIconButton({BuildContext context}) {
  return IconButton(
    onPressed: Provider.of<CanastaData>(context).canasta != null
        ? () {
            //TODO: send to the create canasta
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateCanasta()));
          }
        : () {
            Provider.of<OrdersData>(context, listen: false)
                .clearSelectedOrder();
            Provider.of<CartsData>(context, listen: false).removeCart();
            Provider.of<CanastaData>(context, listen: false)
                .selectCart(shoppingCart: ShoppingCart.addCanasta());
          },
    icon: Stack(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add_shopping_cart,
            size: 24.0,
            color: Provider.of<CanastaData>(context).canasta != null
                ? Theme.of(context).primaryColor
                : Color(
                    0xffa29aac,
                  ),
          ),
          onPressed: null,
        ),
        Provider.of<CanastaData>(context).canastaLength() == 0
            ? Container()
            : Positioned(
                child: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    Positioned(
                      top: 3.0,
                      right: 4.0,
                      child: Center(
                        child: Text(
                          Provider.of<CanastaData>(context)
                              .canasta
                              .numItems
                              .toString(),
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ],
    ),
  );
}
