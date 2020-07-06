import 'package:verdulera_app/config/push_notification.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:verdulera_app/screens/orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:verdulera_app/config/auth.dart';
import 'package:verdulera_app/screens/reset_password.dart';
import 'categories_screen.dart';
import 'clients_screen.dart';
import 'providers_screen.dart';
import 'profile_screen.dart';
import 'package:verdulera_app/models/user.dart';
import 'package:verdulera_app/config/database.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  PageController pageController;
  int pageIndex = 0;
  String userEmail;
  String userPassword;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    initialiseFCM();
  }

  handleSignIn(FirebaseUser firebaseUser, BuildContext context) async {
    if (firebaseUser != null) {
      User user = await silentSignIn(fireUser: firebaseUser, context: context);
      Provider.of<UserData>(context, listen: false).setUser(user: user);
    }
  }

  showError({String error}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('Error'),
              ),
              Icon(Icons.error_outline, size: 60.0),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  error ?? '',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen({@required BuildContext context}) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          ClientsScreen(),
          OrdersScreen(),
          CategoriesScreen(),
          ProvidersScreen(),
          ProfileScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
              ),
              title: Text(
                'Clientes',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              title: Text(
                'Pedidos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
              ),
              title: Text(
                'Productos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.directions_car,
              ),
              title: Text(
                'Proveedores',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              title: Text(
                'Perfil',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
              ),
            ),
          ]),
    );
  }

  Scaffold unauthScreen(context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Bienvenido',
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => !EmailValidator.validate(val, true)
                          ? 'Email no válido'
                          : null,
                      onChanged: (typedEmail) {
                        setState(() {
                          userEmail = typedEmail;
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
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      validator: (val) => val.length < 6
                          ? 'La contraseña debe tener 6 caracteres mínimo'
                          : null,
                      onChanged: (password) {
                        setState(() {
                          userPassword = password;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'CONTRASEÑA',
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
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      alignment: Alignment(
                        1.0,
                        0.0,
                      ),
                      padding: EdgeInsets.only(
                        top: 15.0,
                        left: 20.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    GestureDetector(
                      onTap: userEmail != null && userPassword != null
                          ? () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          Map result = await signIn(
                              email: userEmail,
                              password: userPassword,
                              context: context);
                          if (result['result'] != 'success') {
                            showError(error: result['error']);
                            setState(() {
                              onPageChanged(0);
                              onTap(0);
                              showSpinner = false;
                            });
                          }

                          setState(() {
                            showSpinner = false;
                          });
                        }
                      }
                          : null,
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'LOGIN',
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    auth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        handleSignIn(firebaseUser, context);
        Provider.of<DatabaseService>(context, listen: false).logIn();
      } else {
        onPageChanged(0);
        onTap(0);
        Provider.of<UserData>(context, listen: false).clearUser();
        Provider.of<DatabaseService>(context, listen: false).logOut();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<UserData>(context).userExists()
        ? buildAuthScreen(context: context)
        : unauthScreen(context);
  }
}
