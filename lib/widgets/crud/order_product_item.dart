import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/product_provider.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    Key key,
    @required this.context,
    @required this.index,
    @required this.productProvider,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final ProductProvider productProvider;

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
                        tag: '$index${productProvider.imageUrl}',
                        child: FadeInImage.assetNetwork(
                            placeholder: circularProgressIndicator,
                            image: productProvider.imageUrl,
                            fit: BoxFit.cover,
                            height: 75.0,
                            width: 75.0)),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(productProvider.name,
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
                                  onPressed: () {
                                          Provider.of<OrdersData>(context,
                                                  listen: false)
                                              .minusNum(
                                                  productUid: productProvider.uid);
                                        }),
                              Text(
                                '${productProvider.totalQuant}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20.0,
                                    color: Color(0xFF5CB238)),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle,
                                    color: Color(0xFF5AC035)),
                                onPressed: () {
                                        Provider.of<OrdersData>(context,
                                                listen: false)
                                            .plusNum(
                                                productUid: productProvider.uid);
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
