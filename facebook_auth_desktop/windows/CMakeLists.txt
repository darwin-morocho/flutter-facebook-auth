# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "facebook_auth_desktop")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed.
set(PLUGIN_NAME "facebook_auth_desktop_plugin")

# === Microsoft Edge WebView2 SDK ===
#
# The SDK is distributed as a NuGet package rather than as part of the Windows
# SDK, so it is fetched at configure time. Only the headers and the *static*
# loader are consumed, which keeps the plugin free of any DLL that would
# otherwise have to be copied next to the application.
set(WEBVIEW2_PACKAGE_VERSION "1.0.2792.45")
set(NUGET_EXE "${CMAKE_BINARY_DIR}/nuget.exe")
set(NUGET_PACKAGES_DIR "${CMAKE_BINARY_DIR}/packages")
set(WEBVIEW2_DIR
    "${NUGET_PACKAGES_DIR}/Microsoft.Web.WebView2.${WEBVIEW2_PACKAGE_VERSION}")

if(NOT EXISTS "${WEBVIEW2_DIR}/build/native/include/WebView2.h")
  if(NOT EXISTS "${NUGET_EXE}")
    message(STATUS "facebook_auth_desktop: downloading nuget.exe")
    file(DOWNLOAD
      "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
      "${NUGET_EXE}"
      TLS_VERIFY ON
      STATUS NUGET_DOWNLOAD_STATUS
    )
    list(GET NUGET_DOWNLOAD_STATUS 0 NUGET_DOWNLOAD_CODE)
    if(NOT NUGET_DOWNLOAD_CODE EQUAL 0)
      list(GET NUGET_DOWNLOAD_STATUS 1 NUGET_DOWNLOAD_MESSAGE)
      file(REMOVE "${NUGET_EXE}")
      message(FATAL_ERROR
        "facebook_auth_desktop: could not download nuget.exe "
        "(${NUGET_DOWNLOAD_MESSAGE}). An internet connection is required the "
        "first time this plugin is built.")
    endif()
  endif()

  message(STATUS
    "facebook_auth_desktop: installing Microsoft.Web.WebView2 "
    "${WEBVIEW2_PACKAGE_VERSION}")
  execute_process(
    COMMAND "${NUGET_EXE}" install Microsoft.Web.WebView2
            -Version "${WEBVIEW2_PACKAGE_VERSION}"
            -OutputDirectory "${NUGET_PACKAGES_DIR}"
            -Source "https://api.nuget.org/v3/index.json"
            -NonInteractive
    RESULT_VARIABLE NUGET_INSTALL_RESULT
    OUTPUT_VARIABLE NUGET_INSTALL_OUTPUT
    ERROR_VARIABLE NUGET_INSTALL_OUTPUT
  )
  if(NOT NUGET_INSTALL_RESULT EQUAL 0)
    message(FATAL_ERROR
      "facebook_auth_desktop: failed to install the WebView2 SDK.\n"
      "${NUGET_INSTALL_OUTPUT}")
  endif()
endif()

# The loader is architecture specific; Flutter drives the build through the
# Visual Studio generator, so CMAKE_GENERATOR_PLATFORM is the reliable source.
string(TOLOWER "${CMAKE_GENERATOR_PLATFORM}" WEBVIEW2_GENERATOR_PLATFORM)
if(WEBVIEW2_GENERATOR_PLATFORM STREQUAL "arm64")
  set(WEBVIEW2_ARCH "arm64")
elseif(WEBVIEW2_GENERATOR_PLATFORM STREQUAL "win32")
  set(WEBVIEW2_ARCH "x86")
elseif(WEBVIEW2_GENERATOR_PLATFORM STREQUAL "x64")
  set(WEBVIEW2_ARCH "x64")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(WEBVIEW2_ARCH "x64")
else()
  set(WEBVIEW2_ARCH "x86")
endif()

set(WEBVIEW2_INCLUDE_DIR "${WEBVIEW2_DIR}/build/native/include")
set(WEBVIEW2_LOADER
    "${WEBVIEW2_DIR}/build/native/${WEBVIEW2_ARCH}/WebView2LoaderStatic.lib")

if(NOT EXISTS "${WEBVIEW2_LOADER}")
  message(FATAL_ERROR
    "facebook_auth_desktop: no WebView2 loader for '${WEBVIEW2_ARCH}' at "
    "${WEBVIEW2_LOADER}")
endif()

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "facebook_auth_desktop_plugin.cpp"
  "facebook_auth_desktop_plugin.h"
  "webview_host.cpp"
  "webview_host.h"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/facebook_auth_desktop/facebook_auth_desktop_plugin_c_api.h"
  "facebook_auth_desktop_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
# Disable the Windows min/max macros, which collide with the C++ standard
# library. The runner target does the same.
target_compile_definitions(${PLUGIN_NAME} PRIVATE "NOMINMAX")

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
# SYSTEM keeps the SDK headers out of the /W4 /WX warnings-as-errors that
# apply_standard_settings turns on for this target.
target_include_directories(${PLUGIN_NAME} SYSTEM PRIVATE
  "${WEBVIEW2_INCLUDE_DIR}")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)
# `version` and `shlwapi` are pulled in by the static WebView2 loader, `ole32`
# provides CoTaskMemFree for the strings WebView2 hands back.
target_link_libraries(${PLUGIN_NAME} PRIVATE
  "${WEBVIEW2_LOADER}"
  version.lib
  shlwapi.lib
  ole32.lib
)

# List of absolute paths to libraries that should be bundled with the plugin.
# The static WebView2 loader is linked in, so there is nothing to copy.
set(facebook_auth_desktop_bundled_libraries
  ""
  PARENT_SCOPE
)
