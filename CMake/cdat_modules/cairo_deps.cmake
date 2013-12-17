set(Cairo_deps ${pkgconfig_pkg} ${png_pkg} ${fontconfig_pkg} ${freetype_pkg} ${pixman_pkg} )
if (NOT CDAT_USE_SYSTEM_LIBXML2)
    list(APPEND Cairo_deps ${libxml2_pkg})
endif()
