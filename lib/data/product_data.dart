import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/data/orders_data.dart';

import 'package:verdulera_app/models/product.dart';

class ProductData extends ChangeNotifier {

  void changeCosto(
      {double newCosto,
      ProductElement productElement,
      BuildContext context}) async {
    await productElement.changeCosto(newCosto: newCosto);
    Provider.of<OrdersData>(context, listen: false).changeCost(
      productUid: productElement.uid,
      proveedorUid: productElement.proveedor,
      newCosto: newCosto,
    );
    notifyListeners();
  }

  void changePriceNormal(
      {double newPrice,
        ProductElement productElement,
        @required BuildContext context}) async {
    await productElement.changePrice(newPrice: newPrice);
    Provider.of<OrdersData>(context, listen: false).changePrice(
      productUid: productElement.uid,
      newPrice: newPrice,
    );
    notifyListeners();
  }

  void changePriceBool({ProductElement productElement}) {
    productElement.changePriceBool();
    notifyListeners();
  }

  void changeCostoBool({ProductElement productElement}) {
    productElement.changeCostoBool();
    notifyListeners();
  }

  bool isPriceChanged({ProductElement productElement}) {
    return productElement.priceChange;
  }

  bool isCostoChanged({ProductElement productElement}) {
    return productElement.costoChange;
  }
}
