import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/canasta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:verdulera_app/widgets/crud/canasta_seleccionada.dart';

final _firestore = Firestore.instance;

class CreateCanasta extends StatefulWidget {
  @override
  _CreateCanastaState createState() => _CreateCanastaState();
}

class _CreateCanastaState extends State<CreateCanasta>
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
      appBar: AppBar(
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
          'Canasta',
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
                    Provider.of<CanastaData>(context).canastaHasUid()
                        ? 'Actualizar'
                        : "Crear",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Provider.of<CanastaData>(context).canastaHasUid()
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            await _firestore
                                .collection('canastas')
                                .document(Provider.of<CanastaData>(context,
                                        listen: false)
                                    .canasta
                                    .uid)
                                .updateData({
                              'status': 'inactive',
                            });
                            Provider.of<CanastaData>(context, listen: false).clearCart();
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
                child: CanastaSeleccionada(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
