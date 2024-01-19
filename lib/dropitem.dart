import 'package:flutter/material.dart';

class DropItem<T> {
  final T value;
  final Widget? child;
  final String searchKey;
  DropItem({
    this.child,
    required this.value,
    required this.searchKey,
  });
}
