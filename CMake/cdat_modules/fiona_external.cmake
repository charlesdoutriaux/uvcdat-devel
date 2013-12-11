include(cdat_common_environment)
set(ENV{PATH} ${CMAKE_INSTALL_PREFIX}/bin:${CMAKE_INSTALL_PREFIX}/Externals/bin:$ENV{PATH})

ExternalProject_Add(fiona
  DOWNLOAD_DIR ${CDAT_PACKAGE_CACHE_DIR}
  SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/fiona
  BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/fiona
  URL ${FIONA_SOURCE}
  URL_MD5 ${FIONA_MD5}
  CONFIGURE_COMMAND "" 
  BUILD_COMMAND ""
  UPDATE_COMMAND ""
  INSTALL_COMMAND ${PYTHON_EXECUTABLE} setup.py install --prefix=${PYTHONUSERBASE}
  DEPENDS
    ${fiona_deps}
  ${ep_log_options}
  )

