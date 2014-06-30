set(UVCMETRICS_TAG 48635d7acb)

set (nm UVCMETRICS)
string(TOUPPER ${nm} uc_nm)
set(${uc_nm}_VERSION ${${nm}_TAG})
set(UVCMETRICS_URL ${LLNL_URL})
set(UVCMETRICS_ZIP uvcmetrics-${UVCMETRICS_VERSION}.zip)
set(UVCMETRICS_SOURCE ${UVCMETRICS_URL}/${UVCMETRICS_ZIP})
set(UVCMETRICS_MD5 dd60d0b52d3d17addd2706f04d451150)

add_cdat_package_dependent(UVCMETRICS "" "" ON "CDAT_BUILD_GUI" OFF)
