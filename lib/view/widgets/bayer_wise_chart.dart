import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ware_house_controller.dart';
import '../../utils/responsive_utils.dart';

class BuyerDataTable extends StatefulWidget {
  const BuyerDataTable({super.key});

  @override
  State<BuyerDataTable> createState() => _BuyerDataTableState();
}

class _BuyerDataTableState extends State<BuyerDataTable> {
  final int _rowsPerPage = 5 ;
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
    final responsive = context.responsive;

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
              SizedBox(height: responsive.spacing(10)),
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

      // Calculate totals
      int totalVolume = 0;
      int totalYear1 = 0;
      int totalYear2 = 0;
      int totalYear3 = 0;

      for (var data in warehouseList) {
        totalVolume += data.total3Years ?? 0;
        totalYear1 += data.year1 ?? 0;
        totalYear2 += data.year2 ?? 0;
        totalYear3 += data.year3 ?? 0;
      }

      // Calculate the current page data
      final startIndex = _currentPage * _rowsPerPage;
      var endIndex = startIndex + _rowsPerPage;
      if (endIndex > warehouseList.length) {
        endIndex = warehouseList.length;
      }
      final currentPageData = warehouseList.sublist(startIndex, endIndex);

      return Container(
        padding: responsive.allPadding(4),
        decoration: BoxDecoration(
          color: const Color(0xFF9BCF7F),
          border: Border.all(color: Colors.black, width: responsive.borderWidth(1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Buyer Wise Fabric Data with Aging',
                style: TextStyle(
                  fontSize: responsive.fontSize(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // const SizedBox(height: 4),

            // Header Table (Separate)
            Table(
              border: TableBorder.all(color: Colors.black, width: responsive.borderWidth(0.5)),
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

            // Total Row
            Table(
              border: TableBorder.all(color: Colors.black, width: responsive.borderWidth(0.5)),
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
                    _buildHeaderCell('Total'),
                    _buildDataCell(formatNumber(totalVolume)),
                    _buildDataCell(calculatePercentageSpan(totalYear1, totalVolume)),
                    _buildDataCell(calculatePercentageSpan(totalYear2, totalVolume)),
                    _buildDataCell(calculatePercentageSpan(totalYear3, totalVolume)),
                  ],
                ),
              ],
            ),

            // Data Table (Separate)
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.black, width: responsive.borderWidth(0.5)),
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
                    padding: responsive.allPadding(2.0),
                    child: Container(
                      width: responsive.spacing(5),
                      height: responsive.spacing(6),
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
    final responsive = context.responsive;

    return Container(
      height: responsive.height(65.0),
      padding: EdgeInsets.all(0),
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor)
          : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: responsive.fontSize(18),
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
    final responsive = context.responsive;

    return Container(
      height: responsive.height(62.0),
      padding: responsive.allPadding(1),
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: content is TextSpan
            ? RichText(textAlign: TextAlign.center, text: content)
            : Text(
          content.toString(),
          style: TextStyle(
            fontSize: responsive.fontSize(18),
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
    final responsive = context.responsive;

    if (total == 0) {
      return TextSpan(
        text: '0 (0%)',
        style: TextStyle(
          fontSize: responsive.fontSize(18),
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
          style: TextStyle(
            fontSize: responsive.fontSize(18),
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: '($formattedPercentage)',
          style: TextStyle(
            fontSize: responsive.fontSize(18),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}