import 'package:verdulera_app/data/category_data.dart';
import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/screens/crud/create_category_product.dart';
import 'package:verdulera_app/screens/products_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'progress.dart';

class GridDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (Provider.of<List<CategoryElement>>(context) == null) ...[
            circularProgress(),
          ],
          if (Provider.of<List<CategoryElement>>(context) != null) ...[
            if (Provider.of<List<CategoryElement>>(context).length < 1) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No hay categorías disponibles',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.store,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (Provider.of<List<CategoryElement>>(context).length >= 1) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 11.0,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: Provider.of<List<CategoryElement>>(context).length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.0,
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    CategoryElement category = Provider.of<List<CategoryElement>>(context)[index];
                    int length = Provider.of<List<CategoryElement>>(context).length;
                    return Stack(
                      children: [
                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 500,
                                height: 250,
                                child: GestureDetector(
                                  onTap: () async {
                                    Provider.of<CategoryData>(context, listen: false)
                                        .setCategory(
                                            categoryElement:
                                                category);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProductsScreen(
                                          categoryCount: length,
                                          selectedUid: category.uid,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffa29aac),
                                            blurRadius: 20.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(5.0, 5.0),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.network(
                                            Provider.of<List<CategoryElement>>(
                                                    context)[index]
                                                .img,
                                            width: 42,
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            Provider.of<List<CategoryElement>>(
                                                    context)[index]
                                                .name,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            Provider.of<List<CategoryElement>>(
                                                    context)[index]
                                                .subtitle,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Color(0xffa29aac),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            '${Provider.of<List<CategoryElement>>(context)[index].cuenta} artículos',
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Color(0xffa29aac),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration:
                            BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateCategoryProduct(
                                        categoryElement:
                                        category,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
