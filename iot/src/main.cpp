#include <Arduino.h>
#include <SoftwareSerial.h>

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

SoftwareSerial pms5003(PMS_RX, PMS_TX);

void setup() {
  Serial.begin(115200);
  pms5003.begin(9600);
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

void loop() {
  PmsData data;
  if (ReadNextEpoch(&data)) {
    Serial.printf("PM 1.0: %d\n", data.Pm_1_0());
    Serial.printf("PM 2.5: %d\n", data.Pm_2_5());
    Serial.printf("PM 10: %d\n\n", data.Pm_10_0());
  } else {
    Serial.println("No Data YET.");
  }
  delay(1 * 1000);
}
