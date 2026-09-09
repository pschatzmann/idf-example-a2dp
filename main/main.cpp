
#include "AudioTools.h"
#include "BluetoothA2DPSink.h"

// AAC decode (via arduino-libhelix) needs the Bluedroid multi-SEP /
// external-codec support that only landed in idf v6.2 - see
// components/ESP32-A2DP/examples/bt_music_receiver_codec for more details
// and the required sdkconfig options (CONFIG_BT_A2DP_USE_EXTERNAL_CODEC,
// CONFIG_BT_A2DP_CODEC_AAC_ENABLED, CONFIG_BT_A2DP_SEP_NUM_MAX). Registering
// any decoder via add_decoder() replaces the built-in SBC decode path
// entirely, so SBC (via arduino-libsbc) is registered alongside AAC to keep
// working with sources that don't support AAC.
#define A2DP_CODEC_SUPPORTED (ESP_IDF_VERSION >= ESP_IDF_VERSION_VAL(6, 2, 0))

#if A2DP_CODEC_SUPPORTED
#include "AudioTools/AudioCodecs/CodecSBC.h"
#include "AudioTools/AudioCodecs/CodecAACHelix.h"
#include "A2DPDecoderSBC.h"
#include "A2DPDecoderAAC.h"
#endif

I2SStream i2s;
BluetoothA2DPSink a2dp_sink(i2s);

#if A2DP_CODEC_SUPPORTED
SBCDecoder sbc_decoder;
A2DPDecoderSBC a2dp_sbc(sbc_decoder);

AACDecoderHelix aac_decoder;
A2DPDecoderAAC a2dp_aac(aac_decoder);
#endif

void setup(){
#if A2DP_CODEC_SUPPORTED
  a2dp_sink.add_decoder(a2dp_sbc);
  a2dp_sink.add_decoder(a2dp_aac);
#endif
  a2dp_sink.start("MyMusic");
}

void loop(){
   a2dp_sink.delay_ms( 500 ); // or use vTaskDelay()
}

#if !defined(CONFIG_AUTOSTART_ARDUINO) || !CONFIG_AUTOSTART_ARDUINO
extern "C" void app_main(void){
#if !CONFIG_AUTOSTART_ARDUINO && defined(ARDUINO)
  initArduino();
#endif
  setup();
  while(true){
    loop();
  }
}
#endif
