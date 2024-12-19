#include "AudioTools.h"
#include "BluetoothA2DPSink.h"

I2SStream out;
BluetoothA2DPSink a2dp_sink(out);

extern "C" void app_main() {
    a2dp_sink.start("MyMusic");
    while (true) {
        delay(1000); // delay 1000 ms
    }
}
