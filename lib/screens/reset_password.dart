import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:verdulera_app/config/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      15.0,
                      175.0,
                      0.0,
                      0.0,
                    ),
                    child: Text(
                      'Reestablecer contraseña',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      265.0,
                      175.0,
                      0.0,
                      0.0,
                    ),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 35.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => !EmailValidator.validate(val, true)
                          ? 'Email no válido'
                          : null,
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
                    SizedBox(
                      height: 45.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              await auth.sendPasswordResetEmail(
                                  email: emailController.text);
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.pop(context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            side: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          color: Colors.white,
                          child: Text(
                            'REESTABLECER',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0,),
                        RaisedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            side: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          color: Colors.white,
                          child: Text(
                            'CANCELAR',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.red,
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
          ],
        ),
      ),
    );
  }
}
