// import 'dart:math' as math;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../controller/ware_house_controller.dart';
// import '../../model/fabric_warehouse.dart';
//
// class BuyerWiseChart extends StatelessWidget {
//   const BuyerWiseChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final FabricWarehouseController controller = Get.find<FabricWarehouseController>();
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return Center(child: CircularProgressIndicator());
//       }
//
//       if (controller.errorMessage.value.isNotEmpty) {
//         return Center(child: Text('Error loading data'));
//       }
//
//       final warehouseList = controller.fabricWarehouse.value.warehouseList;
//       final totalStockAging = controller.fabricWarehouse.value.tQtyStockAging ?? 1;
//
//       if (warehouseList == null || warehouseList.isEmpty) {
//         return Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black, width: 1),
//           ),
//           child: Center(child: Text('No data available')),
//         );
//       }
//
//       // Generate colors for all buyers
//       final List<Color> baseColors = [
//         const Color(0xFF3498DB), // Blue
//         Colors.red, // Red
//         const Color(0xFFF7B731), // Yellow
//         const Color(0xFF5CB85C), // Green
//         const Color(0xFF9B59B6), // Purple
//         const Color(0xFFE67E22), // Orange
//         const Color(0xFF34495E), // Dark blue
//         const Color(0xFF1ABC9C), // Teal
//         const Color(0xFFFF6B6B), // Light red
//         const Color(0xFF4ECDC4), // Cyan
//         const Color(0xFF45B7D1), // Sky blue
//         const Color(0xFF96CEB4), // Mint green
//         const Color(0xFFFECA57), // Golden yellow
//         const Color(0xFFFF9FF3), // Pink
//         const Color(0xFF54A0FF), // Bright blue
//         const Color(0xFF5F27CD), // Deep purple
//       ];
//
//       // Calculate percentage for each buyer
//       final List<ChartData> chartData = [];
//
//       // Sort buyers by total volume (descending)
//       final sortedBuyers = List<WarehouseList>.from(warehouseList);
//       sortedBuyers.sort((a, b) => (b.total3Years ?? 0).compareTo(a.total3Years ?? 0));
//
//       // Show ALL buyers - no limit
//       for (int i = 0; i < sortedBuyers.length; i++) {
//         final buyer = sortedBuyers[i];
//         final totalVolume = buyer.total3Years ?? 0;
//
//         // Skip buyers with 0 volume
//         if (totalVolume == 0) continue;
//
//         final percentage = (totalVolume / totalStockAging) * 100;
//
//         // Generate color (cycle through base colors and create variations)
//         Color color;
//         if (i < baseColors.length) {
//           color = baseColors[i];
//         } else {
//           // Create color variations for buyers beyond base colors
//           final baseColorIndex = i % baseColors.length;
//           final baseColor = baseColors[baseColorIndex];
//           final variation = (i / baseColors.length).floor();
//
//           // Create lighter/darker variations
//           switch (variation % 3) {
//             case 1:
//               color = _lightenColor(baseColor, 0.3);
//               break;
//             case 2:
//               color = _darkenColor(baseColor, 0.3);
//               break;
//             default:
//               color = baseColor;
//           }
//         }
//
//         chartData.add(ChartData(
//           _formatBuyerName(buyer.buyer ?? 'Unknown'),
//           percentage,
//           color,
//         ));
//       }
//
//       return Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black, width: 1),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Occupied % (Buyer Wise) অকুপাইড % বায়ার ওয়াইজ',
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 children: [
//                   // Chart on the left
//                   Expanded(
//                     flex: 1,
//                     child: Center(
//                       child: CustomPaint(
//                         size: Size(
//                           MediaQuery.of(context).size.width * 0.15,
//                           MediaQuery.of(context).size.width * 0.15,
//                         ),
//                         painter: DonutChartPainter(chartData),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Legend on the right
//                   Expanded(
//                     flex: 1,
//                     child: SingleChildScrollView(
//                       child: _buildLegend(chartData),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   // Format buyer name to show like "Decathlon (22.4%)"
//   String _formatBuyerName(String name) {
//     // Shorten long names for better display
//     if (name.length > 20) {
//       return name.substring(0, 17) + "...";
//     }
//     return name;
//   }
//
//   Widget _buildLegend(List<ChartData> chartData) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: chartData.map((data) =>
//           Padding(
//             padding: const EdgeInsets.only(bottom: 4.0),
//             child: _buildLegendItem(
//               data.color,
//               '${data.label} (${data.value.toStringAsFixed(1)}%)',
//             ),
//           ),
//       ).toList(),
//     );
//   }
//
//   Widget _buildLegendItem(Color color, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 2,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper method to lighten a color
//   Color _lightenColor(Color color, double amount) {
//     final hsl = HSLColor.fromColor(color);
//     final lightness = math.min(1.0, hsl.lightness + amount);
//     return hsl.withLightness(lightness).toColor();
//   }
//
//   // Helper method to darken a color
//   Color _darkenColor(Color color, double amount) {
//     final hsl = HSLColor.fromColor(color);
//     final lightness = math.max(0.0, hsl.lightness - amount);
//     return hsl.withLightness(lightness).toColor();
//   }
// }
//
// // Chart data class
// class ChartData {
//   final String label;
//   final double value;
//   final Color color;
//
//   ChartData(this.label, this.value, this.color);
// }
//
// // Custom painter for donut chart
// class DonutChartPainter extends CustomPainter {
//   final List<ChartData> data;
//
//   DonutChartPainter(this.data);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = math.min(size.width, size.height) / 2;
//     final innerRadius = radius * 0.6; // Creates donut effect
//
//     double startAngle = -math.pi / 2; // Start from top
//     final total = data.fold<double>(0, (sum, item) => sum + item.value);
//
//     for (final item in data) {
//       final sweepAngle = (item.value / total) * 2 * math.pi;
//
//       // Draw outer arc
//       final paint = Paint()
//         ..color = item.color
//         ..style = PaintingStyle.fill;
//
//       final path = Path();
//
//       // Calculate start and end points for outer arc
//       final outerStartX = center.dx + radius * math.cos(startAngle);
//       final outerStartY = center.dy + radius * math.sin(startAngle);
//       final outerEndX = center.dx + radius * math.cos(startAngle + sweepAngle);
//       final outerEndY = center.dy + radius * math.sin(startAngle + sweepAngle);
//
//       // Calculate start and end points for inner arc
//       final innerStartX = center.dx + innerRadius * math.cos(startAngle);
//       final innerStartY = center.dy + innerRadius * math.sin(startAngle);
//       final innerEndX = center.dx + innerRadius * math.cos(startAngle + sweepAngle);
//       final innerEndY = center.dy + innerRadius * math.sin(startAngle + sweepAngle);
//
//       // Create donut segment path
//       path.moveTo(outerStartX, outerStartY);
//       path.arcTo(
//         Rect.fromCircle(center: center, radius: radius),
//         startAngle,
//         sweepAngle,
//         false,
//       );
//       path.lineTo(innerEndX, innerEndY);
//       path.arcTo(
//         Rect.fromCircle(center: center, radius: innerRadius),
//         startAngle + sweepAngle,
//         -sweepAngle,
//         false,
//       );
//       path.close();
//
//       canvas.drawPath(path, paint);
//
//       startAngle += sweepAngle;
//     }
//
//     // Draw border around the donut
//     final borderPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     canvas.drawCircle(center, radius, borderPaint);
//     canvas.drawCircle(center, innerRadius, borderPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }