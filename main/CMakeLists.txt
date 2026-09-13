# REQUIRES is listed explicitly (rather than left for idf's automatic
# source-scan fallback) because that fallback textually greps main.cpp for
# #include lines without respecting #if guards - it would otherwise always
# pick up codec-helix/codec-sbc (only #included for idf >= 6.2,
# see main.cpp) regardless of IDF version.
idf_component_register(
    SRCS "main.cpp"
    INCLUDE_DIRS "."
    REQUIRES ESP32-A2DP
)
