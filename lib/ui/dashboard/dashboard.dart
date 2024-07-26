import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project/ui/dashboard/quantity/quantity.dart';

import '../../components/appbar.dart';
import 'package:project/ui/dashboard/navigators/navigator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dashboard'),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Quantity Row
              Container(
                height: 110.0,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Quantity(
                          number: 715,
                          text: 'In stock',
                          numberColor: Color(0xFF2BED9D),
                          bgColor: Color(0xFFDAFFEF)
                      ),
                      Quantity(
                        number: 55,
                        text: 'Low stock',
                        numberColor: Color(0xBDFFA722),
                        bgColor: Color(0xBDFFECD7),
                      ),
                      Quantity(
                          number: 200,
                          text: 'Out of stock',
                          numberColor: Color(0xFFF85A4C),
                          bgColor: Color(0xFFFADAD5)
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),

              // Bar Chart Row
              Container(
                height: 210.0,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      // titlesData: const FlTitlesData(
                      //   leftTitles: AxisTitles(axisNameSize: 5),
                      //   bottomTitles: AxisTitles(axisNameSize: 5),
                      // ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: 8,
                              color: Colors.blue,
                              width: 16,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: 10,
                              color: Colors.red,
                              width: 16,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: 14,
                              color: Colors.green,
                              width: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),

              // Carousel Slider Row
              Container(
                height: 290.0,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 230.0,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: [
                        const NavigatorComponent(
                          imageUrl: 'assets/images/navigator1.png',
                          navigationLink: '/products',
                          text: 'VIEW ALL PRODUCTS',
                        ),
                        const NavigatorComponent(
                          imageUrl: 'assets/images/navigator2.png',
                          navigationLink: '/addProducts',
                          text: 'ADD PRODUCTS',
                        ),
                        const NavigatorComponent(
                          imageUrl: 'assets/images/navigator3.png',
                          navigationLink: '/addSuppliers',
                          text: 'ADD SUPPLIERS',
                        ),
                      ].map((widget) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: widget,
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3, // Number of items in the carousel
                            (index) => Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.deepPurple
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
