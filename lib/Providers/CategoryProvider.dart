
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/Data/categories.dart';
import 'package:shopping_list/Model/category.dart';
import 'package:shopping_list/View/home_page.dart';
import 'package:shopping_list/data/categories.dart';
import '../Model/grocery_item.dart';

class CategoryProvider extends ChangeNotifier{
    final List<GroceryItem> groceryItem = [];

    List<GroceryItem> get item => groceryItem;
    final url = Uri.https('projectdemo-b27f8-default-rtdb.firebaseio.com','shopping-items.json');

    void add(String name , int qty,Category categories) async{
        try{
           final response = await http .post(url,
                headers: {
                    'Content-Type' : 'application/json',
                },
                body: json.encode({
                    'name': name,
                    'quantity':  qty,
                    'category': categories.title
                })
            );
            final Map<String,dynamic> resData = json.decode(response.body);
           Get.back(result:GroceryItem(id: resData['name'], name: name, quantity: qty, category: categories) );

        }
        catch(e){
            print('Exception while adding data ::: $e');
        }
        notifyListeners();
    }


    void remove(String item){
      var url = Uri.https('projectdemo-b27f8-default-rtdb.firebaseio.com','shopping-items/$item.json');
      try{
        http.delete(url);
      }
      catch(e){
        print('Exception while deleting data ::: $e');
      }
      notifyListeners();
    }



}