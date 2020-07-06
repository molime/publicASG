import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verdulera_app/screens/crud/create_category_product.dart';
import 'package:verdulera_app/widgets/grid_dashboard.dart';
import 'package:verdulera_app/widgets/canastas.dart';
import 'package:verdulera_app/widgets/reusable_components.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  //TODO: added the tabBar and the tabBarView, removed the Column at the start and changed it for a ListView

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 16, right: 16),
        children: [
          //SizedBox(height: 15.0),
          SizedBox(
            height: 110,
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
                      "Categorías",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateCategoryProduct(),
                      ),
                    );
                  },
                ),
                canastaIconButton(
                  context: context,
                ),
                cartIconButton(
                  context: context,
                ),
              ],
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
                  'Productos',
                  style: GoogleFonts.openSans(
                    fontSize: 21.0,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Canastas',
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
                GridDashboard(),
                Canastas(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
