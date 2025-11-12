import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../controller/ware_house_controller.dart';
import '../../services/company_maper.dart';
import '../../utils/responsive_utils.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final String currentDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final controller = Get.find<FabricWarehouseController>();

    return Obx(() {
      final companyName = CompanyMapper.getCompanyName(controller.companyId.string);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: responsive.spacing(40), vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border(
            bottom: BorderSide(color: Colors.black, width: responsive.borderWidth(1)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fabric Warehouse Dashboard',
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  'ফ্যাব্রিক ওয়ারহাউজ ড্যাশবোর্ড',
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Date : $currentDate',
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
