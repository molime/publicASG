import 'package:verdulera_app/data/category_data.dart';
import 'package:verdulera_app/data/orders_data.dart';
import 'package:verdulera_app/data/product_data.dart';
import 'package:verdulera_app/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/client.dart';
import 'package:verdulera_app/screens/home_screen.dart';
import 'package:verdulera_app/data/carts.dart';
import 'package:verdulera_app/screens/splash_screen.dart';
import 'package:verdulera_app/data/canasta.dart';
import 'package:verdulera_app/config/database.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/provider.dart';
import 'package:verdulera_app/models/order.dart';
import 'package:verdulera_app/models/shopping_cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider<CategoryData>(
          create: (context) => CategoryData(),
        ),
        ChangeNotifierProvider<ProductData>(
          create: (context) => ProductData(),
        ),
        ChangeNotifierProvider<CartsData>(
          create: (context) => CartsData(),
        ),
        ChangeNotifierProvider<OrdersData>(
          create: (context) => OrdersData(),
        ),
        ChangeNotifierProvider<CanastaData>(
          create: (context) => CanastaData(),
        ),
        ChangeNotifierProvider<DatabaseService>(
          create: (context) => DatabaseService(),
        ),
        StreamProvider<List<ProductElement>>.value(
          value: DatabaseService().streamProducts(),
        ),
        StreamProvider<List<CategoryElement>>.value(
          value: DatabaseService().streamCategories(),
        ),
        StreamProvider<List<Client>>.value(
          value: DatabaseService().streamClients(),
        ),
        StreamProvider<List<ProviderUser>>.value(
          value: DatabaseService().streamProviders(),
        ),
        StreamProvider<List<Order>>.value(
          value: DatabaseService().streamOrders(),
        ),
        StreamProvider<List<ShoppingCart>>.value(
          value: DatabaseService().streamCanastas(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Abasto sin gasto',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.blueAccent,
        ),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          //SplashScreen.id: (context) => SplashScreen(),
        },
      ),
    );
  }
}
