#include "AudioTools.h"
#include "BluetoothA2DPSink.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

I2SStream out;
BluetoothA2DPSink a2dp_sink(out);

extern "C" void app_main() {
    a2dp_sink.start("MyMusic");
    while (true) {
        vTaskDelay(pdMS_TO_TICKS(1000)); // FreeRTOS delay
    }
}
