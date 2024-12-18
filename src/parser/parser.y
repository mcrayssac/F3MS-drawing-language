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
#include <math.h>

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
    PointList *pointlistval;
    float fval;
}

/*  Section: Token Types
    Define the token types for the parser.
*/
%token <intval> NUMBER
%token <strval> IDENTIFIER
%token SET_COLOR SET_LINE_WIDTH POINT LINE RECTANGLE SQUARE CIRCLE ELLIPSE GRID ARC IMAGE TEXT
%token LPAREN RPAREN COMMA SEMICOLON EQUALS
%token POLYGON LBRACKET RBRACKET
%token REGULAR_POLYGON
%token <strval> STRING
%token <fval> FLOAT

/* Section: Nonterminal Types
    Define the nonterminal types for the parser.
*/
%type <pointval> point_expr
%type <pointval> expr
%type <pointlistval> point_list
%type <pointlistval> point_expr_list


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
    | list_definition SEMICOLON
    | function_call SEMICOLON
    ;

assignment:
    IDENTIFIER EQUALS point_expr {
        update_point($1, $3->x, $3->y);
    }
    ;

function_call:
    set_color_call
    |set_line_width_call
    |line_call
    |rectangle_call
    |square_call
    |circle_call
    |ellipse_call
    |grid_call
    |polygon_call
    |regular_polygon_call
    |arc_call
    |image_call
    |text_call
    ;

set_line_width_call:
    SET_LINE_WIDTH LPAREN NUMBER RPAREN {
        fprintf(output, "line_width = %d\n", $3);
    }
    ;

set_color_call:
    SET_COLOR LPAREN NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "color = [%d, %d, %d]\n", $3, $5, $7);
    }
    ;

line_call:
    LINE LPAREN expr COMMA expr RPAREN {
        fprintf(output, "pygame.draw.line(screen, color, (%d, %d), (%d, %d), line_width)\n",
                $3->x, $3->y, $5->x, $5->y);
    }
    ;

rectangle_call:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "pygame.draw.rect(screen, color, pygame.Rect(%d, %d, %d, %d))\n",
                $3->x, $3->y, $5, $7);
    }
    ;

square_call:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        fprintf(output, "pygame.draw.rect(screen, color, pygame.Rect(%d, %d, %d, %d))\n",
                $3->x, $3->y, $5, $5);
    }
    ;

circle_call :
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        fprintf(output, "pygame.draw.circle(screen, color,(%d, %d), %d, line_width)\n",
        $3->x, $3->y, $5);
    }
    ;

ellipse_call:
    ELLIPSE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "pygame.draw.ellipse(screen, color, pygame.Rect(%d, %d, %d, %d))\n",
                $3->x, $3->y, $5, $7);
    }
    ;

grid_call:
    GRID LPAREN RPAREN {
        fprintf(output, "for x in range(0, 1000, 50):\n");
        fprintf(output, "    pygame.draw.line(screen, (0, 0, 0), (x, 0), (x, 800), 1)\n");
        fprintf(output, "for y in range(0, 800, 50):\n");
        fprintf(output, "    pygame.draw.line(screen, (0, 0, 0), (0, y), (1000, y), 1)\n");
    }
    ;

polygon_call:
    POLYGON LPAREN IDENTIFIER RPAREN {
        fprintf(output, "pygame.draw.polygon(screen, color, %s, line_width)\n", $3);
    }
    | POLYGON LPAREN point_list RPAREN {
        fprintf(output, "pygame.draw.polygon(screen, color, [");
        PointList *current = $3;
        while (current != NULL) {
            fprintf(output, "(%d, %d), ", current->point->x, current->point->y);
            current = current->next;
        }
        fprintf(output, "], line_width)\n");
    }
    ;

regular_polygon_call:
    /*cas où le rayon est un FLOAT */
    REGULAR_POLYGON LPAREN IDENTIFIER COMMA NUMBER COMMA FLOAT RPAREN {
        Point *center = find_point($3); /* Trouve le centre défini */
        if (center == NULL) {
            yyerror("Undefined point for regular_polygon.");
            YYABORT;
        }
        fprintf(output, "points = []\n");
        fprintf(output, "cx, cy = %d, %d\n", center->x, center->y);
        fprintf(output, "sides, radius = %d, %f\n", $5, $7); /* $5 = côtés, $7 = rayon */
        fprintf(output, "for i in range(sides):\n");
        fprintf(output, "    angle = 2 * 3.14159 * i / sides\n");
        fprintf(output, "    x = cx + radius * math.cos(angle)\n");
        fprintf(output, "    y = cy + radius * math.sin(angle)\n");
        fprintf(output, "    points.append((x, y))\n");
        fprintf(output, "pygame.draw.polygon(screen, color, points, line_width)\n");
    }
    /*cas où le rayon est un NUMBER (on converti en FLOAT) */
    | REGULAR_POLYGON LPAREN IDENTIFIER COMMA NUMBER COMMA NUMBER RPAREN {
        Point *center = find_point($3); /* Trouve le centre défini */
        if (center == NULL) {
            yyerror("Undefined point for regular_polygon.");
            YYABORT;
        }
        fprintf(output, "points = []\n");
        fprintf(output, "cx, cy = %d, %d\n", center->x, center->y);
        fprintf(output, "sides, radius = %d, %f\n", $5, (float)$7); /* Conversion explicite de $7 en FLOAT */
        fprintf(output, "for i in range(sides):\n");
        fprintf(output, "    angle = 2 * 3.14159 * i / sides\n");
        fprintf(output, "    x = cx + radius * math.cos(angle)\n");
        fprintf(output, "    y = cy + radius * math.sin(angle)\n");
        fprintf(output, "    points.append((x, y))\n");
        fprintf(output, "pygame.draw.polygon(screen, color, points, line_width)\n");
    }
    /*cas où le centre est défini par des coordonnées inline + float */
    | REGULAR_POLYGON LPAREN LBRACKET NUMBER COMMA NUMBER RBRACKET COMMA NUMBER COMMA FLOAT RPAREN {
        fprintf(output, "points = []\n");
        fprintf(output, "cx, cy = %d, %d\n", $4, $6);
        fprintf(output, "sides, radius = %d, %f\n", $9, $11);
        fprintf(output, "for i in range(sides):\n");
        fprintf(output, "    angle = 2 * 3.14159 * i / sides\n");
        fprintf(output, "    x = cx + radius * math.cos(angle)\n");
        fprintf(output, "    y = cy + radius * math.sin(angle)\n");
        fprintf(output, "    points.append((x, y))\n");
        fprintf(output, "pygame.draw.polygon(screen, color, points, line_width)\n");
    }
    /*cas où le centre est défini par des coordonnées inline + number */
    | REGULAR_POLYGON LPAREN LBRACKET NUMBER COMMA NUMBER RBRACKET COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output, "points = []\n");
        fprintf(output, "cx, cy = %d, %d\n", $4, $6);
        fprintf(output, "sides, radius = %d, %f\n", $9, (float)$11);
        fprintf(output, "for i in range(sides):\n");
        fprintf(output, "    angle = 2 * 3.14159 * i / sides\n");
        fprintf(output, "    x = cx + radius * math.cos(angle)\n");
        fprintf(output, "    y = cy + radius * math.sin(angle)\n");
        fprintf(output, "    points.append((x, y))\n");
        fprintf(output, "pygame.draw.polygon(screen, color, points, line_width)\n");
    }
    ;

arc_call:
    ARC LPAREN expr COMMA expr COMMA NUMBER COMMA NUMBER RPAREN {
        Point *p1 = $3;  // Premier point
        Point *p2 = $5;  // Deuxième point
        double angle_deg = $7;  // Angle en degrés
        int epaisseur = $9;    // Épaisseur du trait

        // Calculer le rayon (distance entre les deux points divisée par 2)
        int radius = (int)sqrt(pow(p2->x - p1->x, 2) + pow(p2->y - p1->y, 2)) / 2;

        // Générer le code Python pour dessiner l'arc
        fprintf(output, "pygame.draw.arc(screen, color, pygame.Rect(%d, %d, %d, %d), 0, %f, %d)\n",
                p1->x - radius,      // Rectangle x
                p1->y - radius,      // Rectangle y
                radius * 2,          // Rectangle width
                radius * 2,          // Rectangle height
                angle_deg * M_PI / 180.0,  // Angle en radians
                epaisseur           // Épaisseur
        );
    };

image_call:
    IMAGE LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA FLOAT RPAREN {
        fprintf(output,
            "image = pygame.image.load(%s).convert_alpha()\n"
            "image_width, image_height = image.get_size()\n"
            "scaled_image = pygame.transform.scale(image, (int(image_width * %f), int(image_height * %f)))\n"
            "screen.blit(scaled_image, (%d, %d))\n"
            "pygame.display.flip()\n",
            $3, $9, $9, $5, $7);
    }
    ;

text_call:
    TEXT LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        fprintf(output,
            "font = pygame.font.Font(None, %d)\n"
            "text_surface = font.render(%s, True, color)\n"
            "screen.blit(text_surface, (%d, %d))\n"
            "pygame.display.flip()\n",
        $9, $3, $5, $7);
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
point_list:
    LBRACKET point_expr_list RBRACKET {
        $$ = $2;
    }
    ;

point_expr_list:
    point_expr {
        PointList *list = malloc(sizeof(PointList));
        list->point = $1;
        list->next = NULL;
        $$ = list;
    }
    | point_expr_list COMMA point_expr {
        PointList *new_node = malloc(sizeof(PointList));
        new_node->point = $3;
        new_node->next = NULL;

        PointList *temp = $1;
        while (temp->next != NULL) temp = temp->next;
        temp->next = new_node;

        $$ = $1;  /* $1 est la liste existante */
    }
    ;

list_definition:
    IDENTIFIER EQUALS point_list {
        fprintf(output, "%s = [", $1);
        PointList *current = $3;
        while (current != NULL) {
            fprintf(output, "(%d, %d), ", current->point->x, current->point->y);
            current = current->next;
        }
        fprintf(output, "]\n");
    }
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
