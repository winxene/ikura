// #include <wifiConfig.hpp>
// #include <WiFi.h>
//
// void wifiSetup() {
//   WiFi.mode(WIFI_STA);
//   WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
//   while (WiFi.waitForConnectResult() != WL_CONNECTED) {
//     Serial.println("Connection Failed! Rebooting...");
//     delay(300);
//     ESP.restart();
//   }  
//   Serial.print("System connected with IP address: ");
//   Serial.println(WiFi.localIP());
//   Serial.printf("RSSI: %d\n", WiFi.RSSI());
// }
