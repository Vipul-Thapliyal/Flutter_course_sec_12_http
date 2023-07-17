import 'package:flutter/material.dart';
import 'package:http_backend_section_12/models/category.dart';

const categories = {
  Categories.vegetables: Categorys(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Categorys(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Categorys(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Categorys(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Categorys(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Categorys(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Categorys(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Categorys(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Categorys(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Categorys(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};