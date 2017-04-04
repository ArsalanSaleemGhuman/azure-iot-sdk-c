include(CMakeForceCompiler)

SET(CMAKE_SYSTEM_NAME Generic)

option(nucleus "set this option to ON if Nucleus is being used" OFF)
option(nucleus_cutility_samples "set this option to ON to include cutility samples" OFF)
option(nucleus_iothub_service_samples "set this option to ON to include iothub service samples" OFF)
option(nucleus_uamqp_samples "set this option to ON to include uamqp samples" OFF)
option(nucleus_umqtt_samples "set this option to ON to include umqtt samples" OFF)
option(nucleus_sample_http "set this option to ON to include http demo" OFF) 
option(nucleus_sample_amqp "set this option to ON to include amqp demo" OFF) 
option(nucleus_sample_mqtt "set this option to ON to include mqtt demo" OFF) 

CMAKE_FORCE_C_COMPILER(arm-none-eabi-gcc GNU)
CMAKE_FORCE_CXX_COMPILER(arm-none-eabi-g++ GNU)

#System Project patch provided by user
set(NUCLEUS_SYS_PROJ "/home/usama/Desktop/azure/mf0200")

#extract the system project name from system project path. It is required when processing the cflags
string(REGEX MATCH  "([^/]+$)" sys_proj_name ${NUCLEUS_SYS_PROJ})

#extract the bsp name.
file(READ ${NUCLEUS_SYS_PROJ}/.cproject bsp_name)
string(REGEX MATCH  " platform=[^ ]*" bsp_name ${bsp_name})
string(REGEX MATCH  "([^=]+$)" bsp_name ${bsp_name})
string(REGEX MATCH  "([^\"]+)" bsp_name ${bsp_name})


#extract the toolset.
file(READ ${NUCLEUS_SYS_PROJ}/.cproject toolset)
string(REGEX MATCH  "toolset=[^/]*" toolset ${toolset})
string(REGEX MATCH  "([^=]+$)" toolset ${toolset})
string(REGEX MATCH  "([^\"]+)" toolset ${toolset})

set (NUCLEUS_LIB "${NUCLEUS_SYS_PROJ}/output/${toolset}/${bsp_name}/Debug/lib/libnucleus.a")
set (NUCLEUS_LIBRARY "${NUCLEUS_SYS_PROJ}/output/${toolset}/${bsp_name}/Debug/lib")
set (NUCLEUS_LD_FILE "${NUCLEUS_SYS_PROJ}/output/${toolset}/${bsp_name}/Debug/toolset/${toolset}.${bsp_name}.link_ram.ld")
 
SET(COMMON_FLAGS "")

#extract the cflags
file(READ ${NUCLEUS_LIBRARY}/nucleus.lib.cflags data)
string(REGEX REPLACE "-[I][^ ]*(${sys_proj_name}/bsp)" "-I${NUCLEUS_SYS_PROJ}/bsp" c_flags  ${data})
string(REGEX REPLACE "-[I][^ ]*(${sys_proj_name}/os)" "-I${NUCLEUS_SYS_PROJ}/os" c_flags  ${c_flags})
string(REGEX REPLACE "-[I][^ ]*(${sys_proj_name} )" "" c_flags  ${c_flags})
set (c_flags "${c_flags} -I${NUCLEUS_SYS_PROJ} -I${NUCLEUS_SYS_PROJ}/bsp/${bsp_name}")

#extract some more cflags
file(READ ${NUCLEUS_SYS_PROJ}/output/${toolset}/${bsp_name}/Debug/system.properties data2)
string(REGEX MATCH  "INCLUDES = -I[^\n]*" data2 ${data2})
string(REGEX MATCH  "-I.*" data2 ${data2})
string(REPLACE "$(SYSTEM_HOME)" "${NUCLEUS_SYS_PROJ}" data2 ${data2})
       
SET(CMAKE_CXX_FLAGS "${COMMON_FLAGS}")
SET(CMAKE_C_FLAGS " -w ${c_flags}   \
${data2}  \
" CACHE STRING "" FORCE)
#above comprises of nucleus.lib.cflag + INCLUDES variable from system properties


set(CMAKE_EXE_LINKER_FLAGS "-Wl,-Map=demo_test.map -Wl,--gc-sections 	-Wl,--wrap=malloc  -Wl,--wrap=calloc  -Wl,--wrap=realloc -Wl,--wrap=free -Wl,--wrap=_malloc_r -Wl,--wrap=_calloc_r -Wl,--wrap=_realloc_r -Wl,--wrap=_free_r  -Wl,--defsym -Wl,PAGE_SIZE=0 -nostartfiles -T${NUCLEUS_LD_FILE} -L${NUCLEUS_LIBRARY}  -lgcc -lc -lg -lnucleus -lm -lstdc++ " CACHE STRING "" FORCE)



