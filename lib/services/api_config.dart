class ApiConfig {
  static const String baseUrl =
      "http://apps.bitopibd.com:8090/bimobapiv2/api/FabricWarehouseTV";


  static String fabricWarehouseUrl(String companyId) {
    return "$baseUrl/GetFabricWarehouseData?companyId=$companyId";
  }
}
