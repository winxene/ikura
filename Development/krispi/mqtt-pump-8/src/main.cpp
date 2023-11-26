#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>

#define numMotors 8
const int stepPins[numMotors] = {18, 19, 21, 22, 23, 25, 26, 27};
static int timerCounter = 0;
bool isAccelerating[numMotors] = {true, false, false, false, false, false, false, false};
unsigned long targetedScaler[numMotors] = {1, 10, 100, 1000, 0, 0, 0, 0};
unsigned long scaler[numMotors] = {0, 0, 0, 0, 0, 0, 0, 0};
int sixteenSteps = 3200;

// WiFi and MQTT Configuration
const char* ssid = "ipong";
const char* password = "senpai8668";
const char* mqtt_server = "broker.eqmx.io";

WiFiClient espClient;
PubSubClient client(espClient);

hw_timer_t *timer = NULL;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;

void checkForAcceleration();
void stopTimer();
void startTimer();
void reconnect();
void connectToWiFi();
void callback(char* topic, byte* payload, unsigned int length);

void IRAM_ATTR onTimer() {
  portENTER_CRITICAL_ISR(&timerMux);

  for (int i = 0; i < numMotors; i++) {
    if (scaler[i] && (timerCounter % scaler[i] == 0)) {
      digitalWrite(stepPins[i], !digitalRead(stepPins[i]));
    }
  }
  timerCounter++;
  if (timerCounter >= 100000) {
    timerCounter = 0;
  }
  checkForAcceleration();
  portEXIT_CRITICAL_ISR(&timerMux);
}

void startTimer() {
  for (int i = 0; i < numMotors; i++) {
    digitalWrite(stepPins[i], LOW);
    if (isAccelerating[i] == true) {
      scaler[i] = 1000;
    }
  }
  timerCounter = 0;
  timerAlarmWrite(timer, 12, true);  // 12 = 41.5KHz
  timerAlarmEnable(timer);
  Serial.println("Start");
}

void stopTimer() {
  timerAlarmDisable(timer);
  timerWrite(timer, 0);
  for (int i = 0; i < numMotors; i++) {
    digitalWrite(stepPins[i], LOW);
    if (isAccelerating[i] == true) {
      scaler[i] = 1000;
    }
  }
  timerCounter = 0;
  Serial.println("Stop");
}

void accelerate(int motor) {
  if (scaler[motor] >= targetedScaler[motor] && scaler[motor] > 1) {
    if (timerCounter % 1000 == 0) {
      scaler[motor] -= 2;
    }
  } else {
    scaler[motor] = targetedScaler[motor];
  }
}

void checkForAcceleration() {
  bool allPumpsReachedTarget = true;
  for (int i = 0; i < numMotors; i++) {
    if (isAccelerating[i]) {
      accelerate(i);
      allPumpsReachedTarget = false;
    } else {
      scaler[i] = targetedScaler[i];
    }
  }

  if (allPumpsReachedTarget) {
    for (int i = 0; i < numMotors; i++) {
      isAccelerating[i] = false;
    }
  }
}

void setup() {
  Serial.begin(115200);
  connectToWiFi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  reconnect();
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

void connectToWiFi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
}

void reconnect() {
  while (!client.connected()) {
    Serial.println("Connecting to MQTT...");
    if (client.connect("ESP32Client")) {
      Serial.println("Connected to MQTT");
      for (int i = 0; i < numMotors; i++) {
        String motorScalerTopic = "device1/sub/dosingpump/motors/" + String(i + 1) + "/#";
        client.subscribe(motorScalerTopic.c_str());
      }
      client.subscribe("device1/sub/dosingpump/#");
    } else {
      Serial.print("MQTT connection failed, rc=");
      Serial.print(client.state());
      Serial.println(" Retrying in 5 seconds...");
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  if (strcmp(topic, "device1/sub/dosingpump/1") == 0) {
    if (payload[0] == '1') {
      // Start motor 1
      startTimer();
    } else if (payload[0] == '0') {
      // Stop motor 1
      stopTimer();
    }
  } else if (strstr(topic, "device1/sub/dosingpump/motors/")) {
    int motorIndex = topic[strlen("device1/sub/dosingpump/motors/")];
    int motorScaler = atoi((char*)payload);
    targetedScaler[motorIndex - 1] = motorScaler;

    // Check if the scaler is set less than 10 and change isAccelerating to true
    if (motorScaler < 10) {
      isAccelerating[motorIndex - 1] = true;
    }
  }
}
