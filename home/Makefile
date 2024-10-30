# Makefile for the .draw compiler

# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison

# Flags
CFLAGS = -Wall -Wextra -std=c99 -I../src -Wno-sign-compare -D_GNU_SOURCE

# Add -lm to link the math library if needed, and -ll or -lfl for Flex
LDLIBS = -ll

# Source files
LEXER_SRC = ../src/lexer/lexer.l
PARSER_SRC = ../src/parser/parser.y
MAIN_SRC = ../src/main.c

# Generated files
LEXER_OBJ = ../src/temp/lex.yy.c
PARSER_C_OBJ = ../src/temp/parser.tab.c
PARSER_H_OBJ = ../src/temp/parser.tab.h
PARSER_OBJ = $(PARSER_C_OBJ) $(PARSER_H_OBJ)

# Output executable
COMPILER = ../src/temp/draw_compiler

# Input and output files (can be overridden)
DRAW_FILE ?= my_draw.draw
OUTPUT_PY ?= draw.py

# Default target
all: $(COMPILER)

# Compile the compiler
$(COMPILER): $(LEXER_OBJ) $(PARSER_OBJ) $(MAIN_SRC)
	@echo "Compiling the compiler..."
	$(CC) $(CFLAGS) -o $(COMPILER) $(MAIN_SRC) $(PARSER_C_OBJ) $(LEXER_OBJ) $(LDLIBS)
	@echo "draw_compiler generated"

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
	@echo "Generating $(OUTPUT_PY) from $(DRAW_FILE)..."
	$(COMPILER) $(DRAW_FILE) $(OUTPUT_PY)

# Clean generated files
clean:
	@echo "Cleaning up..."
	rm -f $(LEXER_OBJ) $(PARSER_C_OBJ) $(PARSER_H_OBJ) $(COMPILER) $(OUTPUT_PY) parser.output

# Phony targets
.PHONY: all clean output

# Compile the compiler and generate output.py
# Usage: make [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py]

# Generate output.py
# Usage: make output [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py]

# Clean generated files
# Usage: make clean