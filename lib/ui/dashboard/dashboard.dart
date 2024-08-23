import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project/components/appbar.dart';
import 'package:project/ui/products/addProducts.dart';
import 'package:project/ui/suppliers/addsupplier.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),

            SizedBox(
              height: 100.0, 
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard('Total', '1,200', Colors.blue),
                    _buildSummaryCard('Low Stock', '45', Colors.orange),
                    _buildSummaryCard('Out Stock', '20', Colors.red),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Trends',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 200.0,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)
                          )
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1),
                              FlSpot(1, 2),
                              FlSpot(2, 8),
                              FlSpot(3, 4),
                              FlSpot(4, 5),
                            ],
                            isCurved: true,
                            color: Colors.deepPurple,
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.deepPurple.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Low Stock Products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 20.0),
                  _buildLowStockTable(),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Out of Stock Products',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 20.0),
                  _buildLowStockTable(),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                _buildActionButton('Add Product', Icons.add, Colors.blue, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductPage()),
                  );
                }),
                _buildActionButton('Add Suppliers', Icons.add, Colors.orange, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSupplierPage()),
                  );
                }),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
  return Container(
    width: 125.0, 
    height: 200.0, 
    padding: const EdgeInsets.all(16.0), 
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildLowStockTable() {
    final List<Map<String, dynamic>> lowStockProducts = [
      {'name': 'Phone', 'quantity': 5},
      {'name': 'Laptop', 'quantity': 2},
      {'name': 'TV', 'quantity': 7},
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Product Name',
                
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...lowStockProducts.map((product) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product['name']),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product['quantity'].toString()),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  
  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}