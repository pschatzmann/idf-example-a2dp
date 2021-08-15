# Example IDF Project for ESP-A2DP library

The [ESP-A2DP library](https://github.com/pschatzmann/ESP32-A2DP) can be used as component with the [Expressive IDF framework](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html). I assume you have the IDF framwork already installed and sourced.

Here is a quick summary on how to set up a new project using the ESP32-A2DP

- Create a new project (I used esp32-a2dp as project name)

```
idf.py create_project esp32-a2dp
cd esp32-a2dp
```

- Configure the Project

You can run ```idf.py menuconfig``` and activate Bluedroid and A2DP or add sdkconfig.defaults with the following content into the root of your project
```
CONFIG_BT_ENABLED=y
CONFIG_BTDM_CTRL_MODE_BLE_ONLY=n
CONFIG_BTDM_CTRL_MODE_BR_EDR_ONLY=y
CONFIG_BTDM_CTRL_MODE_BTDM=n
CONFIG_BT_BLUEDROID_ENABLED=y
CONFIG_BT_CLASSIC_ENABLED=y
CONFIG_BT_A2DP_ENABLE=y
CONFIG_BT_SPP_ENABLED=y
CONFIG_BT_BLE_ENABLED=n
```

- Add the "ESP32-A2DP" component to your project

```
mkdir components
cd components
git clone https://github.com/pschatzmann/ESP32-A2DP.git
```

- Define your main program component if the main project directory

First we need to convert the generated esp32-a2dp.c into a cpp file
```
cd main
mv esp32-a2dp.c esp32-a2dp.cpp
```

- Define the content of your main program esp32-a2dp.cpp

```
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

```

- Correct the CMakeLists.txt in main to contain the following line
```
idf_component_register(SRCS "esp32-a2dp.cpp" INCLUDE_DIRS ".")

```

- Check your project: It should have the following structure now

```
- esp32-a2dp
  - CMakeLists.txt
  - sdkconfig.defaults (and or sdkconfig)
  - main
    - CMakeLists.txt
    - esp32-a2dp.cpp
  - components
    - ESP32-A2DP

```


- Compile the project from the project root directory with
```
idf.py build
```

- Deploy the project to your device by calling ```idf.py -p PORT [-b BAUD] flash```

Example:
```
idf.py -p /dev/tty.SLAB_USBtoUART flash

```

- Monitor the project to your device by calling ```idf.py -p PORT [-b BAUD] monitor```

Example:
```
idf.py -p /dev/tty.SLAB_USBtoUART monitor

```
