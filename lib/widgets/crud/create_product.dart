import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:provider/provider.dart';

import 'package:verdulera_app/models/category.dart';
import 'package:verdulera_app/models/product.dart';
import 'package:verdulera_app/models/provider.dart';

import '../progress.dart';

final _firestore = Firestore.instance;
final StorageReference storageRef = FirebaseStorage.instance.ref();

class CreateProduct extends StatefulWidget {
  final ProductElement productElement;

  CreateProduct({
    this.productElement,
  });

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();
  String name;
  double price;
  double costo;
  File file;
  bool selected = false;
  bool showSpinner = false;
  ProviderUser providerSelected;
  CategoryElement categoryReal;
  TextEditingController nameController;
  TextEditingController priceController;
  TextEditingController costoController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = ImagePicker();

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/vid_$name.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  showError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('Error'),
              ),
              Icon(Icons.error_outline, size: 60.0),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Hubo un error con la imagen seleccionada.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile filePicked = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (filePicked != null) {
      setState(() {
        file = File(filePicked.path);
        this.selected = true;
      });
    } else {
      showError();
    }
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile fileTaken = await _picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (fileTaken != null) {
        file = File(fileTaken.path);
        //this.file = fileTaken;
        this.selected = true;
      } else {
        showError();
      }
    });
  }

  selectImage({BuildContext parentContext}) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Seleccionar foto"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Tomar foto"),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text("Foto de la galería"),
              onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<void> createProduct() async {
    StorageUploadTask uploadTask = storageRef
        .child(
          'products',
        )
        .child(categoryReal.name)
        .child(
          DateTime.now().toString(),
        )
        .putFile(
          file,
        );
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    await _firestore.collection('product').add({
      'name': name,
      'price': price,
      'costo': costo,
      'imageUrl': downloadUrl,
      'proveedor': providerSelected.uid,
      'category': categoryReal.uid,
      'centro': 'qZ2IyTNz0VFSV1natPlG',
      'status': 'active',
    });

    categoryReal.cuenta++;

    await _firestore
        .collection('categories')
        .document(categoryReal.uid)
        .updateData({'cuenta': categoryReal.cuenta});
  }

  Future<void> updateProduct() async {
    if (file != null) {
      StorageUploadTask uploadTask = storageRef
          .child(
            'products',
          )
          .child(categoryReal.name)
          .child(
            DateTime.now().toString(),
          )
          .putFile(
            file,
          );
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();

      _firestore
          .collection('product')
          .document(widget.productElement.uid)
          .updateData({
        'name': name,
        'price': price,
        'costo': costo,
        'imageUrl': downloadUrl,
        'proveedor': providerSelected.uid,
        'category': categoryReal.uid,
        'centro': 'qZ2IyTNz0VFSV1natPlG',
      });
    } else {
      _firestore
          .collection('product')
          .document(widget.productElement.uid)
          .updateData({
        'name': name,
        'price': price,
        'costo': costo,
        'proveedor': providerSelected.uid,
        'category': categoryReal.uid,
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.productElement != null) {
      nameController = TextEditingController(text: widget.productElement.name);
      priceController =
          TextEditingController(text: widget.productElement.price.toString());
      costoController =
          TextEditingController(text: widget.productElement.costo.toString());
      name = widget.productElement.name;
      price = widget.productElement.price;
      costo = widget.productElement.costo;
    } else {
      nameController = TextEditingController();
      priceController = TextEditingController();
      costoController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        shrinkWrap: true,
        children: [
          if (Provider.of<List<CategoryElement>>(context) == null ||
              Provider.of<List<ProviderUser>>(context) == null) ...[
            circularProgress(),
          ],
          if (Provider.of<List<CategoryElement>>(context) != null &&
              Provider.of<List<ProviderUser>>(context) != null) ...[
            if (Provider.of<List<CategoryElement>>(context).length < 1 &&
                Provider.of<List<ProviderUser>>(context).length >= 1) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
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
                          Icons.fastfood,
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (Provider.of<List<CategoryElement>>(context).length >= 1 &&
                Provider.of<List<ProviderUser>>(context).length < 1) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No hay proveedores disponibles',
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
              ),
            ],
            if (Provider.of<List<CategoryElement>>(context).length < 1 &&
                Provider.of<List<ProviderUser>>(context).length < 1) ...[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No hay proveedores disponibles ni categorías disponibles',
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
                ),
              )
            ],
            if (Provider.of<List<CategoryElement>>(context).length >= 1 &&
                Provider.of<List<ProviderUser>>(context).length >= 1) ...[
              ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 35.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 250,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    validator: (val) => val.length < 1
                                        ? 'El nombre debe de tener valor'
                                        : null,
                                    onChanged: (newName) {
                                      setState(() {
                                        name = newName;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'NOMBRE',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    validator: (val) => val == null
                                        ? 'El precio debe de tener valor'
                                        : null,
                                    onChanged: (newPrice) {
                                      setState(() {
                                        price = double.parse(newPrice);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'PRECIO',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    controller: costoController,
                                    keyboardType: TextInputType.number,
                                    validator: (val) => val == null
                                        ? 'El costo debe de tener valor'
                                        : null,
                                    onChanged: (newCosto) {
                                      setState(() {
                                        costo = double.parse(newCosto);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'COSTO',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: 'CATEGORÍA',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    items: List<
                                            DropdownMenuItem<
                                                CategoryElement>>.generate(
                                        Provider.of<List<CategoryElement>>(
                                                context)
                                            .length, (int index) {
                                      final categoryLoop =
                                          Provider.of<List<CategoryElement>>(
                                              context)[index];
                                      if (widget.productElement != null &&
                                          categoryLoop.uid ==
                                              widget.productElement.category) {
                                        categoryReal = categoryLoop;
                                      }
                                      return DropdownMenuItem(
                                        value: categoryLoop,
                                        child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0)),
                                          height: 100.0,
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 2.0, 10.0, 0.0),
                                          //color: primaryColor,
                                          child: new Text(
                                            categoryLoop.name,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    onChanged: (CategoryElement newCategory) {
                                      setState(() {
                                        categoryReal = newCategory;
                                      });
                                    },
                                    isDense: true,
                                    value: widget.productElement != null
                                        ? categoryReal
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: 'PROVEEDOR',
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    items: List<
                                            DropdownMenuItem<
                                                ProviderUser>>.generate(
                                        Provider.of<List<ProviderUser>>(context).length, (int index) {
                                      final providerLoop = Provider.of<List<ProviderUser>>(context)[index];
                                      if (widget.productElement != null && widget.productElement.proveedor == providerLoop.uid) {
                                        providerSelected = providerLoop;
                                      }
                                      return DropdownMenuItem(
                                        value: providerLoop,
                                        child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0)),
                                          height: 100.0,
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 2.0, 10.0, 0.0),
                                          //color: primaryColor,
                                          child: new Text(
                                            providerLoop.displayName,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    onChanged: (ProviderUser newProvider) {
                                      setState(() {
                                        providerSelected = newProvider;
                                      });
                                    },
                                    isDense: true,
                                    value: widget.productElement != null
                                        ? providerSelected
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  if (widget.productElement == null) ...[
                                    !selected
                                        ? Center(
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20.0,
                                                ),
                                                side: BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              color: Colors.white,
                                              onPressed: () {
                                                selectImage(
                                                    parentContext: context);
                                              },
                                              child: Text(
                                                'ESCOGE UNA IMAGEN',
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 220.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Center(
                                              child: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: Container(
                                                  child: kIsWeb
                                                      ? Image.network(
                                                          file.path,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          file,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                  if (widget.productElement != null) ...[
                                    !selected
                                        ? Column(
                                            children: [
                                              Container(
                                                height: 220.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Center(
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Container(
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            circularProgressIndicator,
                                                        image: widget
                                                            .productElement
                                                            .imageUrl,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Center(
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                    side: BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    selectImage(
                                                        parentContext: context);
                                                  },
                                                  child: Text(
                                                    'CAMBIAR IMAGEN',
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                height: 220.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Center(
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Container(
                                                      child: kIsWeb
                                                          ? Image.network(
                                                              file.path,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              file,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Center(
                                                child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                    side: BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      selected = false;
                                                      file = null;
                                                    });
                                                  },
                                                  child: Text(
                                                    'CANCELAR',
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ]
                                ],
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.productElement == null) ...[
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        side: BorderSide(
                                          color: selected &&
                                                  providerSelected != null &&
                                                  categoryReal != null
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ),
                                      color: Colors.white,
                                      onPressed: providerSelected != null &&
                                              categoryReal != null
                                          ? () async {
                                              if (selected) {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    showSpinner = true;
                                                  });
                                                  await createProduct();
                                                  setState(() {
                                                    showSpinner = false;
                                                    selected = false;
                                                    file = null;
                                                    price = null;
                                                    costo = null;
                                                    categoryReal = null;
                                                    providerSelected = null;
                                                    name = null;
                                                    nameController.clear();
                                                    priceController.clear();
                                                    costoController.clear();
                                                  });
                                                  SnackBar snackbar = SnackBar(
                                                      content: Text(
                                                          'Producto creado con éxito'));
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(snackbar);
                                                }
                                              }
                                            }
                                          : () {},
                                      child: Text(
                                        'CREAR',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: selected &&
                                                    providerSelected != null &&
                                                    categoryReal != null
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        side: BorderSide(
                                          color: selected
                                              ? Colors.pink
                                              : Colors.blueGrey,
                                        ),
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        if (selected) {
                                          setState(() {
                                            selected = false;
                                            file = null;
                                            price = null;
                                            costo = null;
                                            categoryReal = null;
                                            providerSelected = null;
                                            name = null;
                                            nameController.clear();
                                            priceController.clear();
                                            costoController.clear();
                                          });
                                        }
                                      },
                                      child: Text(
                                        'CANCELAR',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: selected
                                                ? Colors.pink
                                                : Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (widget.productElement != null) ...[
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        side: BorderSide(
                                          color: providerSelected != null &&
                                                  categoryReal != null
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ),
                                      color: Colors.white,
                                      onPressed: providerSelected != null &&
                                              categoryReal != null
                                          ? () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                setState(() {
                                                  showSpinner = true;
                                                });
                                                await updateProduct();
                                                setState(() {
                                                  showSpinner = false;
                                                  selected = false;
                                                  file = null;
                                                  price = null;
                                                  costo = null;
                                                  categoryReal = null;
                                                  providerSelected = null;
                                                  name = null;
                                                  nameController.clear();
                                                  priceController.clear();
                                                  costoController.clear();
                                                });
                                                SnackBar snackbar = SnackBar(
                                                    content: Text(
                                                        'Producto creado con éxito'));
                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackbar);
                                                Timer(Duration(seconds: 2), () {
                                                  Navigator.pop(
                                                    context,
                                                  );
                                                });
                                              }
                                            }
                                          : () {},
                                      child: Text(
                                        'ACTUALIZAR',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: providerSelected != null &&
                                                    categoryReal != null
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        side: BorderSide(
                                          color: Colors.pink,
                                        ),
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          selected = false;
                                          file = null;
                                          price = null;
                                          costo = null;
                                          categoryReal = null;
                                          providerSelected = null;
                                          name = null;
                                          nameController.clear();
                                          priceController.clear();
                                          costoController.clear();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'CANCELAR',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
