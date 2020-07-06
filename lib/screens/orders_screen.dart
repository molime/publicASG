import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/provider.dart';
import 'package:verdulera_app/widgets/order_item.dart';
import 'package:verdulera_app/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_today_screen.dart';

final _firestore = Firestore.instance;

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTime now;
  DateTime selectedDate;
  Stream<QuerySnapshot> querySnapshot = _firestore
      .collection('order')
      .orderBy('deliverDate', descending: false)
      .snapshots();
  bool todayOrders = false;
  List<Order> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'Órdenes',
          style: GoogleFonts.openSans(
            fontSize: 20.0,
            color: Color(0xFF545D68),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.today),
            onPressed: selectedDate == null
                ? () async {
                    if (Provider.of<List<Order>>(context, listen: false) !=
                            null &&
                        Provider.of<List<ProductElement>>(context,
                                listen: false) !=
                            null) {
                      DateTime datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          Duration(days: 30),
                        ),
                        lastDate: DateTime.now().add(
                          Duration(days: 30),
                        ),
                      );
                      setState(() {
                        selectedDate = datePicked;
                      });
                      orders = Provider.of<List<Order>>(context, listen: false)
                          .where(
                            (order) =>
                                DateTime(
                                  order.deliveryDate.year,
                                  order.deliveryDate.month,
                                  order.deliveryDate.day,
                                ) ==
                                DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                ),
                          )
                          .toList();
                    }
                  }
                : () {
                    setState(() {
                      selectedDate = null;
                    });
                    orders = Provider.of<List<Order>>(context, listen: false);
                  },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: todayOrders ? Colors.white : Colors.blueGrey,
            ),
            onPressed: () {
              if (Provider.of<List<Order>>(context, listen: false) != null &&
                  Provider.of<List<ProductElement>>(context, listen: false) !=
                      null) {
                setState(() {
                  todayOrders = !todayOrders;
                  if (todayOrders) {
                    setState(() {
                      selectedDate = now;
                    });
                    orders = Provider.of<List<Order>>(context, listen: false)
                        .where(
                          (order) =>
                              DateTime(
                                order.deliveryDate.year,
                                order.deliveryDate.month,
                                order.deliveryDate.day,
                              ) ==
                              DateTime(
                                now.year,
                                now.month,
                                now.day,
                              ),
                        )
                        .toList();
                  } else {
                    orders = Provider.of<List<Order>>(context, listen: false);
                    setState(() {
                      selectedDate = null;
                    });
                  }
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: Provider.of<List<ProductElement>>(context) != null &&
                    Provider.of<List<Order>>(context) != null &&
                    Provider.of<List<ProviderUser>>(context) != null
                ? () {
              Order().todayOrders(context: context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsEditToday(),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Flex(
        direction: Axis.vertical,
        children: [
          if (Provider.of<List<Order>>(context) == null ||
              Provider.of<List<ProductElement>>(context) == null) ...[
            circularProgress(),
          ],
          if (Provider.of<List<Order>>(context) != null &&
              Provider.of<List<ProductElement>>(context) != null) ...[
                if (selectedDate != null) ... [
                  if (orders.length < 1) ... [
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
                              'No hay pedidos disponibles',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (orders.length >= 1) ... [
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 110,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pedidos',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Inicio",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Color(0xffa29aac),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.all(9.0),
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                  Order order = orders[index];
                                  order.completeOrder(context: context);
                                  return OrderItem(
                                    order: order,
                                    index: index + 1,
                                  );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 2 / 3,
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                  crossAxisCount: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
            if (selectedDate == null) ... [
              if (Provider.of<List<Order>>(context).length < 1) ...[
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
                          'No hay pedidos disponibles',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (Provider.of<List<Order>>(context).length >= 1) ...[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 110,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pedidos',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Inicio",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Color(0xffa29aac),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.all(9.0),
                          itemCount: Provider.of<List<Order>>(context).length,
                          itemBuilder: (context, index) {
                              Order order =
                              Provider.of<List<Order>>(context)[index];
                              order.completeOrder(context: context);
                              return OrderItem(
                                order: order,
                                index: index + 1,
                              );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2 / 3,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              crossAxisCount: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}
