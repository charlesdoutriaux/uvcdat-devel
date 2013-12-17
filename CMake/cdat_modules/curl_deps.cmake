set(CURL_deps ${pkgconfig_pkg} )
if (NOT CDAT_USE_SYSTEM_LIBXML2)
    message([INFOOOOOOOOOOOOOOOOOOOCURLOOOOOOOOOOOOOOOOOOOOOO] Ok we are NOT using system lbxml2 ${CDAT_USE_SYSTEM_LIBXML2})
    list(APPEND CURL_deps ${libxml2_pkg})
endif()
if (NOT CDAT_USE_SYSTEM_LIBXSLT)
    list(APPEND CURL_deps ${libxslt_pkg})
endif()
if (NOT CDAT_USE_SYSTEM_ZLIB)
    list(APPEND CURL_deps ${zlib_pkg})
endif()
