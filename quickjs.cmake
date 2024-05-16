set(QUICKJS_VERSION 2024-01-13)
set(QUICKJS_SOURCE_DIR ${CMAKE_BINARY_DIR}/quickjs-${QUICKJS_VERSION})
set(QUICKJS_BINARY_DIR ${CMAKE_BINARY_DIR}/quickjs-${QUICKJS_VERSION})
set(QUICKJS_ARCHIVE_URL https://bellard.org/quickjs/quickjs-${QUICKJS_VERSION}.tar.xz)
set(QUICKJS_ARCHIVE_HASH 3c4bf8f895bfa54beb486c8d1218112771ecfc5ac3be1036851ef41568212e03)
if(CMAKE_HOST_WIN32)
  file(TO_CMAKE_PATH $ENV{USERPROFILE}/.cache/quickjs-${QUICKJS_VERSION}.tar.xz QUICKJS_ARCHIVE_TXZ)
else()
  file(TO_CMAKE_PATH $ENV{HOME}/.cache/quickjs-${QUICKJS_VERSION}.tar.xz QUICKJS_ARCHIVE_TXZ)
endif()
if(NOT EXISTS ${QUICKJS_SOURCE_DIR}/quickjs.h)
  file(DOWNLOAD ${QUICKJS_ARCHIVE_URL} ${QUICKJS_ARCHIVE_TXZ} EXPECTED_HASH SHA256=${QUICKJS_ARCHIVE_HASH} SHOW_PROGRESS)
  execute_process(WORKING_DIRECTORY ${CMAKE_BINARY_DIR} COMMAND ${CMAKE_COMMAND} -E tar xf ${QUICKJS_ARCHIVE_TXZ})
  find_package(Patch)
  if(Patch_FOUND)
    file(GLOB QUICKJS_PATCH *.patch)
    foreach(patch ${QUICKJS_PATCH})
      execute_process(WORKING_DIRECTORY ${QUICKJS_SOURCE_DIR}
        COMMAND ${Patch_EXECUTABLE} -p1 -i ${patch}
      )
    endforeach()
  endif()
endif()
file(COPY src/CMakeLists.txt DESTINATION ${QUICKJS_SOURCE_DIR})
