import 'package:flutter/material.dart';

import '../Model/category.dart';



const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 160, 208, 178),
  ),
  Categories.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 141, 225, 221),
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(255, 160, 97, 12),
  ),
  Categories.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 84, 62, 87),
  ),
  Categories.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 175, 56, 73),
  ),
  Categories.sweets: Category(
    'Sweets',
    Color.fromARGB(92, 66, 9, 80),
  ),
  Categories.spices: Category(
    'Spices',
    Color.fromARGB(255, 87, 54, 10),
  ),
  Categories.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 67, 121, 86),
  ),
  Categories.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 44, 187, 179),
  ),
  Categories.other: Category(
    'Other',
    Color.fromARGB(90, 200, 167, 208),
  ),
};