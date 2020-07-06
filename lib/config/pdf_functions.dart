import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/product_provider.dart';
import 'package:verdulera_app/models/provider.dart';

final _firestore = Firestore.instance;
final StorageReference storageRef = FirebaseStorage.instance.ref();

Future<String> uploadPdf(
    {@required File file,
    @required String path1,
    @required String path2}) async {
  StorageUploadTask uploadTask = storageRef
      .child(
        path1,
      )
      .child(
        path2,
      )
      .child(
        DateTime.now().toString(),
      )
      .putFile(
        file,
      );
  StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
  String downloadUrl = await storageSnap.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> updateOrderPdf(
    {@required String url, @required String orderUid}) async {
  await _firestore
      .collection('order')
      .document(orderUid)
      .updateData({'pdf': url});
}

Future<void> updateProviderPdf(
    {@required ProviderUser providerUser, @required String url}) async {
  await _firestore
      .collection('user')
      .document(providerUser.uid)
      .collection('providerSales')
      .add(
    {
      'total': providerUser.total,
      'numProducts': providerUser.numProducts,
      'pdf': url,
      'products': providerUser.providerJsonSimple(),
    },
  );
}

Future<void> uploadSummary(
    {@required String url, @required BuildContext context}) async {
  double totalOrderPrecio = 0;
  double totalOrderCosto = 0;
  double totalOrderUtilidad = 0;

  for (Order order in Provider.of<OrdersData>(context, listen: false).orders) {
    totalOrderPrecio += order.amount;
    totalOrderCosto += order.costo;
    totalOrderUtilidad += order.amount - order.costo;
  }

  await _firestore.collection('resumen').add(
    {
      'fecha': DateFormat('dd/MM/yyyy').format(
        DateTime.now(),
      ),
      'revenue': totalOrderPrecio,
      'costs': totalOrderCosto,
      'profit': totalOrderUtilidad,
      'orders': Provider.of<OrdersData>(context, listen: false).ordersJson(),
      'pdf': url,
    },
  );
}

List<pw.Widget> orderSummary({@required BuildContext context}) {
  List<pw.Widget> pdfWidgets = [];
  double totalOrderPrecio = 0;
  double totalOrderCosto = 0;
  double totalOrderUtilidad = 0;

  for (Order order in Provider.of<OrdersData>(context, listen: false).orders) {
    totalOrderCosto += order.costo;
    totalOrderPrecio += order.amount;
    totalOrderUtilidad += order.utilidad;
    if (Provider.of<OrdersData>(context, listen: false).orders.indexOf(order) ==
        0) {
      pdfWidgets.add(
        pw.Header(
          level: 0,
          child: pw.Container(
            child: pw.Row(
              children: [
                pw.Text(
                  "Órdenes: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                ),
                pw.SizedBox(
                  width: 10.0,
                ),
                /*pw.Image(
                    PdfImage.file(
                      pdf.document,
                      bytes: File('assets/images/logoAbasto.png')
                          .readAsBytesSync(),
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      );
    }
    pdfWidgets.add(
      pw.Header(
        level: 1,
        child: pw.Text(
          order.clientName,
        ),
      ),
    );
    pdfWidgets.add(
      pw.Table.fromTextArray(
        data: <List<String>>[
          <String>[
            "Producto",
            "Precio",
            "Costo",
            "Cantidad",
            "Total",
          ],
          for (ProductProvider product in order.productsProviders)
            <String>[
              product.name,
              product.price.toString(),
              product.cost.toString(),
              product.totalQuant.toString(),
              "${product.totalPrice - product.totalCost}",
            ],
        ],
      ),
    );
    pdfWidgets.add(
      pw.Header(
        level: 2,
        child: pw.Text("Resumen del pedido:"),
      ),
    );
    pdfWidgets.add(
      pw.Paragraph(
        text: "Ingresos: \$${order.amount}",
      ),
    );
    pdfWidgets.add(
      pw.Paragraph(
        text: "Costos: \$${order.costo}",
      ),
    );
    pdfWidgets.add(
      pw.Paragraph(
        text: "Utilidad: \$${order.utilidad}",
      ),
    );
    pdfWidgets.add(
      pw.SizedBox(
        height: 20.0,
      ),
    );
    if (Provider.of<OrdersData>(context, listen: false).orders.indexOf(order) ==
        Provider.of<OrdersData>(context, listen: false).orders.length - 1) {
      pdfWidgets.add(
        pw.Header(
          level: 0,
          text: 'Resumen del día',
        ),
      );
      pdfWidgets.add(
        pw.Paragraph(
          text: "Ingresos: \$$totalOrderPrecio",
        ),
      );
      pdfWidgets.add(
        pw.Paragraph(
          text: "Costos: \$$totalOrderCosto",
        ),
      );
      pdfWidgets.add(
        pw.Paragraph(
          text: "Utilidad: \$$totalOrderUtilidad",
        ),
      );
    }
  }

  return pdfWidgets;
}

Future<String> writeOnPdf({@required BuildContext context}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context pdfContext) {
        return orderSummary(context: context);
      },
    ),
  );

  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentPath = documentDirectory.path;
  File file = File("$documentPath/resumen.pdf");
  file.writeAsBytesSync(pdf.save());

  String url = await uploadPdf(
    file: file,
    path1: 'resumen',
    path2: Provider.of<UserData>(context, listen: false).user.email,
  );

  await uploadSummary(url: url, context: context);

  return file.path;
}

Future<List<String>> writeOrdersPdf({@required BuildContext context}) async {
  List<String> paths = [];
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentPath = documentDirectory.path;

  for (Order order in Provider.of<OrdersData>(context, listen: false).orders) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context pdfContext) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Container(
                child: pw.Row(
                  children: [
                    pw.Text(
                      "${order.clientName}: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                    ),
                    pw.SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            pw.Table.fromTextArray(
              data: <List<String>>[
                <String>[
                  "Producto",
                  "Precio",
                  "Cantidad",
                  "Total",
                ],
                for (ProductProvider product in order.productsProviders)
                  <String>[
                    product.name,
                    product.price.toString(),
                    product.totalQuant.toString(),
                    product.totalPrice.toString(),
                  ],
              ],
            ),
            pw.SizedBox(
              height: 10.0,
            ),
            pw.Header(
              level: 2,
              child: pw.Text("Resumen del pedido:"),
            ),
            pw.Paragraph(
              text: "Número de productos: ${order.productCount}",
            ),
            pw.Paragraph(
              text: "Total: \$${order.amount}",
            ),
          ];
        },
      ),
    );

    String pdfName = order.clientName;
    File file = File("$documentPath/$pdfName.pdf");
    file.writeAsBytesSync(pdf.save());

    String url = await uploadPdf(
      file: file,
      path1: 'orden',
      path2: order.clientEmail,
    );

    await updateOrderPdf(url: url, orderUid: order.uid);

    paths.add(file.path);
  }

  return paths;
}

Future<List<String>> writeProvidersPdf({@required BuildContext context}) async {
  List<String> paths = [];
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentPath = documentDirectory.path;

  for (ProviderUser provider
      in Provider.of<OrdersData>(context, listen: false).providers) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context pdfContext) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Container(
                child: pw.Row(
                  children: [
                    pw.Text(
                      "${provider.displayName}: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                    ),
                    pw.SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            pw.Table.fromTextArray(
              data: <List<String>>[
                <String>[
                  "Producto",
                  "Precio",
                  "Cantidades",
                  "Total",
                ],
                for (ProductProvider product in provider.products)
                  <String>[
                    product.name,
                    product.cost.toString(),
                    product.getQuantities(),
                    product.totalCost.toString(),
                  ],
              ],
            ),
            pw.SizedBox(
              height: 10.0,
            ),
            pw.Header(
              level: 2,
              child: pw.Text("Resumen del pedido:"),
            ),
            pw.Paragraph(
              text: "Número de productos: ${provider.numProducts}",
            ),
            pw.Paragraph(
              text: "Total: \$${provider.total}",
            ),
          ];
        },
      ),
    );

    String pdfName = provider.displayName;
    File file = File("$documentPath/$pdfName.pdf");
    file.writeAsBytesSync(pdf.save());

    String url = await uploadPdf(
      file: file,
      path1: 'provider',
      path2: provider.email,
    );

    await updateProviderPdf(providerUser: provider, url: url);

    paths.add(file.path);
  }

  return paths;
}
