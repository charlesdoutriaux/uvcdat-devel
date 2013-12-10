set( fiona_MAJOR_SRC 1  )
set( fiona_MINOR_SRC 0  )
set( fiona_PATCH_SRC 2  )
set(fiona_URL ${LLNL_URL})
set(fiona_GZ
    Fiona-${fiona_MAJOR_SRC}.${fiona_MINOR_SRC}.${fiona_PATCH_SRC}.tar.gz)
set(fiona_MD5 
set(fiona_SOURCE ${fiona_URL}/${fiona_GZ})

set (nm fiona)
string(TOUPPER ${nm} uc_nm)
set(${uc_nm}_VERSION ${${nm}_MAJOR_SRC}.${${nm}_MINOR_SRC}.${${nm}_PATCH_SRC})
add_cdat_package_dependent(fiona "" "" ON "CDAT_BUILD_GRAPHICS" OFF)
