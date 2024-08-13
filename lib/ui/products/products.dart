import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import '../../controllers/product_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Products(),
      debugShowCheckedModeBanner: false,
    );
  }
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
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  final ProductController productController = ProductController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productController.fetchProducts();
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final success = await productController.deleteProduct(productId);
      if (success) {
        setState(() {
          products.removeWhere((product) => product['id'] == productId);
          filteredProducts.removeWhere((product) => product['id'] == productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete product.')),
        );
      }
    } catch (error) {
      print('Error deleting product: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final productName = product['name'].toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0
                ),
                child: Center(
                  child: Text(
                    '${product['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 450,
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Price', '\$${product['price']}'),
                  _buildDetailRow('Quantity', '${product['stockQuantity']}'),
                  _buildDetailRow('Category', '${product['categoryId']}'),
                  _buildDetailRow('Description', '${product['description']}'),
                  _buildDetailRow('Supplier', '${product['supplierId']}'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Implement the edit functionality here
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          iconColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          print(product['id']);
                          print(product['categoryId']);
                          _showDeleteConfirmationDialog(context, product['id'], product['name']);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          iconColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 25.0),
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ': $value',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to permanently delete the product "$productName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduct(productId);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
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
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Product"),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const AddProductPage()),
                  // );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search by name',
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
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.7),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                    title: Text(
                      filteredProducts[index]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Price: \$${filteredProducts[index]['price']}\nCategory: ${filteredProducts[index]['categoryId']}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
                    onTap: () => _showProductDetails(filteredProducts[index]),
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