import 'package:flutter/material.dart';

class NavigatorComponent extends StatelessWidget {
  final String imageUrl;
  final String navigationLink;
  final String text;

  const NavigatorComponent({
    super.key,
    required this.imageUrl,
    required this.navigationLink,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, top: 5.0),
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Transform.translate(
                    offset: const Offset(20.0, 40.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF8162FF),
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          // Navigator.pushNamed(context, navigationLink);
                        },
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Transform.translate(
                    offset: const Offset(0.0, -20.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class NavigatorComponent extends StatelessWidget {
//   final String imageUrl;
//   final String navigationLink;
//   final String text;
//   final String? description;
//   final double cardHeight; // New parameter for card height

//   const NavigatorComponent({
//     super.key,
//     required this.imageUrl,
//     required this.navigationLink,
//     required this.text,
//     this.description,
//     this.cardHeight = 170.0, // Default height
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20.0, top: 5.0),
//       height: cardHeight, // Set height dynamically
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             margin: const EdgeInsets.only(left: 20.0, right: 20.0),
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.0),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12.0),
//               child: Image.asset(
//                 imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     text,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 if (description != null) // Add description if provided
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       description!,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 const Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Transform.translate(
//                     offset: const Offset(20.0, 0.0),
//                     child: CircleAvatar(
//                       backgroundColor: const Color(0xFF8162FF),
//                       radius: 20,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_forward, color: Colors.white),
//                         onPressed: () {
//                           // Navigator.pushNamed(context, navigationLink);
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }