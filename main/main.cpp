
#include "AudioTools.h"
#include "BluetoothA2DPSink.h"

I2SStream i2s;
BluetoothA2DPSink a2dp_sink(i2s);

void setup(){
  a2dp_sink.start("MyMusic");  
}

void loop(){
   a2dp_sink.delay_ms( 500 ); // or use vTaskDelay()
}

#if !defined(CONFIG_AUTOSTART_ARDUINO) || !CONFIG_AUTOSTART_ARDUINO
extern "C" void app_main(void){
#if !CONFIG_AUTOSTART_ARDUINO
  initArduino();
#endif
  setup();
  while(true){
    loop();
  }
}
#endif
