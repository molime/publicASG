import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/widgets/crud/orden_seleccionada.dart';

final _firestore = Firestore.instance;

class UpdateOrder extends StatefulWidget {
  final bool isInEdit;

  UpdateOrder({
    this.isInEdit: false,
  });

  @override
  _UpdateOrderState createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isInEdit ? Container() : AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Orden',
          style: GoogleFonts.openSans(
            fontSize: 20.0,
            color: Color(0xFF545D68),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(left: 20.0),
            children: [
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Actualizar',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Provider.of<OrdersData>(context).selectedOrderHasUid()
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            await _firestore
                                .collection('order')
                                .document(Provider.of<OrdersData>(context,
                                        listen: false)
                                    .selectedOrder
                                    .uid)
                                .delete();
                            Provider.of<OrdersData>(context, listen: false)
                                .clearSelectedOrder();
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pop(context);
                          },
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: OrdenSeleccionada(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
