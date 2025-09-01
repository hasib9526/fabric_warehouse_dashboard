import 'dart:async';
import 'dart:math' as math;
import 'package:fabric_warehouse_dashboard/view/widgets/desh_board_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ware_house_controller.dart';
import '../model/fabric_warehouse.dart';

class FabricWarehouseDashboard extends StatelessWidget {
  const FabricWarehouseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fabric Warehouse TV Dashboard',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            children: [
              // Header
              const DashboardHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Top Row -> Stats + BuyerDataTable
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            // StatsRow
                            Expanded(flex: 1, child: StatsRow()),
                            const SizedBox(width: 10),
                            // BuyerDataTable
                            Expanded(flex: 1, child: BuyerDataTable()),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 10),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                      // Bottom Row -> Charts
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: CapacityChart()),
                            const SizedBox(width: 16),
                            Expanded(child: StockAgingChart()),
                            const SizedBox(width: 16),
                            Expanded(child: BuyerWiseChart()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated StatsRow with API data
class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final FabricWarehouseController controller =
        Get.find<FabricWarehouseController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${controller.errorMessage.value}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.fetchFabricWarehouseData(),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      final data = controller.fabricWarehouse.value;
      return SizedBox(
        width: 25,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: StatCard(
                      title: 'Total Warehouse capacity\n(m3)',
                      subtitle: '(মোট ওয়ারহাউজ ক্যাপাসিটি)',
                      value: '------------',
                      color: const Color(0xFF4ECDC4),
                      icon: Icons.warehouse_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: StatCard(
                      title:
                          'Total Quantity of Stock Aging\n(মোট স্টক এজিং পরিমাণ)',
                      subtitle: '',
                      value: formatNumber(data.tQtyStockAging),
                      color: const Color(0xFFF7B731),
                      // Yellow box
                      iconText: "Yds",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: StatCard(
                      title: 'Total Occupied Area (m3)',
                      subtitle: '(মোট দখলকৃত এলাকা)',
                      value: '-------------',
                      color: const Color(0xFF5CB85C),
                      icon: Icons.warehouse_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: StatCard(
                      title: 'Total Quantity of Stock Aging\n> 1 year',
                      subtitle: '(মোট ১ বছরের বেশি স্টক এজিং\nপরিমাণ)',
                      value: formatNumber(data.tQtyStockGTh1yr),
                      color: Colors.red,
                      // Red box
                      iconText: "Yds",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color color;
  final IconData? icon; // icon optional
  final String? iconText; // text optional

  const StatCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    this.icon,
    this.iconText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),

                  // 🔑 either icon or text
                  if (icon != null)
                    Icon(icon, color: Colors.white, size: 24)
                  else if (iconText != null)
                    Text(
                      iconText!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ],
          ),

          // Fixed positioned value text - 5px from bottom
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated BuyerDataTable to use API data
class BuyerDataTable extends StatefulWidget {
  const BuyerDataTable({super.key});

  @override
  State<BuyerDataTable> createState() => _BuyerDataTableState();
}

class _BuyerDataTableState extends State<BuyerDataTable> {
  final int _rowsPerPage = 5;
  int _currentPage = 0;
  late Timer _timer;
  final FabricWarehouseController controller =
      Get.find<FabricWarehouseController>();

  @override
  void initState() {
    super.initState();
    // Set up timer for auto pagination
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (mounted && controller.fabricWarehouse.value.warehouseList != null) {
        setState(() {
          final totalPages =
              ((controller.fabricWarehouse.value.warehouseList!.length) /
                      _rowsPerPage)
                  .ceil();
          _currentPage =
              (_currentPage + 1) % (totalPages == 0 ? 1 : totalPages);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${controller.errorMessage.value}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.fetchFabricWarehouseData(),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      final warehouseList = controller.fabricWarehouse.value.warehouseList;

      if (warehouseList == null || warehouseList.isEmpty) {
        return Center(child: Text('No data available'));
      }

      // Calculate the current page data
      final startIndex = _currentPage * _rowsPerPage;
      var endIndex = startIndex + _rowsPerPage;
      if (endIndex > warehouseList.length) {
        endIndex = warehouseList.length;
      }
      final currentPageData = warehouseList.sublist(startIndex, endIndex);

      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF9BCF7F),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Buyer Wise Fabric Data with Aging',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Header Table (Separate)
            Table(
              border: TableBorder.all(color: Colors.black, width: 0.5),
              columnWidths: const {
                0: FlexColumnWidth(1.6),
                1: FlexColumnWidth(1.7),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: [
                    _buildHeaderCell('Buyer Name'),
                    _buildHeaderCell('Total Volume (yard)'),
                    _buildHeaderCell(
                      '< 1 Year',
                      textColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    _buildHeaderCell(
                      '1 Year < to > 2 Years',
                      textColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                    _buildHeaderCell(
                      // '2 Years < to > 3 Years',
                      '2 Years +',
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),

            // Data Table (Separate)
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: 0.5),
                  columnWidths: const {
                    0: FlexColumnWidth(1.6),
                    1: FlexColumnWidth(1.7),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    // Data rows from current page
                    ...currentPageData.map(
                      (data) => _buildDataRow(
                        data.buyer ?? 'N/A',
                        data.total3Years ?? 0,
                        data.year1 ?? 0,
                        data.year2 ?? 0,
                        data.year3 ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Page indicator
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (warehouseList.length / _rowsPerPage).ceil(),
                  (index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  TableRow _buildDataRow(
    String buyer,
    int total,
    int year1,
    int year2,
    int year3,
  ) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        _buildDataCell(buyer),
        _buildDataCell(formatNumber(total)),
        _buildDataCell(calculatePercentageSpan(year1, total)),
        _buildDataCell(calculatePercentageSpan(year2, total)),
        _buildDataCell(calculatePercentageSpan(year3, total)),
      ],
    );
  }

  // Separate Header Cell Widget
  Widget _buildHeaderCell(
    String text, {
    Color? textColor,
    Color? backgroundColor,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      padding: const EdgeInsets.all(1),
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor)
          : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.black,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }

  // Separate Data Cell Widget
  Widget _buildDataCell(dynamic content) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.all(1),
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: content is TextSpan
            ? RichText(textAlign: TextAlign.center, text: content)
            : Text(
                content.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
      ),
    );
  }

  TextSpan calculatePercentageSpan(int part, int total) {
    if (total == 0) {
      return const TextSpan(
        text: '0 (0%)',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
    }
    double percentage = (part / total) * 100;
    String formattedNumber = formatNumber(part);
    String formattedPercentage = '${percentage.toStringAsFixed(1)}%';

    return TextSpan(
      children: [
        TextSpan(
          text: '$formattedNumber ',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: '($formattedPercentage)',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CapacityChart extends StatelessWidget {
  const CapacityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Capacity vs Occupation (ক্যাপাসিটি VS অকুপেশন)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter([
                  ChartData(
                    'Total capacity (m3)', 50.0,const Color(0xFF5CB85C),
                  ),
                  ChartData('Occupied Area (m3)', 50.0, Colors.red),
                  //ChartData('Occupied Area (m3)', 33.0, const Color(0xFFD9534F)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(const Color(0xFF5CB85C), 'Total capacity (m3)'),

              _buildLegend(Colors.red, 'Occupied Area (m3)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class StockAgingChart extends StatelessWidget {
  const StockAgingChart({super.key});

  @override
  Widget build(BuildContext context) {
    final FabricWarehouseController controller =
        Get.find<FabricWarehouseController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text('Error loading data'));
      }

      final warehouseList = controller.fabricWarehouse.value.warehouseList;
      final totalStockAging =
          controller.fabricWarehouse.value.tQtyStockAging ?? 0;

      if (warehouseList == null ||
          warehouseList.isEmpty ||
          totalStockAging == 0) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Center(child: Text('No data available')),
        );
      }

      // Calculate totals for each age category
      int year1Total = 0;
      int year2Total = 0;
      int year3Total = 0;

      for (var warehouse in warehouseList) {
        year1Total += warehouse.year1 ?? 0;
        year2Total += warehouse.year2 ?? 0;
        year3Total += warehouse.year3 ?? 0;
      }

      // Calculate percentages
      double year1Percentage = (year1Total / totalStockAging) * 100;
      double year2Percentage = (year2Total / totalStockAging) * 100;
      double year3Percentage = (year3Total / totalStockAging) * 100;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock Aging % (স্টক এজিং)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: DonutChartPainter([
                    ChartData('0 - 11 Mo', year1Percentage, Colors.green),
                    ChartData(
                      '> 11 Mo - 2 Yrs',
                      year2Percentage,
                      Colors.orange,
                    ),
                    ChartData('> 2 Yrs - 3 Yrs', year3Percentage, Colors.red),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegend(Colors.green, '0 - 1 Year'),
                    _buildLegend(Colors.orange, '> 1 Year - 2 Years '),
                    _buildLegend(Colors.red, '> 2 Years - 3 Years '),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class BuyerWiseChart extends StatelessWidget {
  const BuyerWiseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final FabricWarehouseController controller =
        Get.find<FabricWarehouseController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text('Error loading data'));
      }

      final warehouseList = controller.fabricWarehouse.value.warehouseList;
      final totalStockAging =
          controller.fabricWarehouse.value.tQtyStockAging ??
          1; // Avoid division by zero

      if (warehouseList == null || warehouseList.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Center(child: Text('No data available')),
        );
      }

      // Calculate percentage for each buyer: (buyer total * 100) / total stock aging
      final List<ChartData> chartData = [];
      final List<Color> colors = [
        const Color(0xFF3498DB), // Blue
        Colors.red, // Red
        const Color(0xFFF7B731), // Yellow
        const Color(0xFF5CB85C), // Green
        const Color(0xFF9B59B6), // Purple
        const Color(0xFFE67E22), // Orange
        const Color(0xFF34495E), // Dark blue
        const Color(0xFF1ABC9C), // Teal
      ];

      // Sort buyers by total volume (descending) and take top ones for the chart
      final sortedBuyers = List<WarehouseList>.from(warehouseList);
      sortedBuyers.sort(
        (a, b) => (b.total3Years ?? 0).compareTo(a.total3Years ?? 0),
      );

      // Take top buyers (up to 8 to match available colors)
      final topBuyers = sortedBuyers
          .take(math.min(5, sortedBuyers.length))
          .toList();

      for (int i = 0; i < topBuyers.length; i++) {
        final buyer = topBuyers[i];
        final totalVolume = buyer.total3Years ?? 0;
        final percentage = (totalVolume / totalStockAging) * 100;

        chartData.add(
          ChartData(
            buyer.buyer ?? 'Unknown',
            percentage,
            colors[i % colors.length],
          ),
        );
      }

      // Calculate "Others" category if there are more buyers
      if (sortedBuyers.length > topBuyers.length) {
        int othersTotal = 0;
        for (int i = topBuyers.length; i < sortedBuyers.length; i++) {
          othersTotal += sortedBuyers[i].total3Years ?? 0;
        }
        final othersPercentage = (othersTotal / totalStockAging) * 100;

        if (othersPercentage > 0) {
          chartData.add(
            ChartData(
              'Others',
              othersPercentage,
              const Color(0xFF95A5A6), // Gray for others
            ),
          );
        }
      }

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Occupied % (Buyer Wise) অকুপাইড % বায়ার ওয়াইজ',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: DonutChartPainter(chartData),
                ),
              ),
            ),
            // const SizedBox(height: 8),
            AutoScrollLegend(chartData: chartData),
          ],
        ),
      );
    });
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

class DonutChartPainter extends CustomPainter {
  final List<ChartData> data;

  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2.0;
    final innerRadius = radius * 0.4;

    double startAngle = -math.pi / 2;
    final total = data.fold(0.0, (sum, item) => sum + item.value);

    for (var item in data) {
      final sweepAngle = (item.value / total) * 2 * math.pi;
      final percentage = (item.value / total * 100).toStringAsFixed(1);

      // Draw the arc segment
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      final path = Path();
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle,
        -sweepAngle,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);

      // Draw percentage text on the arc (only if segment is large enough)
      if (sweepAngle > 0.3) {
        // Only show text for segments larger than ~17 degrees
        final textAngle = startAngle + sweepAngle / 2;
        final textRadius = (radius + innerRadius) / 2;
        final textX = center.dx + textRadius * math.cos(textAngle);
        final textY = center.dy + textRadius * math.sin(textAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '$percentage%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AutoScrollLegend extends StatefulWidget {
  final List<ChartData> chartData;

  const AutoScrollLegend({super.key, required this.chartData});

  @override
  State<AutoScrollLegend> createState() => _AutoScrollLegendState();
}

class _AutoScrollLegendState extends State<AutoScrollLegend> {
  final ScrollController _controller = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startScrolling();
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (_controller.hasClients) {
        double maxScroll = _controller.position.maxScrollExtent;
        double current = _controller.offset;

        if (current >= maxScroll) {
          _controller.jumpTo(0);
        } else {
          _controller.jumpTo(current + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: widget.chartData.length * 10,
        itemBuilder: (context, i) {
          final data = widget.chartData[i % widget.chartData.length];
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${data.label} (${data.value.toStringAsFixed(2)}%)',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }
}
