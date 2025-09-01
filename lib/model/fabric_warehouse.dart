
// Updated Models with proper type handling
class FabricWarehouse {
  List<WarehouseList>? warehouseList;
  int? tQtyStockAging;
  int? tQtyStockGTh1yr;

  FabricWarehouse(
      {this.warehouseList, this.tQtyStockAging, this.tQtyStockGTh1yr});

  FabricWarehouse.fromJson(Map<String, dynamic> json) {
    if (json['WarehouseList'] != null) {
      warehouseList = <WarehouseList>[];
      json['WarehouseList'].forEach((v) {
        warehouseList!.add(WarehouseList.fromJson(v));
      });
    }

    // Handle both int and double values from API
    tQtyStockAging = _parseInt(json['tQtyStockAging']);
    tQtyStockGTh1yr = _parseInt(json['tQtyStockGTh1yr']);
  }

  // Helper method to parse both int and double values
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (warehouseList != null) {
      data['WarehouseList'] =
          warehouseList!.map((v) => v.toJson()).toList();
    }
    data['tQtyStockAging'] = tQtyStockAging;
    data['tQtyStockGTh1yr'] = tQtyStockGTh1yr;
    return data;
  }
}

class WarehouseList {
  String? companyID;
  String? buyer;
  int? year1;
  int? year2;
  int? year3;
  int? year3Plus;
  int? total3Years;

  WarehouseList(
      {this.companyID,
        this.buyer,
        this.year1,
        this.year2,
        this.year3,
        this.year3Plus,
        this.total3Years});

  WarehouseList.fromJson(Map<String, dynamic> json) {
    companyID = json['CompanyID'];
    buyer = json['Buyer'];

    // Use helper method to parse values
    year1 = _parseInt(json['Year1']);
    year2 = _parseInt(json['Year2']);
    year3 = _parseInt(json['Year3']);
    year3Plus = _parseInt(json['Year3Plus']);
    total3Years = _parseInt(json['Total3Years']);
  }

  // Helper method to parse both int and double values
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompanyID'] = companyID;
    data['Buyer'] = buyer;
    data['Year1'] = year1;
    data['Year2'] = year2;
    data['Year3'] = year3;
    data['Year3Plus'] = year3Plus;
    data['Total3Years'] = total3Years;
    return data;
  }
}


