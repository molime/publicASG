import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:verdulera_app/data/canasta.dart';

import 'package:verdulera_app/models/product_cart.dart';
import '../cart_product_item.dart';
import '../creation_dialog.dart';

class CanastaSeleccionada extends StatefulWidget {
  @override
  _CanastaSeleccionadaState createState() => _CanastaSeleccionadaState();
}

class _CanastaSeleccionadaState extends State<CanastaSeleccionada> {
  bool showSpinner = false;
  String name;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (Provider.of<CanastaData>(context).canasta != null) {
      if (Provider.of<CanastaData>(context).canasta.name != null) {
        nameController = TextEditingController(text: Provider.of<CanastaData>(context).canasta.name);
        name = Provider.of<CanastaData>(context).canasta.name;
      } else {
        nameController = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<CanastaData>(context).canastaLength() < 1
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
                        itemCount:
                            Provider.of<CanastaData>(context).canastaLength(),
                        itemBuilder: (BuildContext context, int index) {
                          final ProductCart productCart =
                              Provider.of<CanastaData>(context)
                                  .canasta
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
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      validator: (val) => val.length < 1
                          ? 'El nombre debe de tener valor'
                          : null,
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
                              color: name != null ? Colors.green : Colors.grey,
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await showCanastaDialog(
                                  context: context, name: name);
                              setState(() {
                                name = null;
                                nameController.clear();
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'CONFIRMAR',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color:
                                    name != null ? Colors.green : Colors.grey,
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
                            Provider.of<CanastaData>(context, listen: false)
                                .clearCart();
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
