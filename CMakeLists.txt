cmake_minimum_required(VERSION 3.16.0)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(a2dp-idf)

add_compile_options(-DESP32_CMAKE=1)
