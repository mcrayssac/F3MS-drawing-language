cmake_minimum_required(VERSION 3.10)
project(F3MS_drawing_language C)

set(CMAKE_C_STANDARD 11)

# Trouver Flex et Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# Trouver GTK3
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

# Définir les fichiers source Flex et Bison
set(LEXER_SOURCE ${CMAKE_SOURCE_DIR}/src/lexer/lexer.l)
set(PARSER_SOURCE ${CMAKE_SOURCE_DIR}/src/parser/parser.y)

# Générer les fichiers Flex et Bison
FLEX_TARGET(Lexer ${LEXER_SOURCE} ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)
BISON_TARGET(Parser ${PARSER_SOURCE} ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
        DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

include_directories(
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/src/common
        ${GTK3_INCLUDE_DIRS}
)

set(SOURCES
        src/main.c
        ${FLEX_Lexer_OUTPUTS}
        ${BISON_Parser_OUTPUTS}
        src/ide/textEditor.c
        src/ide/textEditor.h
)

add_executable(draw_compiler ${SOURCES})

# Lier avec toutes les bibliothèques nécessaires
target_link_libraries(draw_compiler
        m
        fl
        ${GTK3_LIBRARIES}
)

# Ajouter les flags de compilation pour GTK
target_compile_options(draw_compiler PRIVATE ${GTK3_CFLAGS_OTHER})