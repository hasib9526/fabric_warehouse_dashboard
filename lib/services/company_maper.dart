class CompanyMapper {
  static String getCompanyName(String id) {
    switch (id) {
      case "04":
        return "BGL";
      case "06":
        return "TAL";
      case "09":
        return "RHL";
      default:
        return "Unknown";
    }
  }
}
