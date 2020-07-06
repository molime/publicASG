import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:verdulera_app/models/provider.dart';

final _firestore = Firestore.instance;

class CreateProveedor extends StatefulWidget {
  final ProviderUser providerUser;

  CreateProveedor({this.providerUser});

  @override
  _CreateProveedorState createState() => _CreateProveedorState();
}

class _CreateProveedorState extends State<CreateProveedor> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  String name;
  String email;
  TextEditingController nameController;
  TextEditingController emailController;

  Future<void> createProveedor() async {
    await _firestore.collection('user').add({
      'displayName': name,
      'email': email,
      'type': 'provider',
      'status': 'active',
    });
  }

  Future<void> updateProveedor() async {
    await _firestore
        .collection('user')
        .document(widget.providerUser.uid)
        .updateData({
      'displayName': name,
      'email': email,
    });
  }

  Future<void> deleteProveedor() async {
    await _firestore
        .collection('user')
        .document(widget.providerUser.uid)
        .updateData({
      'status': 'inactive',
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.providerUser != null) {
      nameController = TextEditingController(text: widget.providerUser.displayName);
      emailController = TextEditingController(text: widget.providerUser.email);
      name = widget.providerUser.displayName;
      email = widget.providerUser.email;
    } else {
      nameController = TextEditingController();
      emailController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          children: [
            SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 55,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.providerUser == null ? "Crear" : 'Actualizar',
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
                        "Proveedor",
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
                  widget.providerUser != null
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            await deleteProveedor();
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pop(context);
                          },
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: 19.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.only(
                  top: 35.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 250,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) => val.length < 1
                                      ? 'El nombre debe de tener valor'
                                      : null,
                                  onChanged: (newName) {
                                    setState(() {
                                      name = newName;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'NOMBRE COMPLETO',
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
                                  height: 20.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  validator: (val) =>
                                      !EmailValidator.validate(val, true)
                                          ? 'Email no válido'
                                          : null,
                                  onChanged: (newEmail) {
                                    setState(() {
                                      email = newEmail;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'EMAIL',
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
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                    side: BorderSide(
                                      color: name != null && email != null
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                  color: Colors.white,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      if (widget.providerUser == null) {
                                        await createProveedor();
                                      } else {
                                        await updateProveedor();
                                      }
                                      setState(() {
                                        showSpinner = false;
                                        name = null;
                                        email = null;
                                        nameController.clear();
                                        emailController.clear();
                                      });
                                      if (widget.providerUser != null) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Text(
                                    widget.providerUser == null
                                        ? 'CREAR'
                                        : 'ACTUALIZAR',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        color: name != null && email != null
                                            ? Colors.green
                                            : Colors.grey,
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
                                      color: name != null && email != null
                                          ? Colors.pink
                                          : Colors.blueGrey,
                                    ),
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      name = null;
                                      email = null;
                                      nameController.clear();
                                      emailController.clear();
                                    });
                                    if (widget.providerUser != null) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'CANCELAR',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        color: name != null && email != null
                                            ? Colors.pink
                                            : Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
