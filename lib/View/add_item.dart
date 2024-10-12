import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/Data/categories.dart';
import 'package:shopping_list/Model/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/Model/grocery_item.dart';
class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final formkey = GlobalKey<FormState>();
  var name ='';
  var qty = 1;
  var category = categories[Categories.sweets]!;
  var issending = false;
  final url = Uri.https('projectdemo-b27f8-default-rtdb.firebaseio.com','shopping-items.json');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  counterText: '',
                  labelText: "Enter name",
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Please Enter Name";
                  }
                  return null;
                },
                onSaved: (value){
                  name = value!;
                },
              ),
              const SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter Quantity'
                      ),
                      initialValue: qty.toString(),
                      validator: (value){
                        if(value!.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <=0){
                          return "Please Enter valid Quantity";
                        }
                        return null;
                      },
                      onSaved: (value){
                        qty = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: DropdownButtonFormField(
                        items: [
                      for(final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                            child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              color: category.value.color,
                            ),
                            const SizedBox(width: 5,),
                            Text(category.value.title),
                          ],
                        ))
                    ],
                        value: category,
                        onChanged: (value){
                          setState(() {
                            category = value!;
                          });
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: issending? null : (){
                    formkey.currentState!.reset();
                  }, child: const Text('Reset')),
                  const SizedBox(width: 8,),
                  ElevatedButton(onPressed: issending? null : () async{
                    if( formkey.currentState!.validate()){
                      formkey.currentState!.save();
                      setState(() {
                        issending =true;
                      });
                      final response = await http .post(url,
                      headers: {
                        'Content-Type' : 'application/json',
                      },
                        body: json.encode({
                          'name': name,
                          'quantity':  qty,
                          'category': category.title
                        })
                      );
                      // print(response.body);
                      // print(response.statusCode);
                      final Map<String,dynamic> resData = json.decode(response.body);
                      if(!context.mounted){
                        return;
                      }
                      Navigator.of(context).pop(GroceryItem(id: resData['name'], name: name, quantity: qty, category: category));

                    }
                  }, child:issending ?
                    const SizedBox(height: 15,width: 15,child: CircularProgressIndicator(),)  :
                  const Text('Submit'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
