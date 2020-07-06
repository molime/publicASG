import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/data/carts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/screens/crud/create_category_product.dart';

import 'package:verdulera_app/models/product.dart';

class ProductPage extends StatefulWidget {
  final String uid;

  ProductPage({this.uid});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList().length <1 ? Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No hay productos disponibles',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ),
              Icon(
                Icons.fastfood,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ) : ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Container(
            padding: EdgeInsets.only(
              right: 15.0,
            ),
            width: MediaQuery.of(context).size.width - 30.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GridView.builder(
              itemCount: Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList().length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (
                  BuildContext context,
                  int index,
                  ) {
                return _buildCard(
                  Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList()[index].name,
                  Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList()[index].price,
                  Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList()[index].imageUrl,
                  false,
                  false,
                  context,
                  Provider.of<List<ProductElement>>(context).where((element) => element.category == widget.uid).toList()[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 15.0,
          )
        ],
      )
    );
  }

  Widget _buildCard(
    String name,
    double price,
    String imgPath,
    bool added,
    bool isFavorite,
    context,
    ProductElement productElement,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Stack(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            elevation: 10.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                15.0,
              ),
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                        15.0,
                      ),
                    ),
                    Hero(
                      tag: imgPath,
                      child: Container(
                        height: 75.0,
                        width: 75.0,
                        child: FadeInImage.assetNetwork(
                          placeholder: circularProgressIndicator,
                          image: imgPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      '$price',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Color(
                            0xFF575E67,
                          ),
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                        8.0,
                      ),
                      child: Container(
                        color: Color(0xFFEBEBEB),
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (Provider.of<CartsData>(context).selectedCart ==
                                  null &&
                              Provider.of<CanastaData>(context).canasta ==
                                  null &&
                              Provider.of<OrdersData>(context).selectedOrder ==
                                  null) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.shopping_basket,
                                  color: Color(
                                    0xffa29aac,
                                  ),
                                  size: 12.0,
                                ),
                                Text(
                                  'Selecciona un cliente',
                                  style: TextStyle(
                                    fontFamily: 'Varela',
                                    color: Color(
                                      0xffa29aac,
                                    ),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                          if (Provider.of<CartsData>(context).selectedCart !=
                              null) ...[
                            if (!Provider.of<CartsData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              GestureDetector(
                                onTap: Provider.of<CartsData>(context)
                                        .ownerExists()
                                    ? () {
                                        Provider.of<CartsData>(context,
                                                listen: false)
                                            .addToCart(
                                                productElement: productElement);
                                      }
                                    : null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_basket,
                                      color: Provider.of<CartsData>(context)
                                              .ownerExists()
                                          ? Theme.of(context).primaryColor
                                          : Color(
                                              0xffa29aac,
                                            ),
                                      size: 12.0,
                                    ),
                                    Text(
                                      Provider.of<CartsData>(context)
                                              .ownerExists()
                                          ? 'Agregar al carrito'
                                          : 'Selecciona un cliente',
                                      style: TextStyle(
                                        fontFamily: 'Varela',
                                        color: Provider.of<CartsData>(context)
                                                .ownerExists()
                                            ? Theme.of(context).primaryColor
                                            : Color(
                                                0xffa29aac,
                                              ),
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (Provider.of<CartsData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              IconButton(
                                onPressed: () {
                                  Provider.of<CartsData>(context, listen: false)
                                      .minusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                              Text(
                                '${Provider.of<CartsData>(context).numProductAdded(productUid: productElement.uid)}',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Provider.of<CartsData>(context, listen: false)
                                      .plusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                            ],
                          ],
                          if (Provider.of<CanastaData>(context).canasta !=
                              null) ...[
                            if (!Provider.of<CanastaData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              GestureDetector(
                                onTap: () {
                                  Provider.of<CanastaData>(context,
                                          listen: false)
                                      .addToCart(
                                          productElement: productElement);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_basket,
                                      color: Theme.of(context).primaryColor,
                                      size: 12.0,
                                    ),
                                    Text(
                                      'Agregar al carrito',
                                      style: TextStyle(
                                        fontFamily: 'Varela',
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (Provider.of<CanastaData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              IconButton(
                                onPressed: () {
                                  Provider.of<CanastaData>(context,
                                          listen: false)
                                      .minusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                              Text(
                                '${Provider.of<CanastaData>(context).numProductAdded(productUid: productElement.uid)}',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Provider.of<CanastaData>(context,
                                          listen: false)
                                      .plusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                            ],
                          ],
                          if (Provider.of<OrdersData>(context).selectedOrder !=
                              null) ...[
                            if (!Provider.of<OrdersData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              GestureDetector(
                                onTap: () {
                                  Provider.of<OrdersData>(context,
                                          listen: false)
                                      .addToCart(
                                          productElement: productElement);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_basket,
                                      color: Theme.of(context).primaryColor,
                                      size: 12.0,
                                    ),
                                    Text(
                                      'Agregar al carrito',
                                      style: TextStyle(
                                        fontFamily: 'Varela',
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (Provider.of<OrdersData>(context)
                                .isProductContained(
                                    productUid: productElement.uid)) ...[
                              IconButton(
                                onPressed: () {
                                  Provider.of<OrdersData>(context,
                                          listen: false)
                                      .minusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                              Text(
                                '${Provider.of<OrdersData>(context).numProductAdded(productUid: productElement.uid)}',
                                style: TextStyle(
                                  fontFamily: 'Varela',
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Provider.of<OrdersData>(context,
                                          listen: false)
                                      .plusNum(productUid: productElement.uid);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 12.0,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                          productElement: productElement,
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
      ),
    );
  }
}
