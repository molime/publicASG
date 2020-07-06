import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verdulera_app/widgets/carrito_list.dart';
import 'package:verdulera_app/widgets/carrito_seleccionado.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
          'Carrito',
          style: GoogleFonts.openSans(
            fontSize: 20.0,
            color: Color(0xFF545D68),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(left: 20.0),
          children: [
            SizedBox(height: 15.0),
            Text(
              "Carrito",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            TabBar(
              controller: tabController,
              indicatorColor: Colors.transparent,
              labelColor: Theme.of(context).primaryColor,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text(
                    'Carrito actual',
                    style: GoogleFonts.openSans(
                      fontSize: 21.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Carritos guardados',
                    style: GoogleFonts.openSans(
                      fontSize: 21.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: tabController,
                children: [
                  CarroSeleccionado(),
                  CartList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
