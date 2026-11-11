cmake_minimum_required(VERSION 3.20)
project(kautomator VERSION 1.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(QT_MIN_VERSION "6.7.0")
set(KF_MIN_VERSION "6.0.0")

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(FeatureSummary)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Core
    Gui
    Widgets
    Qml
    Quick
    QuickControls2
    Network
    DBus
)

find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS
    CoreAddons
    I18n
)

add_executable(kautomator-gui
    src/gui/main.cpp
    src/gui/automatorbackend.cpp
    src/gui/automatorbackend.h
    src/gui/resources.qrc
)

target_link_libraries(kautomator-gui PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Network
    Qt6::DBus
    KF6::CoreAddons
    KF6::I18n
)

install(TARGETS kautomator-gui ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
