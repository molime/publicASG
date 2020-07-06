import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/product_provider.dart';
import 'package:verdulera_app/widgets/crud/order_product_item.dart';
import '../creation_dialog.dart';

class OrdenSeleccionada extends StatefulWidget {
  @override
  _OrdenSeleccionadaState createState() => _OrdenSeleccionadaState();
}

class _OrdenSeleccionadaState extends State<OrdenSeleccionada> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<OrdersData>(context).selectedOrderLength() < 1
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
                      'No has seleccionado productos',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.fastfood,
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            ),
          )
        : ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 350,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: Provider.of<OrdersData>(context)
                            .selectedOrderLength(),
                        itemBuilder: (BuildContext context, int index) {
                          final ProductProvider productProvider =
                              Provider.of<OrdersData>(context)
                                  .selectedOrder
                                  .productsProviders[index];
                          return Column(
                            children: [
                              OrderListItem(
                                context: context,
                                index: index,
                                productProvider: productProvider,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            side: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await showOrderDialog(context: context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'CONFIRMAR',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color:
                                    Colors.green,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            side: BorderSide(
                              color: Colors.pink,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Provider.of<OrdersData>(context, listen: false)
                                .clearSelectedOrder();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'BORRAR',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
