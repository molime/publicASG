import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/screens/crud/create_client.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/widgets/client_detail.dart';
import 'package:verdulera_app/models/client.dart';
import 'package:verdulera_app/widgets/progress.dart';
import 'package:verdulera_app/widgets/reusable_components.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<Client> clients = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 110,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clientes',
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
                          "Inicio",
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
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateClient(),
                            ),
                          );
                        }),
                    cartIconButton(
                      context: context,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (Provider.of<List<Client>>(context) == null || Provider.of<List<ProductElement>>(context) == null) ...[
                circularProgress(),
              ],
              if (Provider.of<List<Client>>(context) != null && Provider.of<List<ProductElement>>(context) != null) ...[
                if (Provider.of<List<Client>>(context).length < 1) ...[
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
                            'No se encontraron clientes',
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (Provider.of<List<Client>>(context).length >= 1) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 11.0,
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: Provider.of<List<Client>>(context).length,
                      itemBuilder: (BuildContext context, int index) {
                        Client client = Provider.of<List<Client>>(context)[index];
                        client.completeClient(context: context);
                        return ClientListItem(
                          context: context,
                          index: index,
                          client: client,
                        );
                      },
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}
