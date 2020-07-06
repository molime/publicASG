import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/models/product_cart.dart';
import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/data/canasta.dart';

class CartListItem extends StatelessWidget {
  const CartListItem({
    Key key,
    @required this.context,
    @required this.index,
    @required this.productCart,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final ProductCart productCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Hero(
                        tag: '$index${productCart.imageUrl}',
                        child: FadeInImage.assetNetwork(
                            placeholder: circularProgressIndicator,
                            image: productCart.imageUrl,
                            fit: BoxFit.cover,
                            height: 75.0,
                            width: 75.0)),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productCart.name,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 125.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xFFEDFEE5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Color(0xFF5CB238)),
                                  onPressed: Provider.of<CanastaData>(context)
                                              .canasta ==
                                          null
                                      ? () {
                                          Provider.of<CartsData>(context,
                                                  listen: false)
                                              .minusNum(
                                                  productUid: productCart.uid);
                                        }
                                      : () {
                                          Provider.of<CanastaData>(context,
                                                  listen: false)
                                              .minusNum(
                                                  productUid: productCart.uid);
                                        }),
                              Text(
                                '${productCart.numAdded}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20.0,
                                    color: Color(0xFF5CB238)),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: Color(0xFF5AC035)),
                                onPressed: Provider.of<CanastaData>(context)
                                            .canasta ==
                                        null
                                    ? () {
                                        Provider.of<CartsData>(context,
                                                listen: false)
                                            .plusNum(
                                                productUid: productCart.uid);
                                      }
                                    : () {
                                        Provider.of<CanastaData>(context,
                                                listen: false)
                                            .plusNum(
                                                productUid: productCart.uid);
                                      },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
