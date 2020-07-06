import 'package:flutter/material.dart';
import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/data/category_data.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verdulera_app/screens/crud/update_order.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  final int index;
  final bool edit;

  const OrderDetails({
    Key key,
    this.order,
    this.index,
    this.edit: false,
  }) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isEditing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEditing = widget.edit;
  }

  @override
  Widget build(BuildContext context) {
    return !isEditing
        ? Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                widget.order.pdf == null
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: Provider.of<OrdersData>(context,
                                        listen: false)
                                    .selectedOrder ==
                                null
                            ? () {
                                Provider.of<CartsData>(context, listen: false)
                                    .removeCart();
                                Provider.of<CanastaData>(context, listen: false)
                                    .clearCart();
                                Provider.of<OrdersData>(context, listen: false)
                                    .setSelectedOrder(order: widget.order);
                                setState(() {
                                  isEditing = true;
                                });
                              }
                            : null,
                      )
                    : Container(),
                widget.order.pdf == null
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Borrar la order'),
                                  content: Text(
                                      '¿Estás seguro que quieres borrar esta orden?'),
                                  actions: <Widget>[
                                    RaisedButton(
                                      color: Colors.red,
                                      onPressed: () async {
                                        await Firestore.instance
                                            .collection('order')
                                            .document(widget.order.uid)
                                            .delete();
                                        int count = 0;

                                        Navigator.of(context)
                                            .popUntil((_) => count++ >= 2);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.grey,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                    : Container(),
                widget.order.pdf != null
                    ? IconButton(
                        icon: Icon(Icons.picture_as_pdf),
                        onPressed: () async {
                          final String url = widget.order.pdf;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'No se pudo abrir el pdf';
                          }
                        },
                      )
                    : Container(),
              ],
              title: Text(
                  'Order n° ${widget.index} ( cost: ${widget.order.costo} )'),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.order.productUidList.length,
                      itemBuilder: (context, index) {
                        ProductElement productElement =
                            Provider.of<List<ProductElement>>(context)
                                .singleWhere((element) =>
                                    element.uid ==
                                    widget.order.productUidList[index]);
                        return _buildTile(productElement, context);
                      }),
                )
              ],
            ),
          )
        : UpdateOrder();
  }

  Widget _buildTile(ProductElement productElement, context) {
    String category = Provider.of<CategoryData>(context, listen: false)
        .categories
        .singleWhere((element) => productElement.category == element.uid,
            orElse: () {
      return CategoryElement(name: 'No category');
    }).name;
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl: productElement.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  productElement.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category ?? 'No category',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  productElement.price.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
