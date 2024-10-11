import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_list/Model/grocery_item.dart';
import 'package:shopping_list/View/add_item.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<GroceryItem> groceryitem = [];
  void _removeItem(GroceryItem item) {
    setState(() {
      groceryitem.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (groceryitem.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryitem.length,
        itemBuilder: (ctx, index) => Dismissible(
          key:  ValueKey(groceryitem[index].id),
          onDismissed:  (direction) {
            _removeItem(groceryitem[index]);
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
            final newitem =await Get.to<GroceryItem>(()=>const AddItem());
            if(newitem == null){
              return;
            }
            setState(() {
              groceryitem.add(newitem);
            });
          }, icon: const Icon(Icons.add_outlined))
        ],
      ),
      body: content
    );
  }
}
