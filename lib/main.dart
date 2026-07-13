import 'dart:async';
import 'dart:io';

import 'package:fabric_warehouse_dashboard/view/fabric_warehouse_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  await WakelockPlus.enable();
  Get.put(FabricWarehouseController());
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fabric Warehouse TV Dashboard',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: 'Roboto'),
      home: const CycleScreen(),
    );
  }
}

class CycleScreen extends StatefulWidget {
  const CycleScreen({super.key});

  @override
  State<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends State<CycleScreen> {
  // -1 = dashboard showing; 0/1/2 = image index currently shown
  int _imageIndex = -1;
  static const _imageDuration = Duration(seconds: 15);
  static const _images = [
    'images/img.png',
    'images/img_1.png',
    'images/img_2.png',
  ];
  Timer? _imageTimer;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<FabricWarehouseController>();
    controller.onLastPageReached = _onLastPageReached;
  }

  void _onLastPageReached() {
    // Ignore if images are already cycling
    if (!mounted || _imageIndex >= 0) return;
    // Only show the warehouse layout images for company 04
    final controller = Get.find<FabricWarehouseController>();
    if (controller.companyId.value != '04') return;
    _showNextImage(0);
  }

  void _showNextImage(int index) {
    if (!mounted) return;
    setState(() => _imageIndex = index);
    _imageTimer = Timer(_imageDuration, () {
      if (!mounted) return;
      final next = index + 1;
      if (next < _images.length) {
        _showNextImage(next);
      } else {
        // All 3 images done — back to dashboard
        setState(() => _imageIndex = -1);
      }
    });
  }

  @override
  void dispose() {
    _imageTimer?.cancel();
    Get.find<FabricWarehouseController>().onLastPageReached = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: _imageIndex >= 0
          ? WarehouseLayoutScreen(
              key: ValueKey('image_$_imageIndex'),
              imagePath: _images[_imageIndex],
            )
          : const FabricWarehouseDashboard(key: ValueKey('dashboard')),
    );
  }
}

class WarehouseLayoutScreen extends StatelessWidget {
  final String imagePath;
  const WarehouseLayoutScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
