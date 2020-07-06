import 'package:verdulera_app/models/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verdulera_app/models/product.dart';
import 'progress.dart';
import 'canasta_item.dart';

final canastaRef = Firestore.instance.collection('canastas');

class Canastas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (Provider.of<List<ShoppingCart>>(context) == null ||
            Provider.of<List<ProductElement>>(context) == null) ...[
          circularProgress(),
        ],
        if (Provider.of<List<ShoppingCart>>(context) != null &&
            Provider.of<List<ProductElement>>(context) != null) ...[
          if (Provider.of<List<ShoppingCart>>(context).length < 1) ...[
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No hay canastas disponibles',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.notifications_active,
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            )
          ],
          if (Provider.of<List<ShoppingCart>>(context).length >= 1) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 11.0,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: Provider.of<List<ShoppingCart>>(context).length,
                itemBuilder: (BuildContext context, int index) {
                  ShoppingCart canasta =
                      Provider.of<List<ShoppingCart>>(context)[index];
                  canasta.completeShoppingCart(context: context);
                  return canastaItem(
                    context: context,
                    canasta: canasta,
                    isCanasta: true,
                  );
                },
              ),
            )
          ],
        ]
      ],
    );
  }
}
