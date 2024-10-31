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

/* Function prototype for error handling */
void yyerror(const char *s); 
int yylex(void);

/* Output file */
FILE *output; 

/* Command list */
Command command_list[1000];
int command_count = 0;

/* Function prototypes */
void add_point(char *name, int x, int y);
void update_point(char *name, int x, int y);
Point *find_point(char *name);
void add_command(Command cmd);
void generate_python_code();

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
%token SET_COLOR SET_LINE_WIDTH POINT LINE RECTANGLE SQUARE CIRCLE
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
    | set_line_width_call
    | line_call
    | rectangle_call
    | square_call
    | circle_call
    ;

set_line_width_call:
    SET_LINE_WIDTH LPAREN NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_SET_LINE_WIDTH;
        cmd.data.line_width = $3;
        add_command(cmd);
    }
    ;

set_color_call:
    SET_COLOR LPAREN NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_SET_COLOR;
        cmd.data.color.r = $3;
        cmd.data.color.g = $5;
        cmd.data.color.b = $7;
        add_command(cmd);
    }
    ;

line_call:
    LINE LPAREN expr COMMA expr RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_LINE;
        cmd.data.line.p1 = $3;
        cmd.data.line.p2 = $5;
        add_command(cmd);
    }
    ;

rectangle_call:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_RECTANGLE;
        cmd.data.rectangle.p = $3;
        cmd.data.rectangle.width = $5;
        cmd.data.rectangle.height = $7;
        add_command(cmd);
    }
    ;
    
square_call:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_SQUARE;
        cmd.data.square.p = $3;
        cmd.data.square.size = $5;
        add_command(cmd);
    }
    ;

circle_call : 
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_CIRCLE;
        cmd.data.circle.p = $3;
        cmd.data.circle.radius = $5;
        add_command(cmd);
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

/* Add a command to the command list */
void add_command(Command cmd) {
    if (command_count >= 1000) {
        fprintf(stderr, "Too many commands\n");
        exit(1);
    }
    command_list[command_count++] = cmd;
}

/* Generate Python code from the command list */
void generate_python_code() {
    // Generate code to store commands
    for (int i = 0; i < command_count; i++) {
        Command cmd = command_list[i];
        switch (cmd.type) {
            case CMD_SET_COLOR:
                fprintf(output, "commands.append(('SET_COLOR', (%d, %d, %d)))\n",
                        cmd.data.color.r, cmd.data.color.g, cmd.data.color.b);
                break;
            case CMD_SET_LINE_WIDTH:
                fprintf(output, "commands.append(('SET_LINE_WIDTH', %d))\n",
                        cmd.data.line_width);
                break;
            case CMD_DRAW_LINE:
                fprintf(output, "commands.append(('DRAW_LINE', (%d, %d), (%d, %d)))\n",
                        cmd.data.line.p1->x, cmd.data.line.p1->y,
                        cmd.data.line.p2->x, cmd.data.line.p2->y);
                break;
            case CMD_DRAW_RECTANGLE:
                fprintf(output, "commands.append(('DRAW_RECTANGLE', (%d, %d), %d, %d))\n",
                        cmd.data.rectangle.p->x, cmd.data.rectangle.p->y,
                        cmd.data.rectangle.width, cmd.data.rectangle.height);
                break;
            case CMD_DRAW_SQUARE:
                fprintf(output, "commands.append(('DRAW_SQUARE', (%d, %d), %d))\n",
                        cmd.data.square.p->x, cmd.data.square.p->y,
                        cmd.data.square.size);
                break;
            case CMD_DRAW_CIRCLE:
                fprintf(output, "commands.append(('DRAW_CIRCLE', (%d, %d), %d))\n",
                        cmd.data.circle.p->x, cmd.data.circle.p->y,
                        cmd.data.circle.radius);
                break;
            default:
                break;
        }
    }
}