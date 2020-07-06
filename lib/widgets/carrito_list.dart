import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:verdulera_app/widgets/canasta_item.dart';

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CartsData>(context).clientCarts.length < 1
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No hay carritos guardados',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.shopping_basket,
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 11.0,
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: Provider.of<CartsData>(context).clientCarts.length,
        itemBuilder: (BuildContext context, int index) {
          ShoppingCart canasta = Provider.of<CartsData>(context).clientCarts[index];
          return canastaItem(context: context, canasta: canasta);
        },
      ),
    );
  }
}
