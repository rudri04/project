import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/Model/grocery_item.dart';
import 'package:shopping_list/View/add_item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import '../Providers/CategoryProvider.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GroceryItem> groceryitem = [];
  var isloading = true;

  void _loaditems()async{
    final url = Uri.https('projectdemo-b27f8-default-rtdb.firebaseio.com','shopping-items.json');
    final response =await http.get(url);
    print(response.body);
    if(response.body == 'null'){
      setState(() {
        isloading = false;
      });
      return;
    }
    final Map<String,dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for(final list in listData.entries){
      final category = categories.entries.firstWhere((element)=>element.value.title == list.value['category']).value;
        loadedItems.add(
          GroceryItem(id: list.key, name: list.value['name'], quantity: list.value['quantity'], category:category )
        );
    }
    setState(() {
      groceryitem = loadedItems;
      isloading = false;
    });
  }
  @override
  void initState() {
    _loaditems();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    Widget content = const Center(child: Text('No items added yet.'));

    if(isloading){
      content = const Center(child: CircularProgressIndicator(),);
    }

    if (groceryitem.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryitem.length,
        itemBuilder: (ctx, index) => Dismissible(
          key:  ValueKey(groceryitem[index].id),
          onDismissed:  (direction) {
           categoryProvider.remove(groceryitem[index].id);
           groceryitem.remove(groceryitem[index]);
          },
          child: ListTile(
            title: Text(groceryitem[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryitem[index].category.color,
            ),
            trailing: Text(
              groceryitem[index].quantity.toString(),style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: () async {
            final newItems =await Get.to<GroceryItem>(()=>const AddItem());
            if(newItems == null){
              return;
            }
            setState(() {
              groceryitem.add(newItems);
            });
            _loaditems();

          }, icon: const Icon(Icons.add_outlined))
        ],
      ),
      body: content
    );
  }
}
