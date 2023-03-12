// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class SessionListHeader extends StatelessWidget {
//   final DateTime dateTime;

//   const SessionListHeader({super.key, required this.dateTime});

//   @override
//   Widget build(BuildContext context) {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _SessionListHeaderDelegate(
//         minHeight: 50,
//         maxHeight: 50,
//         child: Semantics(
//           header: true,
//           child: Container(
//             color: Colors.grey[300],
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.only(left: 16),
//             child: Text(
//               DateFormat('EEEE, MMMM d, y • h:mm a').format(dateTime),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SessionListHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   const _SessionListHeaderDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   double get maxExtent => max(maxHeight, minHeight);

//   @override
//   double get minExtent => minHeight;

//   @override
//   bool shouldRebuild(_SessionListHeaderDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
