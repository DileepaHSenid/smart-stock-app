import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import 'package:project/controllers/supplier_controller.dart';
import 'package:project/ui/suppliers/addsupplier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Suppliers(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Suppliers extends StatelessWidget {
  const Suppliers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Suppliers'),
      body: SuppliersPage(),
    );
  }
}

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  _SuppliersPageState createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  List<Map<String, dynamic>> suppliers = [];
  List<Map<String, dynamic>> filteredSuppliers = [];
  bool isLoading = true;
  final SuppliersController suppliersController = SuppliersController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      final fetchedSuppliers = await suppliersController.fetchSuppliers();
      setState(() {
        suppliers = fetchedSuppliers;
        filteredSuppliers = fetchedSuppliers;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching suppliers: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSuppliers(String query) {
    final filtered = suppliers.where((supplier) {
      final name = '${supplier['firstName']} ${supplier['lastName']}'.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSuppliers = filtered;
    });
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      final success = await suppliersController.deleteSupplier(supplierId);
      if (success) {
        setState(() {
          suppliers.removeWhere((supplier) => supplier['id'] == supplierId);
          filteredSuppliers.removeWhere((supplier) => supplier['id'] == supplierId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Supplier deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete supplier.')),
        );
      }
    } catch (error) {
      print('Error deleting supplier: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _showSupplierDetails(Map<String, dynamic> supplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('${supplier['firstName']} ${supplier['lastName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Contact Person:', supplier['contactPerson']),
              _buildDetailRow('Email:', supplier['email']),
              _buildDetailRow('Phone:', supplier['phone']),
              _buildDetailRow('Address:', supplier['address']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement the edit functionality here
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(supplier['id']);
              },
              child: const Text('Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String supplierId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Supplier'),
          content: const Text('Are you sure you want to permanently delete this supplier record from the database?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteSupplier(supplierId);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Supplier"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddSupplierPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (query) => filterSuppliers(query),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                              '${filteredSuppliers[index]['firstName']} ${filteredSuppliers[index]['lastName']}'),
                          subtitle: Text('Phone: ${filteredSuppliers[index]['phone']}\n'
                              '${filteredSuppliers[index]['email']}'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () => _showSupplierDetails(filteredSuppliers[index]),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
