import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/models/category.dart';

import 'package:verdulera_app/widgets/product_page.dart';

class ProductsScreen extends StatefulWidget {
  final int categoryCount;
  final String selectedUid;

  ProductsScreen({@required this.categoryCount, this.selectedUid,});
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  int indexDisplay;
  TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    indexDisplay = Provider.of<List<CategoryElement>>(context, listen: false).indexWhere((category) => category.uid == widget.selectedUid);
    tabController = TabController(length: widget.categoryCount, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: indexDisplay,
      length:Provider.of<List<CategoryElement>>(context).length,
      child: Scaffold(
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
            'Categorías',
            style: GoogleFonts.openSans(
              fontSize: 20.0,
              color: Color(0xFF545D68),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications_none, color: Color(0xFF545D68)),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 20.0),
          children: <Widget>[
            SizedBox(height: 15.0),
            Text('Categorías',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 15.0),
            TabBar(
              indicatorColor: Colors.transparent,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              tabs: List<GestureDetector>.generate(Provider.of<List<CategoryElement>>(context).length, (int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      indexDisplay = index;
                    });
                  },
                  child: Tab(
                    child: Text(
                      Provider.of<List<CategoryElement>>(context)[index].name,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: indexDisplay == index ? Theme.of(context).primaryColor : Color(0xFFCDCDCD),
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                //controller: tabController,
                children: List<ProductPage>.generate(
                  Provider.of<List<CategoryElement>>(context).length,
                      (int index) {
                    return ProductPage(uid: Provider.of<List<CategoryElement>>(context)[indexDisplay].uid,);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
