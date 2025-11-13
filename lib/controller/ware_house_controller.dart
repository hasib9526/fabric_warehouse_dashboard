import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/fabric_warehouse.dart';
import '../services/api_config.dart';

class FabricWarehouseController extends GetxController {
  var isLoading = true.obs;
  var fabricWarehouse = FabricWarehouse().obs;
  var errorMessage = ''.obs;
  var hasConnectionError = false.obs;

  // TAL
    var companyId = '06'.obs;

  // //BGL
  // var companyId = '04'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFabricWarehouseData(showLoading: true);
    fetchFabricWarehouseCapacity();

    Timer.periodic(Duration(minutes: 2), (timer) {
      fetchFabricWarehouseData();
      fetchFabricWarehouseCapacity();
    });
  }

  Future<void> fetchFabricWarehouseData({bool showLoading = false}) async {
    try {
      if (showLoading) {
        isLoading(true);
      }
      errorMessage('');
      hasConnectionError(false);

      final url = ApiConfig.fabricWarehouseUrl(companyId.value);

      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        fabricWarehouse(FabricWarehouse.fromJson(data));
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      errorMessage('Network error: Please check your internet connection');
      hasConnectionError(true);
    } on TimeoutException {
      errorMessage('Connection timeout: Server is not responding');
      hasConnectionError(true);
    } on HttpException {
      errorMessage('HTTP error: Please try again later');
      hasConnectionError(true);
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      if (showLoading) {
        isLoading(false);
      }
    }
  }

  Future<void> fetchFabricWarehouseCapacity() async {
    try {
      final url = ApiConfig.fabricWarehouseCapacityUrl(companyId.value);

      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Update the existing fabricWarehouse object with capacity data silently
        final currentWarehouse = fabricWarehouse.value;
        currentWarehouse.totalCapacity = _parseDouble(data['TotalCapacity']);
        currentWarehouse.totalUsed = _parseDouble(data['TotalUsed']);
        // Trigger update without changing loading state
        fabricWarehouse.refresh();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      // Silently handle capacity fetch errors to not disrupt main data
    } on TimeoutException {
      // Silently handle capacity fetch errors to not disrupt main data
    } on HttpException {
      // Silently handle capacity fetch errors to not disrupt main data
    } catch (e) {
      // Silently handle capacity fetch errors to not disrupt main data
    }
  }

  // Helper method to parse double values
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

}
// Format numbers with commas for better readability
String formatNumber(int? number) {
  if (number == null) return '0';
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  );
}

// Format decimal numbers with commas for better readability
String formatDecimalNumber(double? number) {
  if (number == null) return '0';
  // Format to 2 decimal places
  String formattedNumber = number.toStringAsFixed(2);
  // Split into integer and decimal parts
  List<String> parts = formattedNumber.split('.');
  // Add commas to integer part
  parts[0] = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  );
  // Join back together
  return parts.join('.');
}