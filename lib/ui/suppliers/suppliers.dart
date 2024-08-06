import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import 'package:project/controllers/supplier_controller.dart';

void main() {
  runApp(const MyApp());
}

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
      backgroundColor: Colors.white,
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
  String selectedFilter = "All Suppliers";
  List<String> filters = ["All Suppliers", "Filter 1", "Filter 2"];
  List<Map<String, dynamic>> suppliers = [];
  bool isLoading = true;
  final SuppliersController suppliersController = SuppliersController();

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
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching suppliers: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: selectedFilter,
                icon: const Icon(Icons.arrow_downward),
                items: filters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Supplier"),
                onPressed: () {
                  // Add Supplier action
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: suppliers.length,
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
                        '${suppliers[index]['firstName']} ${suppliers[index]['lastName']}'),
                    subtitle: Text(
                        'Phone: ${suppliers[index]['phone']}\nEmail: ${suppliers[index]['email']}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to supplier details
                    },
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
