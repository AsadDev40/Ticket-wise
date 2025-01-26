// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ticket_wise/Pages/search_page.dart';
// import 'package:ticket_wise/widgets/constants.dart';

// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const CustomAppBar({super.key})
//       : preferredSize = const Size.fromHeight(160); // Adjusted height

//   @override
//   final Size preferredSize;

//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
//       child: AppBar(
//         backgroundColor: PrimaryColor,
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Color(0xff2d2d2d),
//           statusBarIconBrightness: Brightness.light,
//           statusBarBrightness: Brightness.light,
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0.5,
//         flexibleSpace: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(top: 40, left: 5),
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 0, bottom: 25),
//                   child: Text(
//                     'Ticket Wise',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//               ),
//               // const SizedBox(height: 10),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               //   child: GestureDetector(
//               //     onTap: () {
//               //       Navigator.push(
//               //         context,
//               //         MaterialPageRoute(builder: (context) => SearchPage()),
//               //       );
//               //     },
//               //     child: AbsorbPointer(
//               //       absorbing: true,
//               //       child: TextField(
//               //         decoration: InputDecoration(
//               //           hintText: 'Search...',
//               //           hintStyle: TextStyle(color: Colors.grey[400]),
//               //           filled: true,
//               //           fillColor: Colors.white,
//               //           border: OutlineInputBorder(
//               //             borderRadius: BorderRadius.circular(30),
//               //             borderSide: BorderSide.none,
//               //           ),
//               //           prefixIcon:
//               //               const Icon(Icons.search, color: Colors.grey),
//               //         ),
//               //         style: const TextStyle(color: Colors.white),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
