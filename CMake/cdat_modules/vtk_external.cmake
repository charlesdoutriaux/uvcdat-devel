set(vtk_source "${CMAKE_CURRENT_BINARY_DIR}/build/VTK")
set(vtk_binary "${CMAKE_CURRENT_BINARY_DIR}/build/VTK-build")
set(vtk_install "${cdat_EXTERNALS}")

set(GIT_CMD_STR GIT_REPOSITORY "${VTK_SOURCE}")

set(_vtk_modules "vtkRenderingImage;vtkRenderingVolume;vtkRenderingLabel;vtkRenderingFreeType;vtkRenderingFreeTypeOpenGL;vtkRenderingVolumeOpenGL;vtkRenderingCore;vtkRenderingOpenGL;vtkGeovisCore;vtkViewsCore;vtkViewsGeovis;vtkInteractionImage;vtkInteractionStyle;vtkInteractionWidgets;vtkCommonTransforms;vtkCommonCore;vtkCommonComputationalGeometry;vtkCommonExecutionModel;vtkCommonSystem;vtkCommonMisc;vtkFiltersFlowPaths;vtkFiltersStatistics;vtkFiltersAMR;vtkFiltersGeneric;vtkFiltersSources;vtkFiltersModeling;vtkFiltersExtraction;vtkFiltersSelection;vtkFiltersSMP;vtkFiltersCore;vtkFiltersHybrid;vtkFiltersTexture;vtkFiltersGeneral;vtkFiltersImaging;vtkFiltersGeometry;vtkIOImage;vtkIOCore;vtkIOExport;vtkIOImport;vtkIOGeometry;vtkImagingColor;vtkImagingSources;vtkImagingCore;vtkImagingGeneral;vtkImagingMath")

set(_vtk_module_options)
foreach(_module ${_vtk_modules})
  list(APPEND _vtk_module_options "-DModule_${_module}:BOOL=ON")
endforeach()

ExternalProject_Add(VTK
  DOWNLOAD_DIR ${CDAT_PACKAGE_CACHE_DIR}
  SOURCE_DIR ${vtk_source}
  BINARY_DIR ${vtk_binary}
  INSTALL_DIR ${vtk_install}
  ${GIT_CMD_STR}
  GIT_TAG uvcdat-master
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CMAKE_CACHE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_CXX_FLAGS:STRING=${cdat_tpl_cxx_flags}
    -DCMAKE_C_FLAGS:STRING=${cdat_tpl_c_flags}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_CFG_INTDIR}
    ${cdat_compiler_args}
    -DVTK_WRAP_PYTHON:BOOL=ON
    -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
    -DPYTHON_MAJOR_VERSION:STRING=${PYTHON_MAJOR}
    -DPYTHON_MINOR_VERSION:STRING=${PYTHON_MINOR}
    -DVTK_Group_Rendering:BOOL=OFF
    -DVTK_Group_StandAlone:BOOL=OFF
    ${_vtk_module_options}
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  DEPENDS ${VTK_deps}
  ${ep_log_options}
)

unset(GIT_CMD_STR)
