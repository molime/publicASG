import 'package:flutter/material.dart';

import 'package:verdulera_app/models/provider.dart';
import 'package:verdulera_app/screens/crud/create_proveedor.dart';

class ProviderListItem extends StatelessWidget {
  const ProviderListItem({
    Key key,
    @required this.context,
    @required this.index,
    @required this.provider,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final ProviderUser provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFF5AC035),
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
            title: provider.displayName != null
                ? Text(provider.displayName)
                : Text('No tiene nombre'),
            subtitle: provider.email != null
                ? Text(provider.email)
                : Text('No tiene correo'),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
              ),
              child: Text(
                'Editar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProveedor(
                      providerUser: provider,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
