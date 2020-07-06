import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/widgets/crud/create_category.dart';
import 'package:verdulera_app/widgets/crud/create_product.dart';

final _firestore = Firestore.instance;

class CreateCategoryProduct extends StatefulWidget {
  final CategoryElement categoryElement;
  final ProductElement productElement;

  CreateCategoryProduct({
    this.productElement,
    this.categoryElement,
  });

  @override
  _CreateCategoryProductState createState() => _CreateCategoryProductState();
}

class _CreateCategoryProductState extends State<CreateCategoryProduct>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  //TODO: added the tabBar and the tabBarView, removed the Column at the start and changed it for a ListView

  Future<void> deleteProduct() async {
    _firestore
        .collection('product')
        .document(widget.productElement.uid)
        .updateData({
      'status': 'inactive',
    });
  }

  Future<void> deleteCategory() async {
    _firestore
        .collection('categories')
        .document(widget.categoryElement.uid)
        .updateData({
      'status': 'inactive',
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.productElement != null) {
      tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    } else {
      tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    }
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
                      widget.productElement != null ||
                              widget.categoryElement != null
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
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Categoría/Producto",
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
                widget.categoryElement != null || widget.productElement != null
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          if (widget.categoryElement != null) {
                            await deleteCategory();
                            Navigator.pop(context);
                          } else {
                            await deleteProduct();
                            Navigator.pop(context);
                          }
                        },
                      )
                    : Container(),
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
                  'Categorías',
                  style: GoogleFonts.openSans(
                    fontSize: 21.0,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Productos',
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
                CreateCategory(
                  categoryElement: widget.categoryElement,
                ),
                CreateProduct(
                  productElement: widget.productElement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
