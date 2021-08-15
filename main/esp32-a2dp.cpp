#include "BluetoothA2DPSink.h"

BluetoothA2DPSink a2dp_sink;

void setup(){
  a2dp_sink.start("MyMusic");  
}

void loop(){
   delay( 500 );
}


extern "C" void app_main(void){
  setup();
  while(true){
    loop();
  }
}

