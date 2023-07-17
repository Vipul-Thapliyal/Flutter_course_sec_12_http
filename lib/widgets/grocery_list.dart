import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:http_backend_section_12/data/categories.dart';
import 'package:http_backend_section_12/models/grocery_item.dart';
import 'package:http_backend_section_12/widgets/new_item.dart';


class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  void _loadItems() async{
    final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    for(final item in listData.entries) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value["category"]).value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category
        )
      );
    }

    setState(() {
      _groceryItems = loadedItems;

    });
  }

  void _addItem() async{
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem())
    );

    if(newItem == null) { /// If back button of device is pressed
      return;
    }

    setState(() { /// If new item is added
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No items added yet"),
    );

    if(_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if(_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
           IconButton(
            onPressed: _addItem,
             icon: const Icon(Icons.add)
           )
        ],
      ),
      body: content,
    );
  }
}
