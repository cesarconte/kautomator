# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Release")
  file(REMOVE_RECURSE
  "CMakeFiles/kautomator-gui_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/kautomator-gui_autogen.dir/ParseCache.txt"
  "kautomator-gui_autogen"
  )
endif()
