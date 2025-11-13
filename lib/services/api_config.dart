class ApiConfig {
  static const String baseUrl =
      "http://apps.bitopibd.com:8090/bimobapiv2/api/FabricWarehouseTV";
  static const String baseUrll =
      "http://172.16.13.137:13806/api/FabricWarehouseTV";


  static String fabricWarehouseUrl(String companyId) {
    return "$baseUrl/GetFabricWarehouseData?companyId=$companyId";
  }

  static String fabricWarehouseCapacityUrl(String companyId) {
    return "$baseUrl/GetFabricWarehouseCapacity?companyId=$companyId";
  }
}
