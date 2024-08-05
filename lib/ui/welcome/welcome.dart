import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: const Center(
          child: Stack(
            children: [
              LogoAndTitle(),
              _ImageCarousel(),
              _GetStartedButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 750.0,
      left: 80.0,
      right: 0.0,
      child: Row(
        children: [
          Image.asset('assets/logo/Management.png', width: 50.0),
          const SizedBox(width: 20.0),
          const Text(
            'SmartStock',
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8162FF),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 300.0,
      left: 0.0,
      right: 0.0,
      child: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: [
            {
              'path': 'assets/images/work1.png',
              'width': double.infinity,
              'height': 400.0,
            },
            {
              'path': 'assets/images/work2.png',
              'width': 350.0,
              'height': 500.0,
              'padding': const EdgeInsets.only(top: 120.0),
            },
          ].map((imageInfo) {
            final String imagePath = imageInfo['path'] as String;
            final double? imageWidth = imageInfo['width'] as double?;
            final double? imageHeight = imageInfo['height'] as double?;
            final EdgeInsetsGeometry? padding =
                imageInfo['padding'] as EdgeInsetsGeometry?;

            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: Image.asset(
                    imagePath,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100.0,
      left: 50.0,
      right: 50.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Effortless Inventory Management Starts Here!',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(133, 51, 0, 255),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 250.0,
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8162FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
