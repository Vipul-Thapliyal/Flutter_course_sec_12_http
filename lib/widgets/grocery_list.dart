import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:http_backend_section_12/data/categories.dart';
import 'package:http_backend_section_12/models/grocery_item.dart';
import 'package:http_backend_section_12/widgets/new_item.dart';

/// Without FutureBuilder Before 230
class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  /// Before 228
  // void _loadItems() async{
  //   final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
  //   final response = await http.get(url);
  //
  //   if(response.statusCode >= 400) {
  //     setState(() {
  //       _error = "Failed to fetch data. Please try again later.";
  //     });
  //   }
  //
  //   if(response.body == "null") { /// Response is in data type string in FireBase
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return;
  //   }
  //
  //   final Map<String, dynamic> listData = json.decode(response.body);
  //   final List<GroceryItem> loadedItems = [];
  //
  //   for(final item in listData.entries) {
  //     final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value["category"]).value;
  //     loadedItems.add(
  //       GroceryItem(
  //         id: item.key,
  //         name: item.value["name"],
  //         quantity: item.value["quantity"],
  //         category: category
  //       )
  //     );
  //   }
  //
  //   setState(() {
  //     _groceryItems = loadedItems;
  //
  //   });
  // }

  /// Better Error Handling In Video 228
  void _loadItems() async{
    // final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
    final url = Uri.https("maximillisdfsdan-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");

    try {
      final response = await http.get(url);

      if(response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later.";
        });
      }

      if(response.body == "null") { /// Response is in data type string in FireBase
        setState(() {
          _isLoading = false;
        });
        return;
      }

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
            _isLoading = false;
      });
    }
    catch(err) {
      setState(() {
        _error = "Something went wrong! Please try again later.";
      });
    }
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

  void _removeItem(GroceryItem item) async {
    final index =  _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
      _isLoading = false;
    });

    final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list/${item.id}.json");
    final response = await http.delete(url);

    if(response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }


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

    if(_error != null) {
      content = Center(
        child: Text(_error!),
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

/// With FutureBuilder In 230 but it will not work
// class GroceryList extends StatefulWidget {
//   const GroceryList({Key? key}) : super(key: key);
//
//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }
//
// class _GroceryListState extends State<GroceryList> {
//   List<GroceryItem> _groceryItems = [];
//   String? _error;
//   late Future<List<GroceryItem>> _loadedItem;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadedItem = _loadItems();
//   }
//
//   /// Before 228
//   void _loadItems() async{
//     final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
//     final response = await http.get(url);
//
//     if(response.statusCode >= 400) {
//       setState(() {
//         _error = "Failed to fetch data. Please try again later.";
//       });
//     }
//
//     if(response.body == "null") { /// Response is in data type string in FireBase
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//
//     final Map<String, dynamic> listData = json.decode(response.body);
//     final List<GroceryItem> loadedItems = [];
//
//     for(final item in listData.entries) {
//       final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value["category"]).value;
//       loadedItems.add(
//         GroceryItem(
//           id: item.key,
//           name: item.value["name"],
//           quantity: item.value["quantity"],
//           category: category
//         )
//       );
//     }
//
//     setState(() {
//       _groceryItems = loadedItems;
//
//     });
//   }
//
//   /// Better Error Handling In Video 228
//   Future<List<GroceryItem>> _loadItems() async{
//     // final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
//     final url = Uri.https("maximillisdfsdan-sec-12-http-default-rtdb.firebaseio.com", "shopping-list.json");
//
//     final response = await http.get(url);
//
//     if(response.statusCode >= 400) {
//       throw Exception("Failed to fetch grocery items. Please try again later.");
//     }
//
//     if(response.body == "null") { /// Response is in data type string in FireBase
//       return [];
//     }
//
//     final Map<String, dynamic> listData = json.decode(response.body);
//     final List<GroceryItem> loadedItems = [];
//
//     for(final item in listData.entries) {
//       final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value["category"]).value;
//       loadedItems.add(
//         GroceryItem(
//           id: item.key,
//           name: item.value["name"],
//           quantity: item.value["quantity"],
//           category: category
//         )
//       );
//     }
//     return loadedItems;
//   }
//
//   void _addItem() async{
//     final newItem = await Navigator.of(context).push<GroceryItem>(
//         MaterialPageRoute(builder: (ctx) => const NewItem())
//     );
//
//     if(newItem == null) { /// If back button of device is pressed
//       return;
//     }
//
//     setState(() { /// If new item is added
//       _groceryItems.add(newItem);
//     });
//   }
//
//   void _removeItem(GroceryItem item) async {
//     final index =  _groceryItems.indexOf(item);
//
//     setState(() {
//       _groceryItems.remove(item);
//     });
//
//     final url = Uri.https("maximillian-sec-12-http-default-rtdb.firebaseio.com", "shopping-list/${item.id}.json");
//     final response = await http.delete(url);
//
//     if(response.statusCode >= 400) {
//       setState(() {
//         _groceryItems.insert(index, item);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Groceries"),
//         actions: [
//           IconButton(
//               onPressed: _addItem,
//               icon: const Icon(Icons.add)
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _loadedItem,
//         builder: (context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if(snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           }
//
//           if(snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text("No items added yet"),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (ctx, index) => Dismissible(
//               onDismissed: (direction) {
//                 _removeItem(snapshot.data![index]);
//               },
//               key: ValueKey(snapshot.data![index].id),
//               child: ListTile(
//                 title: Text(snapshot.data![index].name),
//                 leading: Container(
//                   width: 24,
//                   height: 24,
//                   color: snapshot.data![index].category.color,
//                 ),
//                 trailing: Text(snapshot.data![index].quantity.toString()),
//               ),
//             )
//           );
//         },
//       ),
//     );
//   }
// }
