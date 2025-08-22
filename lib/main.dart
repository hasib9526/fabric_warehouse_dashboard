import 'dart:async';
import 'dart:math' as math;


import 'package:fabric_warehouse_dashboard/view/widgets/desh_board_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const FabricWarehouseDashboard());
}


class FabricWarehouseDashboard extends StatelessWidget {
  const FabricWarehouseDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fabric Warehouse TV Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Roboto',
      ),
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
                            Expanded(
                              flex: 1,
                              child: StatsRow(),
                            ),
                            const SizedBox(width: 10),
                            // BuyerDataTable
                            Expanded(
                              flex: 1,
                              child: BuyerDataTable(),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 10),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02 ,),
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



class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2, // Width : Height ratio (adjust as needed)
                  child: StatCard(
                    title: 'Total Warehouse capacity\n(m3)',
                    subtitle: '(মোট ওয়ারহাউজ ক্যাপাসিটি)',
                    value: '3,000,000',
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
                    title: 'Total Quantity of Stock Aging\n(মোট স্টক এজিং পরিমাণ)',
                    subtitle: '',
                    value: '56,891',
                    color: const Color(0xFFF7B731),
                    icon: Icons.attach_money,
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
                    value: '1,479,507',
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
                    value: '23,562',
                    // color: const Color(0xFF5BC0DE),
                    color: Colors.red,
                    icon: Icons.attach_money,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color color;
  final IconData icon;

  const StatCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
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
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
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

class BuyerDataTable extends StatefulWidget {
  const BuyerDataTable({super.key});

  @override
  State<BuyerDataTable> createState() => _BuyerDataTableState();
}

class _BuyerDataTableState extends State<BuyerDataTable> {
  // Simulated backend data
  final List<Map<String, String>> _buyerData = [
    {
      'buyer': 'Ralph Lauren Ralph Lauren',
      'total': '373,940',
      'year1': '230120 (61.54%)',
      'year2': '120310 (32.17%)',
      'year3': '23510 (6.28%)',
    },
    {
      'buyer': 'Benetton ',
      'total': '962,220',
      'year1': '3412 (0.35%)',
      'year2': '891267 (92.63%)',
      'year3': '67541 (7.02%)',
    },
    {
      'buyer': 'H&M',
      'total': '74,437',
      'year1': '1290 (1.73%)',
      'year2': '31908 (42.87%)',
      'year3': '41239 (55.40%)',
    },
    {
      'buyer': 'RL',
      'total': '68,910',
      'year1': '34690 (50.34%)',
      'year2': '21908 (31.79%)',
      'year3': '12312 (17.87%)',
    },
    {
      'buyer': 'Nike',
      'total': '120,500',
      'year1': '80500 (66.80%)',
      'year2': '30000 (24.90%)',
      'year3': '10000 (8.30%)',
    },
    {
      'buyer': 'Adidas',
      'total': '95,780',
      'year1': '45780 (47.80%)',
      'year2': '40000 (41.76%)',
      'year3': '10000 (10.44%)',
    },
    {
      'buyer': 'Puma',
      'total': '82,340',
      'year1': '52340 (63.56%)',
      'year2': '25000 (30.36%)',
      'year3': '5000 (6.08%)',
    },
  ];

  final int _rowsPerPage = 5;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set up timer for auto pagination
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % ((_buyerData.length / _rowsPerPage).ceil());
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
    // Calculate the current page data
    final startIndex = _currentPage * _rowsPerPage;
    var endIndex = startIndex + _rowsPerPage;
    if (endIndex > _buyerData.length) {
      endIndex = _buyerData.length;
    }
    final currentPageData = _buyerData.sublist(startIndex, endIndex);

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
                  _buildHeaderCell('< 1 Year', textColor: Colors.white, backgroundColor: Colors.green),
                  _buildHeaderCell('1 Year < to > 2 Years', textColor: Colors.white, backgroundColor: Colors.orange),
                  _buildHeaderCell('2 Years < to > 3 Years', textColor: Colors.white, backgroundColor: Colors.red),
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
                  ...currentPageData.map((data) => _buildDataRow(
                    data['buyer']!,
                    data['total']!,
                    data['year1']!,
                    data['year2']!,
                    data['year3']!,
                  )).toList(),
                ],
              ),
            ),
          ),

          // Page indicator
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (_buyerData.length / _rowsPerPage).ceil(),
                    (index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildDataRow(String buyer, String total, String year1, String year2, String year3) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.white),
      children: [
        _buildDataCell(buyer),
        _buildDataCell(total),
        _buildDataCell(year1),
        _buildDataCell(year2),
        _buildDataCell(year3),
      ],
    );
  }

  // Separate Header Cell Widget
  Widget _buildHeaderCell(String text, {Color? textColor, Color? backgroundColor}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      padding: const EdgeInsets.all(1),
      decoration: backgroundColor != null ? BoxDecoration(color: backgroundColor) : null,
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
  Widget _buildDataCell(String text) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter([
                  ChartData('Total capacity (m3)', 67.0, const Color(0xFF5CB85C)),
                  ChartData('Occupied Area (m3)', 33.0, const Color(0xFFD9534F)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(const Color(0xFF5CB85C), 'Total capacity (m3)'),

              _buildLegend(const Color(0xFFD9534F), 'Occupied Area (m3)'),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class StockAgingChart extends StatelessWidget {
  const StockAgingChart({super.key});

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
            'Stock Aging % (স্টক এজিং)',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter([
                  ChartData('0 - 11 Months', 50.0, const Color(0xFFD9534F)),
                  ChartData('> 11 Months - 2 Years', 25.0, const Color(0xFFF0AD4E)),
                  ChartData('> 2 Years - 3 Years', 25.0, const Color(0xFF9B59B6)),
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
                  _buildLegend(const Color(0xFFD9534F), '0 - 11 Months'),

                  _buildLegend(const Color(0xFFF0AD4E), '> 11 Months - 2 Years'),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(const Color(0xFF9B59B6), '> 2 Years - 3 Years'),
                ],
              ),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class BuyerWiseChart extends StatelessWidget {
  const BuyerWiseChart({super.key});

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
            'Occupied % (Buyer Wise) অকুপাইড % বায়ার ওয়াইজ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter([
                  ChartData('Decathlon', 25.3, const Color(0xFF3498DB)),
                  ChartData('Benetton', 55.0, const Color(0xFFD9534F)),
                  ChartData('H&M', 10.0, const Color(0xFFF0AD4E)),
                  ChartData('RL', 20.7, const Color(0xFF5CB85C)),
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
                  _buildLegend(const Color(0xFF3498DB), 'Decathlon'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFFD9534F), 'Benetton'),
                  _buildLegend(const Color(0xFFF0AD4E), 'H&M'),
                  const SizedBox(width: 8),
                  _buildLegend(const Color(0xFF5CB85C), 'RL'),
                ],
              ),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
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
      if (sweepAngle > 0.3) { // Only show text for segments larger than ~17 degrees
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
          Offset(
            textX - textPainter.width / 2,
            textY - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
