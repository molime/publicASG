import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart';

import 'package:verdulera_app/data/category_data.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/data/product_data.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/config/pdf_functions.dart';
import 'pdf_screen.dart';
import 'package:verdulera_app/config/mailer.dart';

class ProductsEditToday extends StatefulWidget {
  @override
  _ProductsEditTodayState createState() => _ProductsEditTodayState();
}

class _ProductsEditTodayState extends State<ProductsEditToday> {
  List<String> paths = [];
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Provider.of<OrdersData>(context, listen: false).backPage();
              Navigator.pop(context);
            }),
        title: Text('Artículos a editar'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Provider.of<OrdersData>(context).todayProducts.length < 1 ? Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No se encontraron órdenes',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                Icon(
                  Icons.list,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: Provider.of<OrdersData>(context).todayProducts.length,
                  itemBuilder: (context, index) {
                    ProductElement productElement =
                    Provider.of<OrdersData>(context).todayProducts[index];
                    final priceController = MoneyMaskedTextController(
                        decimalSeparator: '.', thousandSeparator: ',');
                    final costController = MoneyMaskedTextController(
                        decimalSeparator: '.', thousandSeparator: ',');
                    return _buildTile(productElement, context,
                        priceController: priceController,
                        costController: costController);
                  }),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 40.0,
              child: Material(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                shadowColor: Colors.greenAccent,
                color: Colors.green,
                elevation: 7.0,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    String pathSingle =
                    await writeOnPdf(context: context);
                    paths = await writeOrdersPdf(
                      context: context,
                    );
                    paths
                      ..addAll(
                        await writeProvidersPdf(context: context),
                      );
                    paths.add(pathSingle);
                    //sendEmail(context);
                    Mailer().emailSender(emailRecipient: Provider.of<UserData>(context, listen: false).user.email, paths: paths);
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfScreen(
                          path: pathSingle,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      'Confirmar',
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
    );
  }

  Widget _buildTile(ProductElement productElement, context,
      {MoneyMaskedTextController priceController,
      MoneyMaskedTextController costController}) {
    String category = Provider.of<CategoryData>(context, listen: false)
        .categories
        .singleWhere((element) => productElement.category == element.uid,
            orElse: () {
      return CategoryElement(name: 'No category');
    }).name;
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            height: 150,
            width: 150,
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl: productElement.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  productElement.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category ?? 'No category',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    10.0,
                    0.0,
                    10.0,
                    10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Provider.of<ProductData>(context)
                                  .isPriceChanged(
                                      productElement: productElement)
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onChanged: (value) {
                          Provider.of<ProductData>(context, listen: false)
                              .changePriceNormal(
                            newPrice: double.parse(value),
                            productElement: productElement,
                            context: context,
                          );
                          Provider.of<ProductData>(context, listen: false)
                              .changePriceBool(productElement: productElement);
                          //productElement.changePriceBool();
                        },
                        initialValue: productElement.price != null
                            ? productElement.price.toString()
                            : '0',
                        decoration: InputDecoration(
                          labelText: 'PRECIO',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ProductData>(context)
                                    .isPriceChanged(
                                        productElement: productElement)
                                ? Colors.green
                                : Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Provider.of<ProductData>(context)
                                  .isCostoChanged(
                                      productElement: productElement)
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onChanged: (value) {
                          Provider.of<ProductData>(context, listen: false)
                              .changeCosto(
                            newCosto: double.parse(value),
                            productElement: productElement,
                            context: context,
                          );
                          Provider.of<ProductData>(context, listen: false)
                              .changeCostoBool(productElement: productElement);
                        },
                        initialValue: productElement.costo != null
                            ? productElement.costo.toString()
                            : '0',
                        decoration: InputDecoration(
                          labelText: 'COSTO',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ProductData>(context)
                                    .isCostoChanged(
                                        productElement: productElement)
                                ? Colors.green
                                : Colors.grey,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
