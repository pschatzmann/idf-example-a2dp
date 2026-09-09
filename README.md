# IDF A2DP Example Project

This IDF example project demonstrates how to use the [A2DP library](https://github.com/pschatzmann/ESP32-A2DP) and the [AudioTools library](https://github.com/pschatzmann/arduino-audio-tools) to build a simple Bluetooth Speaker. 

It has been tested with the IDF v.6.0.1 
 
Install with

    git clone --recurse-submodules https://github.com/pschatzmann/idf-example-a2dp

Source IDF e.g. 
    
    source /home/pschatzmann/.espressif/v5.5.4/esp-idf/export.sh
    source /home/pschatzmann/.espressif/v6.0.1/esp-idf/export.sh
    source /home/pschatzmann/.espressif/v6.0.2/esp-idf/export.sh

Build with
 
    idf.py build
