add_subdirectory(uvcdat)
add_subdirectory(regrid)
if (CDAT_BUILD_VCS_LEGACY)
  add_subdirectory(vcs_legacy)
endif()
add_subdirectory(vcs)
add_subdirectory(cdutil)
add_subdirectory(cdms2)
if (CDAT_BUILD_UVCMETRICSPKG)
  add_subdirectory(metrics)
endif()
if (CDAT_BUILD_PARAVIEW)
  add_subdirectory(paraview)
endif()
