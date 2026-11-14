# CMake generated Testfile for 
# Source directory: /run/media/cesar/Seagate/Linux/Proyectos/kautomator
# Build directory: /run/media/cesar/Seagate/Linux/Proyectos/kautomator/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test("appstreamtest" "/usr/bin/cmake" "-DAPPSTREAMCLI=/usr/bin/appstreamcli" "-DINSTALL_FILES=/run/media/cesar/Seagate/Linux/Proyectos/kautomator/build/install_manifest.txt" "-P" "/usr/share/ECM/kde-modules/appstreamtest.cmake")
set_tests_properties("appstreamtest" PROPERTIES  _CMAKE_TEST_BUILD_DEPENDS "" _BACKTRACE_TRIPLES "/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;177;add_test;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;195;appstreamtest;/usr/share/ECM/kde-modules/KDECMakeSettings.cmake;0;;/run/media/cesar/Seagate/Linux/Proyectos/kautomator/CMakeLists.txt;16;include;/run/media/cesar/Seagate/Linux/Proyectos/kautomator/CMakeLists.txt;0;")
