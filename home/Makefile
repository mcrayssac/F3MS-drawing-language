# Makefile for the .draw compiler

# Frames per second
FRAME ?= 5

# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison

# Flags
CFLAGS = -Wall -Wextra -std=c99 -I../src -I../src/temp -Wno-sign-compare -D_GNU_SOURCE

# Add -ll or -lfl for Flex library
LDLIBS = -ll -lm

# Source files
LEXER_SRC = ../src/lexer/lexer.l
PARSER_SRC = ../src/parser/parser.y
MAIN_SRC = ../src/main.c
COMMON_SRC = ../src/common/common.c
COMMAND_SRC = ../src/command/command.c
LINKEDLIST_SRC = ../src/linkedList/linkedList.c  
FIGURE_SRC = ../src/figure/figure.c
PICTURE_SRC = ../src/picture/picture.c
TEXT_SRC = ../src/text/text.c
POLYGON_SRC = ../src/polygon/polygon.c
REGULAR_POLYGON_SRC = ../src/regular_polygon/regular_polygon.c
POINTLIST_SYMBOL_SRC = ../src/pointListSymbol/pointListSymbol.c


# Generated files
LEXER_OBJ = ../src/temp/lex.yy.c
PARSER_C_OBJ = ../src/temp/parser.tab.c
PARSER_H_OBJ = ../src/temp/parser.tab.h
PARSER_OBJ = $(PARSER_C_OBJ) $(PARSER_H_OBJ)

# Output executable
COMPILER = ../src/temp/draw_compiler
EDITOR = ../ide/ide

# Input and output files (can be overridden)
DRAW_FILE ?= my_draw.draw
OUTPUT_PY ?= draw.py

# Default target
all: $(COMPILER) $(EDITOR)

# Compile the compiler
$(COMPILER): $(LEXER_OBJ) $(PARSER_OBJ) $(MAIN_SRC) $(COMMON_SRC) $(COMMAND_SRC) $(LINKEDLIST_SRC) $(FIGURE_SRC) $(PICTURE_SRC) $(POLYGON_SRC) $(REGULAR_POLYGON_SRC) $(POINTLIST_SYMBOL_SRC)
	@echo "Compiling the compiler..."
	$(CC) $(CFLAGS) -o $(COMPILER) $(MAIN_SRC) $(PARSER_C_OBJ) $(LEXER_OBJ) $(COMMON_SRC) $(COMMAND_SRC) $(LINKEDLIST_SRC) $(FIGURE_SRC) $(PICTURE_SRC) $(TEXT_SRC) $(POLYGON_SRC) $(REGULAR_POLYGON_SRC) $(POINTLIST_SYMBOL_SRC) $(LDLIBS)
	@echo "draw_compiler generated"

# Compile the text editor
$(EDITOR): ../ide/textEditor.c
	@echo "Compiling the text editor..."
	$(CC) -o $(EDITOR) ../ide/textEditor.c `pkg-config --cflags --libs gtk+-3.0 gtksourceview-3.0 vte-2.91`
	@echo "Text editor 'ide' generated"

# Add dependencies to ensure correct build order
$(MAIN_SRC) $(COMMON_SRC) $(COMMAND_SRC) $(LINKEDLIST_SRC) $(FIGURE_SRC): $(PARSER_H_OBJ)

# Ensure that sources depending on parser.tab.h are compiled after it's generated
$(COMMON_SRC): $(PARSER_H_OBJ)

# Ensure temp directory exists
../src/temp/:
	mkdir -p ../src/temp/

# Generate the lexer
$(LEXER_OBJ): $(LEXER_SRC) $(PARSER_H_OBJ) | ../src/temp/
	@echo "Generating lexer..."
	$(FLEX) -o $(LEXER_OBJ) $(LEXER_SRC)
	@echo "lex.yy.c generated"

# Generate the parser
$(PARSER_C_OBJ) $(PARSER_H_OBJ): $(PARSER_SRC) | ../src/temp/
	@echo "Generating parser..."
	$(BISON) -d -o $(PARSER_C_OBJ) $(PARSER_SRC)
	@echo "parser.tab.h generated"
# mv parser.tab.h $(PARSER_H_OBJ)
	@echo "Moved parser.tab.h to $(PARSER_H_OBJ)"

# Generate output.py
output: $(COMPILER)
	@echo "Generating $(OUTPUT_PY) from $(DRAW_FILE) with $(FRAME) frames per second..."
	$(COMPILER) $(DRAW_FILE) $(OUTPUT_PY) $(FRAME)

# Clean generated files
clean:
	@echo "Cleaning up..."
	rm -f $(LEXER_OBJ) $(PARSER_C_OBJ) $(PARSER_H_OBJ) $(COMPILER) $(OUTPUT_PY) parser.output

# Phony targets
.PHONY: all clean output

# Compile the compiler (parameters can be overridden without [ ])
# Usage: make [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py] [FRAME=5]

# Generate output.py (parameters can be overridden without [ ])
# Usage: make output [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py] [FRAME=5]

# Clean generated files
# Usage: make clean