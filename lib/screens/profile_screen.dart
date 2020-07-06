import 'package:flutter/material.dart';
import 'package:verdulera_app/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verdulera_app/widgets/creation_dialog.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:verdulera_app/config/auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool changePassword = false;
  bool changeName = false;
  String password;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                      'assets/images/profile_pic.jpg',
                    ),
                  ),
                ),
                if (!changePassword && !changeName) ...[
                  Padding(
                    padding: EdgeInsets.all(
                      16.0,
                    ),
                    child: Column(
                      children: [
                        ProfileCard(
                          text: Provider.of<UserData>(context).user.email,
                          icon: Icons.alternate_email,
                        ),
                        ProfileCard(
                          text: Provider.of<UserData>(context)
                                      .user
                                      .displayName !=
                                  null
                              ? Provider.of<UserData>(context).user.displayName
                              : 'Nombre vacío',
                          icon: Icons.person,
                          onPressed: () async {
                            await showChangeNameDialog(
                                context: context,
                                nameController: TextEditingController(
                                  text: Provider.of<UserData>(context,
                                                  listen: false)
                                              .user
                                              .displayName !=
                                          null
                                      ? Provider.of<UserData>(context,
                                              listen: false)
                                          .user
                                          .displayName
                                      : '',
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        changePassword = true;
                      });
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
                      'CAMBIA DE CONTRASEÑA',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
                if (changePassword) ...[
                  Form(
                    key: _formKey,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: TextFormField(
                            obscureText: true,
                            controller: currentPasswordController,
                            validator: (val) => val.length < 6
                                ? 'La contraseña debe tener al menos 6 caracteres'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'CONTRASEÑA ACTUAL',
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
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: TextFormField(
                                onChanged: (newPassword) {
                                  setState(() {
                                    password = newPassword;
                                  });
                                },
                                obscureText: true,
                                controller: passwordController,
                                validator: (val) => val.length < 6
                                    ? 'La contraseña debe tener al menos 6 caracteres'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'NUEVA CONTRASEÑA',
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
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            passwordController.text ==
                                        passwordConfirmController.text &&
                                    passwordController.text.length > 0 &&
                                    passwordConfirmController.text.length > 0
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordConfirmController,
                                validator: (val) =>
                                    val != passwordController.text
                                        ? 'Las contraseñas deben ser iguales'
                                        : null,
                                decoration: InputDecoration(
                                  labelText: 'CONFIRMA CONTRASEÑA',
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
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            passwordController.text ==
                                        passwordConfirmController.text &&
                                    passwordController.text.length > 0 &&
                                    passwordConfirmController.text.length > 0
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    final userSignIn = await auth.signInWithEmailAndPassword(
                                      email: Provider.of<UserData>(context,
                                              listen: false)
                                          .user
                                          .email,
                                      password: currentPasswordController.text,
                                    );
                                    try {
                                      await userSignIn.user.updatePassword(password);
                                      SnackBar snackbar = SnackBar(
                                          content: Text(
                                              "¡Contraseña cambiada con éxito!"));
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                      setState(() {
                                        _formKey.currentState.reset();
                                        passwordController.clear();
                                        passwordConfirmController.clear();
                                        password = null;
                                        currentPasswordController.clear();
                                        changePassword = false;
                                      });
                                    } catch (errorChange) {
                                      SnackBar snackbar = SnackBar(
                                          content: Text(
                                              "Hubo un error cambiando la contraseña."));
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                      setState(() {
                                        _formKey.currentState.reset();
                                        passwordController.clear();
                                        passwordConfirmController.clear();
                                        password = null;
                                        currentPasswordController.clear();
                                        changePassword = false;
                                      });
                                    }
                                  } catch (errorSignIn) {
                                    SnackBar snackbar = SnackBar(
                                      content: Text(
                                        'Hubo un error con tu contraseña actual',
                                      ),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackbar);
                                    setState(() {
                                      _formKey.currentState.reset();
                                      passwordController.clear();
                                      passwordConfirmController.clear();
                                      password = null;
                                      currentPasswordController.clear();
                                      changePassword = false;
                                    });
                                  }
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
                                'CONFIRMAR',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                setState(() {
                                  changePassword = false;
                                });
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
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
