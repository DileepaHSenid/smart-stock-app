import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/components/appbar.dart';
import 'package:project/utils/api_endpoints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AddSupplierPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({super.key});

  @override
  _AddSupplierPageState createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _contactPersonController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final supplierData = {
        'FirstName': _firstNameController.text,
        'LastName': _lastNameController.text,
        'contactPerson': _contactPersonController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
      };

      final String apiUrl = '${ApiEndpoints.baseUrl}${ApiEndpoints.authEndpoints.postSuppliers}';
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(supplierData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Supplier added successfully!')),
          );
          _clearForm(); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add supplier: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Supplier'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(32.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), 
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_firstNameController, 'First Name', 'First Name is required'),
                    const SizedBox(height: 16),
                    _buildTextField(_lastNameController, 'Last Name', 'Last Name is required'),
                    const SizedBox(height: 16),
                    _buildTextField(_contactPersonController, 'Contact Person', 'Contact Person is required'),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone', 'Phone is required', keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', 'Email is required', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Address', 'Address is required'),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _clearForm,
                            child: const Text('Clear'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(color: Colors.purple),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String validationMessage, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }
}
