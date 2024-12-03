class Constant {
  // ignore: non_constant_identifier_names
  // static String BASE_URL = "http://192.168.100.3/akunting-ukm/public/";
  // static String ROOT_URL = "http://192.168.100.3/randu-api/";
  // static String BASE_URL = ROOT_URL + "public/";

  static String BASE_URL = "https://app.randu.co.id/";

  // ignore: non_constant_identifier_names
  // static String JOURNAL_REPORT = ROOT_URL + "storage/app/";
  static String JOURNAL_REPORT = BASE_URL + "storage/";
  static String UPLOAD_IMAGE_URL = BASE_URL + "api/v1";

  // static String JOURNAL_IMAGE = ROOT_URL + "storage/app/public/journal/";

  static String JOURNAL_IMAGE = BASE_URL + "storage/images/journal/";

  static String VERSION = "1.0.5";
  static String RELEASE_DATE = "03 Desember 2024";
}
