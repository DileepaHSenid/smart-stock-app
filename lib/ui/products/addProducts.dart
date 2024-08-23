import 'package:flutter/material.dart';
import 'package:project/controllers/category_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final CategoryController _categoryController = CategoryController();
  List<Category> _categories = [];
  List<SubCategory> _subCategories = [];
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _newSubCategoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _shippingIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityInStockController = TextEditingController();
  final TextEditingController _quantityToReceiveController = TextEditingController();
  final TextEditingController _supplierFirstNameController = TextEditingController();
  final TextEditingController _supplierLastNameController = TextEditingController();
  final TextEditingController _supplierIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryController.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchSubCategories(String categoryId) async {
    try {
      final subCategories = await _categoryController.fetchSubCategories(categoryId);
      setState(() {
        _subCategories = subCategories;
        _selectedSubCategoryId = null;
      });
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  void _onCategorySelected(String? categoryId) {
    if (categoryId != null) {
      setState(() {
        _selectedCategoryId = categoryId;
        _subCategories = [];
        _selectedSubCategoryId = null;
      });
      _fetchSubCategories(categoryId);
    }
  }

  Future<void> _addCategory(String name) async {
    try {
      await _categoryController.addCategory(name);
      _fetchCategories();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> _addSubCategory(String categoryId, String name) async {
    try {
      await _categoryController.addSubCategory(categoryId, name);
      _fetchSubCategories(categoryId);
    } catch (e) {
      print('Error adding subcategory: $e');
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: InputDecoration(hintText: 'Category Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addCategory(_newCategoryController.text);
                _newCategoryController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddSubCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Subcategory'),
          content: TextField(
            controller: _newSubCategoryController,
            decoration: InputDecoration(hintText: 'Subcategory Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_selectedCategoryId != null) {
                  _addSubCategory(_selectedCategoryId!, _newSubCategoryController.text);
                  _newSubCategoryController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _submitProduct() async {
  final product = {
    'name': _nameController.text,
    'status': _statusController.text,
    'shippingId': _shippingIdController.text,
    'description': _descriptionController.text,
    'price': double.tryParse(_priceController.text) ?? 0.0,
    'quantityInStock': int.tryParse(_quantityInStockController.text) ?? 0,
    'quantityToReceive': int.tryParse(_quantityToReceiveController.text) ?? 0,
    'lastOrderedDate': DateTime.now().toIso8601String(), 
    'categoryId': _selectedCategoryId,
    'supplierFirstName': _supplierFirstNameController.text,
    'supplierLastName': _supplierLastNameController.text,
    'supplierId': _supplierIdController.text,
    'subCategoryId': _selectedSubCategoryId,
  };

  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/products/create'), 
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(product),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    print('Product saved successfully');
  } else {
    print('Failed to save product: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextFormField(
              controller: _shippingIdController,
              decoration: InputDecoration(labelText: 'Shipping ID'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _quantityInStockController,
              decoration: InputDecoration(labelText: 'Quantity in Stock'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _quantityToReceiveController,
              decoration: InputDecoration(labelText: 'Quantity to Receive'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _supplierFirstNameController,
              decoration: InputDecoration(labelText: 'Supplier First Name'),
            ),
            TextFormField(
              controller: _supplierLastNameController,
              decoration: InputDecoration(labelText: 'Supplier Last Name'),
            ),
            TextFormField(
              controller: _supplierIdController,
              decoration: InputDecoration(labelText: 'Supplier ID'),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    hint: Text('Select Category'),
                    items: _categories.map((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: _onCategorySelected,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _showAddCategoryDialog,
                ),
              ],
            ),
            if (_selectedCategoryId != null)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSubCategoryId,
                      hint: Text('Select Subcategory'),
                      items: _subCategories.map((SubCategory subCategory) {
                        return DropdownMenuItem<String>(
                          value: subCategory.id,
                          child: Text(subCategory.name),
                        );
                      }).toList(),
                      onChanged: (String? subCategoryId) {
                        setState(() {
                          _selectedSubCategoryId = subCategoryId;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _showAddSubCategoryDialog,
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _submitProduct,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:project/controllers/category_controller.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AddProductPage extends StatefulWidget {
//   @override
//   _AddProductPageState createState() => _AddProductPageState();
// }

// class _AddProductPageState extends State<AddProductPage> {
//   final CategoryController _categoryController = CategoryController();
//   List<Category> _categories = [];
//   List<SubCategory> _subCategories = [];
//   List<SubCategory> _subSubCategories = []; // Added to manage nested subcategories
//   String? _selectedCategoryId;
//   String? _selectedSubCategoryId;
//   String? _selectedSubSubCategoryId; // Added to handle further nesting
//   final TextEditingController _newCategoryController = TextEditingController();
//   final TextEditingController _newSubCategoryController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();
//   final TextEditingController _shippingIdController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _quantityInStockController = TextEditingController();
//   final TextEditingController _quantityToReceiveController = TextEditingController();
//   final TextEditingController _supplierFirstNameController = TextEditingController();
//   final TextEditingController _supplierLastNameController = TextEditingController();
//   final TextEditingController _supplierIdController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//   }

//   Future<void> _fetchCategories() async {
//     try {
//       final categories = await _categoryController.fetchCategories();
//       setState(() {
//         _categories = categories;
//       });
//     } catch (e) {
//       print('Error fetching categories: $e');
//     }
//   }

//   Future<void> _fetchSubCategories(String categoryId) async {
//     try {
//       final subCategories = await _categoryController.fetchSubCategories(categoryId);
//       setState(() {
//         _subCategories = subCategories;
//         _selectedSubCategoryId = null;
//         _subSubCategories = []; // Clear sub-subcategories when category changes
//         _selectedSubSubCategoryId = null;
//       });
//     } catch (e) {
//       print('Error fetching subcategories: $e');
//     }
//   }

//   Future<void> _fetchSubSubCategories(String subCategoryId) async {
//     try {
//       final subSubCategories = await _categoryController.fetchSubCategories(subCategoryId); // Assuming endpoint can handle nested requests
//       setState(() {
//         _subSubCategories = subSubCategories;
//         _selectedSubSubCategoryId = null;
//       });
//     } catch (e) {
//       print('Error fetching sub-subcategories: $e');
//     }
//   }

//   void _onCategorySelected(String? categoryId) {
//     if (categoryId != null) {
//       setState(() {
//         _selectedCategoryId = categoryId;
//         _subCategories = [];
//         _selectedSubCategoryId = null;
//         _subSubCategories = [];
//         _selectedSubSubCategoryId = null;
//       });
//       _fetchSubCategories(categoryId);
//     }
//   }

//   void _onSubCategorySelected(String? subCategoryId) {
//     if (subCategoryId != null) {
//       setState(() {
//         _selectedSubCategoryId = subCategoryId;
//         _subSubCategories = [];
//         _selectedSubSubCategoryId = null;
//       });
//       _fetchSubSubCategories(subCategoryId);
//     }
//   }

//   Future<void> _addCategory(String name) async {
//     try {
//       await _categoryController.addCategory(name);
//       _fetchCategories();
//     } catch (e) {
//       print('Error adding category: $e');
//     }
//   }

//   Future<void> _addSubCategory(String categoryId, String name) async {
//     try {
//       await _categoryController.addSubCategory(categoryId, name);
//       _fetchSubCategories(categoryId);
//     } catch (e) {
//       print('Error adding subcategory: $e');
//     }
//   }

  

//   void _showAddCategoryDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New Category'),
//           content: TextField(
//             controller: _newCategoryController,
//             decoration: InputDecoration(hintText: 'Category Name'),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 _addCategory(_newCategoryController.text);
//                 _newCategoryController.clear();
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddSubCategoryDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add New Subcategory'),
//           content: TextField(
//             controller: _newSubCategoryController,
//             decoration: InputDecoration(hintText: 'Subcategory Name'),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 if (_selectedCategoryId != null) {
//                   _addSubCategory(_selectedCategoryId!, _newSubCategoryController.text);
//                   _newSubCategoryController.clear();
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddSubSubCategoryDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Add New Sub-Subcategory'),
//         content: TextField(
//           controller: _newSubCategoryController,
//           decoration: InputDecoration(hintText: 'Sub-Subcategory Name'),
//         ),
//         actions: [
//           TextButton(
//             child: Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: Text('Add'),
//             onPressed: () {
//               if (_selectedSubCategoryId != null) {
//                 _categoryController.addSubSubCategory(
//                     _selectedSubCategoryId!, _newSubCategoryController.text);
//                 _fetchSubSubCategories(_selectedSubCategoryId!);
//                 _newSubCategoryController.clear();
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//         ],
//       );
//     },
//   );
// }


//   void _submitProduct() async {
//     final product = {
//       'name': _nameController.text,
//       'status': _statusController.text,
//       'shippingId': _shippingIdController.text,
//       'description': _descriptionController.text,
//       'price': double.tryParse(_priceController.text) ?? 0.0,
//       'quantityInStock': int.tryParse(_quantityInStockController.text) ?? 0,
//       'quantityToReceive': int.tryParse(_quantityToReceiveController.text) ?? 0,
//       'lastOrderedDate': DateTime.now().toIso8601String(), 
//       'categoryId': _selectedCategoryId,
//       'supplierFirstName': _supplierFirstNameController.text,
//       'supplierLastName': _supplierLastNameController.text,
//       'supplierId': _supplierIdController.text,
//       'subCategoryId': _selectedSubCategoryId,
//       'subSubCategoryId': _selectedSubSubCategoryId, // Added for further nesting
//     };

//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:8080/products/create'), 
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(product),
//     );

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       print('Product saved successfully');
//     } else {
//       print('Failed to save product: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Product')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Product Name'),
//             ),
//             TextFormField(
//               controller: _statusController,
//               decoration: InputDecoration(labelText: 'Status'),
//             ),
//             TextFormField(
//               controller: _shippingIdController,
//               decoration: InputDecoration(labelText: 'Shipping ID'),
//             ),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             TextFormField(
//               controller: _priceController,
//               decoration: InputDecoration(labelText: 'Price'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _quantityInStockController,
//               decoration: InputDecoration(labelText: 'Quantity in Stock'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _quantityToReceiveController,
//               decoration: InputDecoration(labelText: 'Quantity to Receive'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _supplierFirstNameController,
//               decoration: InputDecoration(labelText: 'Supplier First Name'),
//             ),
//             TextFormField(
//               controller: _supplierLastNameController,
//               decoration: InputDecoration(labelText: 'Supplier Last Name'),
//             ),
//             TextFormField(
//               controller: _supplierIdController,
//               decoration: InputDecoration(labelText: 'Supplier ID'),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedCategoryId,
//                     hint: Text('Select Category'),
//                     items: _categories.map((Category category) {
//                       return DropdownMenuItem<String>(
//                         value: category.id,
//                         child: Text(category.name),
//                       );
//                     }).toList(),
//                     onChanged: _onCategorySelected,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: _showAddCategoryDialog,
//                 ),
//               ],
//             ),
//             if (_selectedCategoryId != null)
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: _selectedSubCategoryId,
//                           hint: Text('Select Subcategory'),
//                           items: _subCategories.map((SubCategory subCategory) {
//                             return DropdownMenuItem<String>(
//                               value: subCategory.id,
//                               child: Text(subCategory.name),
//                             );
//                           }).toList(),
//                           onChanged: _onSubCategorySelected,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: _showAddSubCategoryDialog,
//                       ),
//                     ],
//                   ),
//                   // if (_selectedSubCategoryId != null)
//                   //   Row(
//                   //     children: [
//                   //       Expanded(
//                   //         child: DropdownButtonFormField<String>(
//                   //           value: _selectedSubSubCategoryId,
//                   //           hint: Text('Select Subcategory'),
//                   //           items: _subSubCategories.map((SubCategory subSubCategory) {
//                   //             return DropdownMenuItem<String>(
//                   //               value: subSubCategory.id,
//                   //               child: Text(subSubCategory.name),
//                   //             );
//                   //           }).toList(),
//                   //           onChanged: (String? subSubCategoryId) {
//                   //             setState(() {
//                   //               _selectedSubSubCategoryId = subSubCategoryId;
//                   //             });
//                   //           },
//                   //         ),
//                   //       ),
//                   //       IconButton(
//                   //         icon: Icon(Icons.add),
//                   //         onPressed: () {
//                   //           // Handle adding Subcategory logic here if needed
//                   //         },
//                   //       ),
//                   //     ],
//                   //   ),

//                   if (_selectedSubCategoryId != null)
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 value: _selectedSubSubCategoryId,
//                                 hint: Text('Select Sub-Subcategory'),
//                                 items: _subSubCategories.map((SubCategory subSubCategory) {
//                                   return DropdownMenuItem<String>(
//                                     value: subSubCategory.id,
//                                     child: Text(subSubCategory.name),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? subSubCategoryId) {
//                                   setState(() {
//                                     _selectedSubSubCategoryId = subSubCategoryId;
//                                   });
//                                 },
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.add),
//                               onPressed: _showAddSubSubCategoryDialog, // Show dialog for adding sub-subcategory
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ElevatedButton(
//               onPressed: _submitProduct,
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
