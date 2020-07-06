import 'dart:collection';

import 'package:verdulera_app/models/category.dart';
import 'package:flutter/foundation.dart';


class CategoryData extends ChangeNotifier {
  List<CategoryElement> _categories = [];
  CategoryElement _categorySelected;
  int _indexSelected;

  int get indexSelected {
    return _categories.indexOf(_categorySelected);
  }

  UnmodifiableListView<CategoryElement> get categories {
    return UnmodifiableListView(_categories);
  }

  int get categoryCount {
    return _categories.length;
  }

  void setCategory ({CategoryElement categoryElement}) {
    if (_categories.indexWhere((element) => element.uid == categoryElement.uid) < 0) {
      _categorySelected = categoryElement;
      _indexSelected = _categories.indexOf(categoryElement);
      notifyListeners();
    } else {
      _categorySelected = _categories.firstWhere((element) => element.uid == categoryElement.uid);
      _indexSelected = _categories.indexWhere((element) => element.uid == categoryElement.uid);
      notifyListeners();
    }
  }
}