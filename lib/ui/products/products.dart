import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import '../../controllers/product_controller.dart';

@override
Widget build(BuildContext context) {
  return const MaterialApp(
    home: Products(),
    debugShowCheckedModeBanner: false,
  );
}

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Products'),
      body: ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedFilter = "All Products";
  List<String> filters = ["All Products", "Category 1", "Category 2"];
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  final ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productController.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
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
                label: const Text("Add Product"),
                onPressed: () {
                  // Add Product action
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0x80E7D1FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_bag),
                    ),
                    title: Text(products[index]['name']),
                    subtitle: Text(
                        'Price: \$${products[index]['price']}\nCategory: ${products[index]['category']}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to product details
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
