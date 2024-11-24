cmake_minimum_required(VERSION 3.10)
project(draw_compiler C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Trouver les dépendances nécessaires
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Définir les fichiers source
set(SOURCE_FILES
        src/main.c
        src/temp/parser.tab.c
        src/temp/lex.yy.c
)

# Créer l'exécutable
add_executable(draw_compiler ${SOURCE_FILES})

# Ajouter les includes nécessaires
target_include_directories(draw_compiler PRIVATE
        ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/src/temp
)

# Ajouter les bibliothèques nécessaires
target_link_libraries(draw_compiler m fl)