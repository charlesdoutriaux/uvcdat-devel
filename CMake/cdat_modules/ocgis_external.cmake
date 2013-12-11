include(cdat_common_environment)
set(ocgis_source "${CMAKE_CURRENT_BINARY_DIR}/build/ocgis")
set(ocgis_binary "${CMAKE_CURRENT_BINARY_DIR}/build/ocgis")
set(ocgis_install "${cdat_EXTERNALS}")

#set(ocgis_install_command ${PYTHON_EXECUTABLE} setup.py install --prefix=${PYTHONUSERBASE} )
set(ocgis_install_command ${PYTHON_EXECUTABLE} setup.py install )

include(GetGitRevisionDescription)

get_git_head_revision(refspec sha)
if (NOT OFFLINE_BUILD)
    set(GIT_CMD_STR GIT_REPOSITORY ${ocgis_SOURCE})
else ()
    set(GIT_CMD_STR )
endif()

ExternalProject_Add(ocgis
  DOWNLOAD_DIR ${CDAT_PACKAGE_CACHE_DIR}
  SOURCE_DIR ${ocgis_source}
  BINARY_DIR ${ocgis_binary}
  ${GIT_CMD_STR} 
  GIT_TAG ${ocgis_MD5}
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ${ocgis_install_command}
  DEPENDS ${ocgis_deps}
  ${ep_log_options}
)
