import 'package:flutter/material.dart';

class Quantity extends StatelessWidget {
  final int number;
  final String text;
  final Color numberColor;
  final Color bgColor;

  const Quantity({
    super.key,
    required this.number,
    required this.text,
    required this.numberColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: numberColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$number',
              style: TextStyle(
                color: numberColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

