/*  parser.y
    This file contains the parser for the compiler.
    It defines the grammar rules that the parser will use to parse the input file.
    The parser is implemented using bison.
*/

/*  Section: Header Files
    Include necessary header files.
*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../common/common.h"

void yyerror(const char *s); /* Function prototype for error handling */
int yylex(void);

FILE *output; /* Output file */

/* Function prototypes */
void add_point(char *name, int x, int y);
void update_point(char *name, int x, int y);
Point *find_point(char *name);

%}

/*  Section: Union
    Define the union type for the parser.
*/
%union {
    int intval;
    char *strval;
    Point *pointval;
}

/*  Section: Token Types
    Define the token types for the parser.
*/
%token <intval> NUMBER
%token <strval> IDENTIFIER
%token SET_COLOR POINT LINE
%token LPAREN RPAREN COMMA SEMICOLON EQUALS

/* Section: Nonterminal Types
    Define the nonterminal types for the parser.
*/
%type <pointval> point_expr
%type <pointval> expr

%start program

%%

/* Section: Grammar Rules
    Define the grammar rules for the parser.
*/

program:
    /* Empty */
    | program statement
    ;

statement:
    assignment SEMICOLON
    | function_call SEMICOLON
    ;

assignment:
    IDENTIFIER EQUALS point_expr {
        update_point($1, $3->x, $3->y);
    }
    ;

function_call:
    set_color_call
    | line_call
    ;

set_color_call:
    SET_COLOR LPAREN NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "color = [%d, %d, %d]\n", $3, $5, $7);
    }
    ;

line_call:
    LINE LPAREN expr COMMA expr RPAREN {
        fprintf(output, "pygame.draw.line(screen, color, (%d, %d), (%d, %d), 1)\n",
                $3->x, $3->y, $5->x, $5->y);
    }
    ;

point_expr:
    POINT LPAREN NUMBER COMMA NUMBER RPAREN {
        $$ = malloc(sizeof(Point));
        $$->x = $3;
        $$->y = $5;
    }
    | IDENTIFIER {
        Point *p = find_point($1);
        if (p == NULL) {
            yyerror("Undefined point");
            YYABORT;
        } else {
            $$ = p;
        }
    }
    ;

expr:
    point_expr
    ;

%%

/*  Section: Function Definitions
    Define the functions for the parser.
*/

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

/* Symbol table for points (a table of names and coordinates) */
Point symbol_table[100];
int symbol_count = 0;

/* Add a new point to the symbol table */
void add_point(char *name, int x, int y) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].x = x;
    symbol_table[symbol_count].y = y;
    symbol_count++;
}

/* Update the coordinates of an existing point */
void update_point(char *name, int x, int y) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].x = x;
            symbol_table[i].y = y;
            return;
        }
    }
    // If the point doesn't exist, add it
    add_point(name, x, y);
}

/* Find a point in the symbol table */
Point *find_point(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return &symbol_table[i];
        }
    }
    return NULL;
}
