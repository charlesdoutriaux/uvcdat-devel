set(libXSLT_deps ${pkgconfig_pkg} ${readline_pkg} )
if (NOT CDAT_USE_SYSTEM_LIBXML2)
    list(APPEND libXSLT_deps ${libxml2_pkg})
endif()

