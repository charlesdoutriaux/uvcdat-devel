cmake_minimum_required(VERSION 2.8.8)

# Use system package and if set to use cdat package then undo it
#-----------------------------------------------------------------------------
macro(cdat_use_system_package package_name)
  set(system_package_name "${package_name}")
  if(NOT "${ARGV1}" STREQUAL "")
    set(system_package_name "${ARGV1}")
  endif()

  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)
  string(TOUPPER ${system_package_name} uc_sys_package)
  string(TOLOWER ${system_package_name} lc_sys_package)

  # Better safe than sorry
  if(CDAT_USE_SYSTEM_${uc_sys_package})
    message("[INFO] Removing external package ${package_name}")
    unset(${lc_package}_pkg)
    if(external_packages)
      list(REMOVE_ITEM external_packages ${package_name})
    endif()

  if(${uc_sys_package}_INCLUDE_DIR)
    list(APPEND found_system_include_dirs ${${uc_sys_package}_INCLUDE_DIR})
    message("[INFO] Including: ${uc_sys_package}_INCLUDE_DIR: ${${uc_sys_package}_INCLUDE_DIR}")
  endif()

  if(${uc_sys_package}_LIBRARY)
    get_filename_component(lib_path ${${uc_sys_package}_LIBRARY} PATH)
    list(APPEND found_system_libraries ${lib_path})
    message("[INFO]  Linking: ${uc_sys_package}_LIBRARY: ${lib_path}")
  endif()
endmacro()

# Add pacakge that should be built be cdat
#-----------------------------------------------------------------------------
macro (add_cdat_package package_name)
  # Use lowecase letters
  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)

  # Set various important variables
  set(version)
  set(message "Build ${package_name}")
  set(use_system_message "Use system ${package_name}")
  set(option_default ON)
  set(cdat_${package_name}_FOUND OFF)

  # ARGV1 will be the version string
  if(NOT "" STREQUAL "${ARGV1}")
    set(version "${ARGV1}")
    message("[INFO] version ${version} of ${uc_package} is required by UVCDAT")
  endif()

  # ARGV2 is the build message
  if(NOT "" STREQUAL "${ARGV2}")
    set(message "${msg}")
  endif()

  # ARGV3 (ON / OFF)
  if(NOT "" STREQUAL "${ARGV3}")
    set(option_default ${ARGV3})
  endif()

  # Check if package is optional, and if yes populate the GUI appropriately
  option(CDAT_BUILD_${uc_package} "${message}" ${option_default})
  mark_as_advanced(CDAT_BUILD_${uc_package})

  #  If this is an optional package
  if(NOT "" STREQUAL "${ARGV3}")
    # Find system package first and if it exits provide an option to use
    # system package
    if(DEFINED version)
      find_package(${package_name} ${version} QUIET)
    else()
      find_package(${package_name} QUIET)
    endif()

    mark_as_advanced(CLEAR CDAT_BUILD_${uc_package})

    if(${package_name}_FOUND OR ${uc_package}_FOUND)
      set(cdat_${package_name}_FOUND ON)
    endif()

    option(CDAT_USE_SYSTEM_${uc_package} "${use_system_message}" OFF)

    # If system package is found but not used and cdat build package option is OFF
    # then display error message
    if(cdat_${package_name}_FOUND AND NOT CDAT_BUILD_${uc_package})
      message(FATAL_ERROR "[ERROR] ${package_name} is REQUIRED but not used")
    endif()

    # If system package is not found or cdat build package option is ON
    # then cdat use system option should be OFF
    if(NOT cdat_${package_name}_FOUND OR CDAT_BUILD_${uc_package})
      set(CACHE CDAT_USE_SYSTEM_${uc_package} PROPERTY VALUE OFF)
    endif()
  endif()

  if(NOT cdat_${package_name}_FOUND)
    mark_as_advanced(${package_name}_DIR)
  endif()

  if(NOT CDAT_USE_SYSTEM_${uc_package})
      list(APPEND external_packages "${package_name}")
      set(${lc_package}_pkg "${package_name}")
  else()
    cdat_use_system_package("${package_name}")
  endif(NOT CDAT_USE_SYSTEM_${uc_package})
endmacro()

#-----------------------------------------------------------------------------
macro(enable_cdat_package_deps package_name)
  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)

  if (CDAT_BUILD_${uc_package})
    foreach(dep ${${package_name}_deps})
      string(TOUPPER ${dep} uc_dep)
      if(NOT CDAT_USE_SYSTEM_${uc_dep} AND NOT CDAT_BUILD_${uc_dep})
        set(CDAT_BUILD_${uc_dep} ON CACHE BOOL "" FORCE)
        message("[INFO] Setting build package -- ${dep} ON -- as required by ${package_name}")
      endif()
      if(NOT DEFINED CDAT_USE_SYSTEM_${uc_dep})
        mark_as_advanced(CDAT_BUILD_${uc_dep})
      endif()
    endforeach()
  endif()
endmacro()

# Disable a cdat package
#-----------------------------------------------------------------------------
macro(disable_cdat_package package_name)
  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)

  set(cdat_var CDAT_BUILD_${uc_package})
  if(DEFINED cdat_var)
    set_property(CACHE ${cdat_var} PROPERTY VALUE OFF)
  endif()
endmacro()

# Add cdat package which only shows up if dependencies are met
#-----------------------------------------------------------------------------
include(CMakeDependentOption)
macro(add_cdat_package_dependent package_name version build_message value dependencies default)
  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)

  cmake_dependent_option(CDAT_BUILD_${uc_package} "${message}" ${value} "${dependencies}" ${default})

  add_cdat_package("${package_name}" "${version}" "${build_message}" ${CDAT_BUILD_${uc_package}})

endmacro()

# Add cdat package but provides an user with an option to use-system
# installation of the project
#-----------------------------------------------------------------------------
macro(add_cdat_package_or_use_system package_name system_package_name)
  string(TOUPPER ${package_name} uc_package)
  string(TOLOWER ${package_name} lc_package)
  string(TOLOWER ${system_package_name} lc_sys_package)
  set(dependencies ${ARGV2})
  set(message "Build ${package_name}")
  set(use_system_message "Use system ${system_package_name}")

  # Check if the system package is present
  find_package(${system_package_name})

  if (NOT "${dependencies}" STREQUAL "")
    cmake_dependent_option(CDAT_BUILD_${uc_package} "${message}" ON "${dependencies}" OFF)
    cmake_dependent_option(CDAT_USE_SYSTEM_${sytem_package} "${message}" ON "${dependencies}" OFF)
  else()
    option(CDAT_USE_SYSTEM_${system_package_name} "Use system ${system_package_name}" OFF)
  endif()
  add_cdat_package("${package_name}" "" "${message}" ${CDAT_BUILD_${uc_package}})
  set_property(CACHE CDAT_USE_SYSTEM_${package_name} PROPERTY TYPE INTERNAL)

  if (NOT CDAT_BUILD_${uc_package} AND ${system_package_name}_FOUND)
    cdat_use_system_package("${package_name}" "${system_package_name}")
    set_property(CACHE CDAT_BUILD_${uc_package} PROPERTY TYPE INTERNAL)
    set_property(CACHE CDAT_USE_SYSTEM_${system_package_name} PROPERTY VALUE ON)
    set_property(CACHE CDAT_USE_SYSTEM_${uc_package} PROPERTY VALUE ON)
    include(${lc_sys_package}_sys)
  endif()

  if (NOT CDAT_BUILD_${uc_package} AND NOT CDAT_USE_SYSTEM_${system_package_name})
    message(FATAL_ERROR "[ERROR] ${system_package_name} is REQUIRED and not found")
  endif()

endmacro()

