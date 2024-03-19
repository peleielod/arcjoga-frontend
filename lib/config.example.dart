class Config {
  // Test URL
  static const String apiUrlDev = '';

  // Live URL
  static const String apiUrlProd = 'https://mysticards.webinit.hu/api';

  static const String backendUrlDev = 'http://192.168.1.125:8000/';
  static const String backendUrlProd = 'https://mysticards.webinit.hu/';
  // Change between live and test
  static const bool isLiveMode = true;

  static const backendUrl = isLiveMode ? backendUrlProd : backendUrlDev;
  // Use this in case of making a request (!)
  static const apiUrl = isLiveMode ? apiUrlProd : apiUrlDev;
}
