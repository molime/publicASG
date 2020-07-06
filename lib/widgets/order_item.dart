import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_details.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  final int index;
  const OrderItem({Key key, this.order, this.index}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  String clientEmail = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: Provider.of<OrdersData>(context, listen: false)
                .isOrderSelected(orderUid: widget.order.uid)
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(
                      index: widget.index,
                      order: widget.order,
                      edit: true,
                    ),
                  ),
                );
              }
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(
                      index: widget.index,
                      order: widget.order,
                    ),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: Center(
                child: Text(
                  'Order n° ${widget.index}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Creation date',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Delivery date',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Product Count',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cost',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Utilidad',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Amount',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '${widget.order.createdDate.day} ${evaluateMonth(widget.order.createdDate.month)}'),
                            Text(
                                '${widget.order.deliveryDate.day} ${evaluateMonth(widget.order.deliveryDate.month)}'),
                            Text('${widget.order.productCount}'),
                            Text('${widget.order.costo}'),
                            Text('${widget.order.utilidad}'),
                            Text('${widget.order.amount}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Client',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.order.clientEmail),
            ),
            SizedBox(
              height: 20,
            ),
            if (DateTime.now().day == widget.order.deliveryDate.day &&
                DateTime.now().month == widget.order.deliveryDate.month)
              Container(
                margin: EdgeInsets.only(left: 4.0, bottom: 4.0),
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (DateTime.now().day > widget.order.deliveryDate.day ||
                DateTime.now().month > widget.order.deliveryDate.month)
              Container(
                margin: EdgeInsets.only(left: 4.0, bottom: 4.0),
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Late',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String evaluateMonth(int i) {
    switch (i) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
  }
}
