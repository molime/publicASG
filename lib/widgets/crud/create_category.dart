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

import 'package:verdulera_app/models/category.dart';

final _firestore = Firestore.instance;
final StorageReference storageRef = FirebaseStorage.instance.ref();

class CreateCategory extends StatefulWidget {
  final CategoryElement categoryElement;

  CreateCategory({
    this.categoryElement,
  });

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String subtitle;
  File file;
  bool selected = false;
  bool showSpinner = false;
  TextEditingController nameController;
  TextEditingController subtitleController;
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

  Future<void> createCategory() async {
    StorageUploadTask uploadTask = storageRef
        .child(
          'categories',
        )
        .child(
          DateTime.now().toString(),
        )
        .putFile(
          file,
        );
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    await _firestore.collection('categories').add({
      'name': name,
      'subtitle': subtitle,
      'cuenta': 0,
      'img': downloadUrl,
      'centro': 'qZ2IyTNz0VFSV1natPlG',
      'status': 'active',
    });
  }

  Future<void> updateCategory() async {
    if (file != null) {
      StorageUploadTask uploadTask = storageRef
          .child(
            'categories',
          )
          .child(
            DateTime.now().toString(),
          )
          .putFile(
            file,
          );
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();

      _firestore
          .collection('categories')
          .document(widget.categoryElement.uid)
          .updateData({
        'name': name,
        'subtitle': subtitle,
        'img': downloadUrl,
      });
    } else {
      _firestore
          .collection('categories')
          .document(widget.categoryElement.uid)
          .updateData({
        'name': name,
        'subtitle': subtitle,
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.categoryElement != null) {
      nameController = TextEditingController(text: widget.categoryElement.name);
      subtitleController = TextEditingController(text: widget.categoryElement.subtitle);
      name = widget.categoryElement.name;
      subtitle = widget.categoryElement.subtitle;
    } else {
      nameController = TextEditingController();
      subtitleController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: EdgeInsets.only(
              top: 35.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (val) => val == null
                            ? 'El título debe de tener valor'
                            : null,
                        onChanged: (newName) {
                          setState(() {
                            name = newName;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'TÍTULO',
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
                        controller: subtitleController,
                        validator: (val) => val == null
                            ? 'El subtítulo debe de tener valor'
                            : null,
                        onChanged: (newSubtitle) {
                          setState(() {
                            subtitle = newSubtitle;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'SUBTÍTULO',
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
                      if (widget.categoryElement == null) ...[
                        !selected
                            ? Center(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                    side: BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    selectImage(parentContext: context);
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
                                width: MediaQuery.of(context).size.width * 0.8,
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
                      ],
                      if (widget.categoryElement != null) ...[
                        !selected
                            ? Column(
                                children: [
                                  Container(
                                    height: 220.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Center(
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Container(
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                circularProgressIndicator,
                                            image: widget.categoryElement.img,
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
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        side: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                      color: Colors.white,
                                      onPressed: () {
                                        selectImage(parentContext: context);
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
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
                                        borderRadius: BorderRadius.circular(
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.categoryElement == null) ...[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              side: BorderSide(
                                color: selected ? Colors.green : Colors.grey,
                              ),
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              if (selected) {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await createCategory();
                                  setState(() {
                                    showSpinner = false;
                                    selected = false;
                                    file = null;
                                    subtitle = null;
                                    name = name;
                                    nameController.clear();
                                    subtitleController.clear();
                                  });
                                  SnackBar snackbar = SnackBar(
                                    content: Text('Categoría creada con éxito'),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackbar);
                                }
                              }
                            },
                            child: Text(
                              'CREAR',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: selected ? Colors.green : Colors.grey,
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
                                color: selected ? Colors.pink : Colors.blueGrey,
                              ),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              if (selected) {
                                setState(() {
                                  selected = false;
                                  file = null;
                                  subtitle = null;
                                  name = null;
                                });
                              }
                            },
                            child: Text(
                              'CANCELAR',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color:
                                      selected ? Colors.pink : Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (widget.categoryElement != null) ...[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                              side: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                await updateCategory();
                                setState(() {
                                  showSpinner = false;
                                  selected = false;
                                  file = null;
                                  subtitle = null;
                                  name = name;
                                  nameController.clear();
                                  subtitleController.clear();
                                });
                                SnackBar snackbar = SnackBar(
                                  content:
                                      Text('Categoría actualizada con éxito'),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                                Timer(Duration(seconds: 2), () {
                                  Navigator.pop(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text(
                              'ACTUALIZAR',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.green,
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
                                subtitle = null;
                                name = null;
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
            ),
          ),
        ),
      ),
    );
  }
}
