import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/models/provider.dart';
import 'package:verdulera_app/screens/crud/create_proveedor.dart';
import 'package:verdulera_app/widgets/progress.dart';
import 'package:verdulera_app/widgets/provider_card.dart';

class ProvidersScreen extends StatefulWidget {
  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
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
                          'Proveedores',
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
                            builder: (context) => CreateProveedor(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (Provider.of<List<ProviderUser>>(context) == null) ...[
                circularProgress(),
              ],
              if (Provider.of<List<ProviderUser>>(context) != null) ...[
                if (Provider.of<List<ProviderUser>>(context).length < 1) ...[
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
                            'No se encontraron proveedores',
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
                if (Provider.of<List<ProviderUser>>(context).length >= 1) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 11.0,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:
                          Provider.of<List<ProviderUser>>(context).length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProviderListItem(
                          context: context,
                          index: index,
                          provider:
                              Provider.of<List<ProviderUser>>(context)[index],
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
