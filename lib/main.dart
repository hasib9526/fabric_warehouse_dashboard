import 'dart:async';
import 'dart:io';
import 'dart:math' as math;


import 'package:fabric_warehouse_dashboard/view/fabric_warehouse_dashboard.dart';
import 'package:fabric_warehouse_dashboard/view/widgets/desh_board_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'controller/ware_house_controller.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  // Enable wakelock to keep screen awake
  await WakelockPlus.enable();
  runApp(const FabricWarehouseDashboard());
  Get.put(FabricWarehouseController());
}

