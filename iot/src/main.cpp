#include <Arduino.h>
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <RestClient.h>
#include <SoftwareSerial.h>
#include <SPI.h>
#include <WiFiConnector.h>
#include <WiFiUdp.h>

#include "./Config.h"

struct pms_data {
  int pm_1_0;
  int pm_2_5;
  int pm_10_0;
  int checksum;
};

class PmsData {
public:
  PmsData() {}
  PmsData(const char* data) {
    memcpy(&bytes_, data, 32);
    data_.pm_1_0 = bytes_[4] * 256 + bytes_[5];
    data_.pm_2_5 = bytes_[6] * 256 + bytes_[7];
    data_.pm_10_0 = bytes_[8] * 256 + bytes_[9];
    data_.checksum = bytes_[30] * 256 + bytes_[31];
  }

  bool IsValid() {
    // check bytes
    if (bytes_[0] != 0x42 || bytes_[1] != 0x4d) {
      return false;
    }
    // data length
    if (bytes_[2] != 0x00 || bytes_[3] != 0x1c) {
      return false;
    }

    int checksum = 0;
    for (int i = 0; i < 30; i++) {
      checksum += bytes_[i];
    }
    return checksum == data_.checksum;
  }

  int Pm_1_0() { return data_.pm_1_0; }
  int Pm_2_5() { return data_.pm_2_5; }
  int Pm_10_0() { return data_.pm_10_0; }

private:
  struct pms_data {
    short start_symbol;
    short data_length;
    short pm_1_0;
    short pm_2_5;
    short pm_10_0;
    short ignored[8];
    char version;
    char error_code;
    short checksum;
  };

  char bytes_[32];
  pms_data data_;
};

WiFiUDP ntp_udp;
NTPClient ntp(ntp_udp, NTP_SERVER, 0, NTP_INTERVAL);
RestClient api(API_HOST);
SoftwareSerial pms5003(PMS_RX, PMS_TX);
WiFiConnector wifi(WIFI_SSID, WIFI_PASSPHRASE);

void setup() {
  Serial.begin(115200);
  pms5003.begin(9600);

  wifi.disconnect(true);
  wifi.init();
  wifi.on_connected([&](const void* message) {
    Serial.printf("Connected to %s (%s).\n", wifi.get("ssid").c_str(), WiFi.localIP().toString().c_str());
  });

  wifi.on_connecting([&](const void* message) {
    Serial.printf("Connecting to %s...\n", wifi.get("ssid").c_str());
    delay(500);
  });

  wifi.connect();
  ntp.begin();
}

bool ReadNextEpoch(PmsData* data) {
  bool has_value = false;

  while (pms5003.available()) {
    while (pms5003.available() && pms5003.peek() != 0x42) {
      pms5003.read();
    }

    int remaining_bytes = 32;
    char buffer[32];
    while (remaining_bytes > 0 && pms5003.available()) {
      int read_bytes = pms5003.readBytes(&(buffer[32 - remaining_bytes]), remaining_bytes);
      remaining_bytes = remaining_bytes - read_bytes;
    }

    PmsData tmp(buffer);
    if (remaining_bytes == 0 && tmp.IsValid()) {
      *data = tmp;
      has_value = true;
    }
  }

  return has_value;
}

bool ntp_updated = false;
void loop() {
  wifi.loop();

  if (!wifi.connected()) {
    Serial.println("Wifi not connected.");
    delay(5 * 1000);
    return;
  }

  ntp_updated = ntp_updated | ntp.update();
  if (!ntp_updated) {
    Serial.println("NTP not synced");
    delay(5 * 1000);
    return;
  }

  PmsData data;
  if (ReadNextEpoch(&data)) {
    StaticJsonBuffer<256> buffer;
    JsonObject& epoch = buffer.createObject();
    epoch["device_id"] = DEVICE_ID;
    epoch["timestamp"] = ntp.getEpochTime();
    JsonObject& readings = epoch.createNestedObject("readings");
    readings["pm1.0"] = data.Pm_1_0();
    readings["pm2.5"] = data.Pm_2_5();
    readings["pm10"] = data.Pm_10_0();

    char request_body[256];
    epoch.printTo(request_body, 256);
    Serial.printf("Put Request: %s\n", request_body);

    char header[256];
    sprintf(header, "X-Api-Key: %s", API_KEY);
    api.setHeader(header);

    int status_code = api.put("/put", request_body);
    Serial.printf("Status code: %d\n", status_code);

    Serial.println();
  }
  delay(20 * 1000);
}
