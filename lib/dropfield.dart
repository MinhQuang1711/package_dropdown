// ignore_for_file: sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/dropitem.dart';
import 'package:flutter_application_1/view_models.dart';

class DropField<T> extends StatefulWidget {
  const DropField({super.key, required this.dropItem, this.onSelectedItem});
  final List<DropItem<T>> dropItem;
  final Function(T)? onSelectedItem;

  @override
  State<DropField<T>> createState() => _DropFieldState<T>();
}

class _DropFieldState<T> extends State<DropField<T>> {
  final dropViewModel = DropViewModel<T>();
  final _dropCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    dropViewModel.listenEventFocusOfDropField();
    dropViewModel.listenEventFocusOfSearchField();
  }

  void onTapDropField({bool? isShowing}) {
    if (isShowing != true) {
      dropViewModel.streamDropItem.add(widget.dropItem);
      dropViewModel.streamIsShowingEntry.sink.add(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dropCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dropViewModel.streamIsShowingEntry.stream,
      builder: (_, snapShot) {
        return Column(
          children: [
            TextFormField(
              controller: _dropCtrl,
              focusNode: dropViewModel.dropFocusNode,
              decoration: const InputDecoration(
                hintText: "Select something...",
                border: OutlineInputBorder(),
              ),
              onTap: () => onTapDropField(isShowing: snapShot.data),
              readOnly: true,
            ),
            _buildOverLay(isShowing: snapShot.data),
          ],
        );
      },
    );
  }

  Widget _buildOverLay({bool? isShowing}) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            right: borderSide,
            bottom: borderSide,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: borderRadius,
            bottomRight: borderRadius,
          )),
      width: MediaQuery.of(context).size.width,
      height: isShowing == true ? 200 : 0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: SearchField(
                dropItem: widget.dropItem,
                dropViewModel: dropViewModel,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
                stream: dropViewModel.streamDropItem.stream,
                builder: (_, snapShot) {
                  return _buildListItem(snapShot.data ?? []);
                }),
          ),
        ],
      ),
    );
  }

  ListView _buildListItem(List<DropItem<T>> list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (_, index) {
        if (list.isEmpty) {
          return const Text("Empty list");
        }
        return list[index].child ??
            ListTile(
              onTap: () {
                _dropCtrl.text = list[index].searchKey;
                widget.onSelectedItem?.call(list[index].value);
              },
              title: Text(list[index].searchKey),
            );
      },
    );
  }
}

class SearchField<T> extends StatefulWidget {
  const SearchField({
    super.key,
    required this.dropItem,
    required this.dropViewModel,
  });
  final List<DropItem<T>> dropItem;
  final DropViewModel<T> dropViewModel;

  @override
  State<SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  final _ctrl = TextEditingController();
  void onSearch(String? val) {
    setState(() {});
    List<DropItem<T>> result = [];
    for (var element in widget.dropItem) {
      if (element.searchKey.toLowerCase().contains(val?.toLowerCase() ?? "")) {
        result.add(element);
      }
    }
    widget.dropViewModel.streamDropItem.sink.add(result);
  }

  void deleteSearchValue() {
    _ctrl.clear();
    setState(() {});
    widget.dropViewModel.streamDropItem.sink.add(widget.dropItem);
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      child: TextField(
        onChanged: onSearch,
        controller: _ctrl,
        focusNode: widget.dropViewModel.searchFocusNode,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          hintText: "Seach by display name",
          suffixIcon: _ctrl.text.isEmpty
              ? Icon(Icons.search)
              : GestureDetector(
                  onTap: deleteSearchValue,
                  child: Icon(Icons.close),
                ),
          hintStyle: TextStyle(fontSize: 12),
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.all(11),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

const borderRadius = Radius.circular(6);
final borderSide = BorderSide(width: 0.5, color: Colors.grey.shade400);
