set(ocgis_source "${CMAKE_CURRENT_BINARY_DIR}/build/ocgis")
set(ocgis_binary "${CMAKE_CURRENT_BINARY_DIR}/build/ocgis-build")
set(ocgis_install "${cdat_EXTERNALS}")

set(ocgis_install_command ${PYTHON_EXECUTABLE} setup.py install)

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
  INSTALL_DIR ${ocgis_install}
  ${GIT_CMD_STR} 
  GIT_TAG ${ocgis_MD5}
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  INSTALL_COMMAND ${ocgis_install_command}
  DEPENDS ${ocgis_deps}
  ${ep_log_options}
)

# Install ocgis and VTK python modules via their setup.py files.

configure_file(${cdat_CMAKE_SOURCE_DIR}/cdat_modules_extra/vtk_install_python_module.cmake.in
  ${cdat_CMAKE_BINARY_DIR}/vtk_install_python_module.cmake
  @ONLY)

configure_file(${cdat_CMAKE_SOURCE_DIR}/cdat_modules_extra/paraview_install_python_module.cmake.in
  ${cdat_CMAKE_BINARY_DIR}/paraview_install_python_module.cmake
  @ONLY)

ExternalProject_Add_Step(ocgis InstallocgisPythonModule
  COMMAND ${CMAKE_COMMAND} -P ${cdat_CMAKE_BINARY_DIR}/paraview_install_python_module.cmake
  DEPENDEES install
  WORKING_DIRECTORY ${cdat_CMAKE_BINARY_DIR}
  )

ExternalProject_Add_Step(ocgis InstallVTKPythonModule
  COMMAND ${CMAKE_COMMAND} -P ${cdat_CMAKE_BINARY_DIR}/vtk_install_python_module.cmake
  DEPENDEES InstallocgisPythonModule
  WORKING_DIRECTORY ${cdat_CMAKE_BINARY_DIR}
  )

# symlinks of Externals/bin get placed in prefix/bin so we need to symlink paraview
# libs into prefix/lib as well for pvserver to work.
if(NOT EXISTS ${CMAKE_INSTALL_PREFIX}/lib)
  message("making ${ocgis_install}/lib")
  file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib)
endif()

ExternalProject_Add_Step(ocgis InstallocgisLibSymlink
  COMMAND ${CMAKE_COMMAND} -E create_symlink ${ocgis_install}/lib/paraview-${PARAVIEW_MAJOR}.${PARAVIEW_MINOR} ${CMAKE_INSTALL_PREFIX}/lib/paraview-${PARAVIEW_MAJOR}.${PARAVIEW_MINOR}
  DEPENDEES InstallVTKPythonModule
  WORKING_DIRECTORY ${cdat_CMAKE_BINARY_DIR}
)

