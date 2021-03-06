cmake_minimum_required(VERSION 2.6)
project (server C)

IF(CMAKE_COMPILER_IS_GNUCC)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pedantic -Wall -Werror -Wno-unknown-pragmas -Wstrict-prototypes -Wpointer-arith -Wno-char-subscripts -Wno-long-long")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -DHAVE__BOOL")
ELSE(CMAKE_COMPILER_IS_GNUCC)
    MESSAGE(STATUS "Unknown compiler ${CMAKE_C_COMPILER_ID}")
ENDIF(CMAKE_COMPILER_IS_GNUCC)

find_package (Lua 5 REQUIRED)
find_package (LibXml2 REQUIRED)
find_package (SQLite3 REQUIRED)
find_package (ToLua REQUIRED)
find_package (Curses REQUIRED)

include_directories (${ERESSEA_INCLUDE_DIR})
include_directories (${CRITBIT_INCLUDE_DIR})
include_directories (${CRYPTO_INCLUDE_DIR})
include_directories (${QUICKLIST_INCLUDE_DIR})
include_directories (${CUTEST_INCLUDE_DIR})
include_directories (${LUA_INCLUDE_DIR})
include_directories (${LIBXML2_INCLUDE_DIR})
include_directories (${INIPARSER_INCLUDE_DIR})

add_executable(server main.c e4combat.c)
target_link_libraries(server
  ${ERESSEA_LIBRARY}
  ${BINDINGS_LIBRARY}
  ${TOLUA_LIBRARIES}
  ${SQLITE3_LIBRARIES}
)
