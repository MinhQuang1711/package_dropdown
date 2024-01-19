import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/dropitem.dart';

class DropViewModel<T> {
  final _dropFieldFocusNode = FocusNode();
  final _searchFieldFocusNode = FocusNode();
  final _streamIsShowingEntry = StreamController<bool>.broadcast();
  final _streamDropItemList = StreamController<List<DropItem<T>>>.broadcast();

  FocusNode get dropFocusNode => _dropFieldFocusNode;
  FocusNode get searchFocusNode => _searchFieldFocusNode;
  StreamController<bool> get streamIsShowingEntry => _streamIsShowingEntry;
  StreamController<List<DropItem<T>>> get streamDropItem => _streamDropItemList;

  void listenEventFocusOfDropField() {
    _dropFieldFocusNode.addListener(() {
      if (!_dropFieldFocusNode.hasFocus && !_searchFieldFocusNode.hasFocus) {
        _streamIsShowingEntry.sink.add(false);
      }
    });
  }

  void listenEventFocusOfSearchField() {
    _searchFieldFocusNode.addListener(() {
      if (!_dropFieldFocusNode.hasFocus && !searchFocusNode.hasFocus) {
        _streamIsShowingEntry.sink.add(false);
      }
    });
  }
}
