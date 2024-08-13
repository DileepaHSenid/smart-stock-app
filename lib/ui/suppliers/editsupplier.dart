import 'package:flutter/material.dart';
import 'package:project/controllers/supplier_controller.dart';

class EditSupplierPage extends StatefulWidget {
  final Map<String, dynamic> supplier;

  const EditSupplierPage({Key? key, required this.supplier}) : super(key: key);

  @override
  _EditSupplierPageState createState() => _EditSupplierPageState();
}

class _EditSupplierPageState extends State<EditSupplierPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  final SuppliersController _suppliersController = SuppliersController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.supplier['FirstName']);
    _lastNameController = TextEditingController(text: widget.supplier['LastName']);
    _contactPersonController = TextEditingController(text: widget.supplier['contactPerson']);
    _emailController = TextEditingController(text: widget.supplier['email']);
    _phoneController = TextEditingController(text: widget.supplier['phone']);
    _addressController = TextEditingController(text: widget.supplier['address']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateSupplier() async {
    if (_formKey.currentState!.validate()) {
      final updatedSupplier = {
        'id': widget.supplier['id'],
        'FirstName': _firstNameController.text,
        'LastName': _lastNameController.text,
        'contactPerson': _contactPersonController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
      };
      try {
        final success = await _suppliersController.updateSupplier(updatedSupplier);
        if (success) {
          Navigator.of(context).pop(updatedSupplier);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update supplier.')),
          );
        }
      } catch (error) {
        print('Error updating supplier: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(labelText: 'Contact Person'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateSupplier,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
