import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

import 'package:verdulera_app/models/product_cart.dart';
import 'package:verdulera_app/data/carts.dart';
import 'cart_product_item.dart';
import 'creation_dialog.dart';

class CarroSeleccionado extends StatefulWidget {
  @override
  _CarroSeleccionadoState createState() => _CarroSeleccionadoState();
}

class _CarroSeleccionadoState extends State<CarroSeleccionado> {
  DateTime _dateTime;
  bool showSpinner = false;
  String name;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Provider.of<CartsData>(context).selectedLength() < 1
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          Provider.of<CartsData>(context).selectedLength(),
                      itemBuilder: (BuildContext context, int index) {
                        final ProductCart productCart =
                            Provider.of<CartsData>(context)
                                .selectedCart
                                .shoppingCart[index];
                        return Column(
                          children: [
                            CartListItem(
                              context: context,
                              index: index,
                              productCart: productCart,
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
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _dateTime == null
                              ? 'No has seleccionado una fecha'
                              : DateFormat('dd/MM/yyyy').format(_dateTime),
                        ),
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
                            DateTime datePicked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                Duration(days: 14),
                              ),
                            );
                            setState(() {
                              _dateTime = datePicked;
                            });
                          },
                          child: Text(
                            'ESCOGE UNA FECHA',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Provider.of<CartsData>(context).selectedCart.uid == null
                      ? TextFormField(
                          controller: nameController,
                          onChanged: (typedName) {
                            setState(() {
                              name = typedName;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'NOMBRE CARRITO',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      shadowColor:
                          _dateTime != null ? Colors.greenAccent : Colors.grey,
                      color: _dateTime != null ? Colors.green : Colors.blueGrey,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: _dateTime != null
                            ? () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                await showCheckoutDialog(
                                    context: context,
                                    dateDeliver: _dateTime,
                                    name: name);
                                setState(() {
                                  showSpinner = false;
                                  nameController.clear();
                                });
                                Provider.of<CartsData>(context, listen: false)
                                    .removeCart();
                                Navigator.pop(context);
                              }
                            : null,
                        child: Center(
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
