/* Include standard headers */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../common/common.h"

void yyerror(const char *s);
int yylex(void);

FILE *output;

/* Function prototypes */
void add_point(char *name, int x, int y);
Point *find_point(char *name);

%}

/* Declare the union */
%union {
    int intval;
    char *strval;
    Point *pointval;
}

/* Token declarations */
%token <intval> NUMBER
%token <strval> IDENTIFIER
%token SET_COLOR POINT LINE
%token LPAREN RPAREN COMMA SEMICOLON EQUALS

/* Non-terminal types */
%type <pointval> point_expr
%type <pointval> expr

%start program

%%

/* Grammar rules */

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
        add_point($1, $3->x, $3->y);
    }
    ;

function_call:
    set_color_call
    | line_call
    ;

set_color_call:
    SET_COLOR LPAREN NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "color = (%f, %f, %f)\n", $3/255.0, $5/255.0, $7/255.0);
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

/* Function definitions */

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

Point symbol_table[100];
int symbol_count = 0;

void add_point(char *name, int x, int y) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].x = x;
    symbol_table[symbol_count].y = y;
    symbol_count++;
}

Point *find_point(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return &symbol_table[i];
        }
    }
    return NULL;
}
