set(ParaView_deps ${pkgconfig_pkg} ${python_pkg} ${hdf5_pkg} ${png_pkg} ${jpeg_pkg} ${freetype_pkg} ${netcdfplus_pkg} ${zlib_pkg} ${r_pkg})
if (NOT CDAT_USE_SYSTEM_LIBXML2)
    list(APPEND Python_deps ${libxml2_pkg})
endif()

if (NOT CDAT_BUILD_GUI)
  list(APPEND ParaView_deps ${qt_pkg})
endif()

if(CDAT_BUILD_PARALLEL)
  list(APPEND ParaView_deps "${mpi_pkg}")
endif()
