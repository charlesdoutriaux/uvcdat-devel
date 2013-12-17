set(fontconfig_deps ${pkgconfig_pkg} ${freetype_pkg})
if (NOT CDAT_USE_SYSTEM_LIBXML2)
    list(APPEND fontconfig_deps ${libxml2_pkg})
endif()
