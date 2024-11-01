/*  parser.y
    This file contains the parser for the compiler.
    It defines the grammar rules that the parser will use to parse the input file.
    The parser is implemented using bison.
*/

/*  Section: Header Files
    Include necessary header files.
*/
%{
    #include "../external/external.h"
    #include "../common/common.h"
    #include "../command/command.h"

    /* Function prototypes */
    void generate_python_code();
%}

/*  Section: Union
    Define the union type for the parser.
*/
%union {
    int intval;
    char *strval;
    Point *pointval;
    Line *lineval;
    Rectangle *rectangleval;
    Square *squareval;
    Circle *circleval;
    Figure *figureval;
}

/*  Section: Token Types
    Define the token types for the parser.
*/
%token <intval> NUMBER
%token <strval> IDENTIFIER
%token SET_COLOR SET_LINE_WIDTH POINT LINE RECTANGLE SQUARE CIRCLE DRAW
%token LPAREN RPAREN COMMA SEMICOLON EQUALS

/* Section: Nonterminal Types
    Define the nonterminal types for the parser.
*/
%type <pointval> point_expr
%type <lineval> line_expr
%type <rectangleval> rectangle_expr
%type <squareval> square_expr
%type <circleval> circle_expr
%type <figureval> figure_expr
%type <figureval> expr

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
    IDENTIFIER EQUALS figure_expr {
        Figure *figure = $3;
        add_figure($1, figure);
    }
    ;

function_call:
    set_color_call
    | set_line_width_call
    | rectangle_call
    | square_call
    | circle_call
    | draw_call
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

rectangle_call:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_RECTANGLE;
        cmd.data.rectangle = malloc(sizeof(Rectangle));
        if (!cmd.data.rectangle) {
            yyerror("Memory allocation failed in rectangle_call.");
            YYABORT;
        }
        cmd.data.rectangle->p = $3->data.point;
        cmd.data.rectangle->width = $5;
        cmd.data.rectangle->height = $7;
        add_command(cmd);
    }
    ;

square_call:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_SQUARE;
        cmd.data.square = malloc(sizeof(Square));
        if (!cmd.data.square) {
            yyerror("Memory allocation failed in square_call.");
            YYABORT;
        }
        cmd.data.square->p = $3->data.point;
        cmd.data.square->size = $5;
        add_command(cmd);
    }
    ;

circle_call:
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_CIRCLE;
        cmd.data.circle = malloc(sizeof(Circle));
        if (!cmd.data.circle) {
            yyerror("Memory allocation failed in circle_call.");
            YYABORT;
        }
        cmd.data.circle->p = $3->data.point;
        cmd.data.circle->radius = $5;
        add_command(cmd);
    }
    ;

draw_call:
    DRAW LPAREN IDENTIFIER RPAREN {
        Figure *figure = find_figure($3);
        if (figure == NULL) {
            yyerror("Undefined figure");
            YYABORT;
        }
        Command cmd;
        switch (figure->type) {
            case FIGURE_POINT:
                cmd.type = CMD_DRAW_POINT;
                cmd.data.point = malloc(sizeof(Point));
                if (!cmd.data.point) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.point->x = figure->data.point->x;
                cmd.data.point->y = figure->data.point->y;
                break;

            case FIGURE_LINE:
                cmd.type = CMD_DRAW_LINE;
                cmd.data.line = malloc(sizeof(Line));
                if (!cmd.data.line) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.line->p1 = malloc(sizeof(Point));
                cmd.data.line->p2 = malloc(sizeof(Point));
                if (!cmd.data.line->p1 || !cmd.data.line->p2) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.line->p1->x = figure->data.line->p1->x;
                cmd.data.line->p1->y = figure->data.line->p1->y;
                cmd.data.line->p2->x = figure->data.line->p2->x;
                cmd.data.line->p2->y = figure->data.line->p2->y;
                break;

            case FIGURE_RECTANGLE:
                cmd.type = CMD_DRAW_RECTANGLE;
                cmd.data.rectangle = malloc(sizeof(Rectangle));
                if (!cmd.data.rectangle) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.rectangle->p = malloc(sizeof(Point));
                if (!cmd.data.rectangle->p) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.rectangle->p->x = figure->data.rectangle->p->x;
                cmd.data.rectangle->p->y = figure->data.rectangle->p->y;
                cmd.data.rectangle->width = figure->data.rectangle->width;
                cmd.data.rectangle->height = figure->data.rectangle->height;
                break;

            case FIGURE_SQUARE:
                cmd.type = CMD_DRAW_SQUARE;
                cmd.data.square = malloc(sizeof(Square));
                if (!cmd.data.square) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.square->p = malloc(sizeof(Point));
                if (!cmd.data.square->p) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.square->p->x = figure->data.square->p->x;
                cmd.data.square->p->y = figure->data.square->p->y;
                cmd.data.square->size = figure->data.square->size;
                break;

            case FIGURE_CIRCLE:
                cmd.type = CMD_DRAW_CIRCLE;
                cmd.data.circle = malloc(sizeof(Circle));
                if (!cmd.data.circle) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.circle->p = malloc(sizeof(Point));
                if (!cmd.data.circle->p) {
                    yyerror("Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.circle->p->x = figure->data.circle->p->x;
                cmd.data.circle->p->y = figure->data.circle->p->y;
                cmd.data.circle->radius = figure->data.circle->radius;
                break;

            default:
                yyerror("Unknown figure type");
                YYABORT;
        }
        add_command(cmd);
    }
    ;

expr:
    figure_expr
    ;

figure_expr:
    point_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            yyerror("Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_POINT;
        figure->data.point = $1;
        $$ = figure;
    }
    | line_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            yyerror("Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_LINE;
        figure->data.line = $1;
        $$ = figure;
    }
    | rectangle_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            yyerror("Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_RECTANGLE;
        figure->data.rectangle = $1;
        $$ = figure;
    }
    | square_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            yyerror("Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_SQUARE;
        figure->data.square = $1;
        $$ = figure;
    }
    | circle_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            yyerror("Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_CIRCLE;
        figure->data.circle = $1;
        $$ = figure;
    }
    | IDENTIFIER {
        Figure *figure = find_figure($1);
        if (figure == NULL) {
            yyerror("Undefined figure");
            YYABORT;
        } else {
            $$ = figure;
        }
    }
    ;

point_expr:
    POINT LPAREN NUMBER COMMA NUMBER RPAREN {
        Point *point = malloc(sizeof(Point));
        if (!point) {
            yyerror("Memory allocation failed in point_expr.");
            YYABORT;
        }
        point->x = $3;
        point->y = $5;
        $$ = point;
    }
    ;

line_expr:
    LINE LPAREN expr COMMA expr RPAREN {
        Line *line = malloc(sizeof(Line));
        if (!line) {
            yyerror("Memory allocation failed in line_expr.");
            YYABORT;
        }
        line->p1 = $3->data.point;
        line->p2 = $5->data.point;
        $$ = line;
    }
    ;

rectangle_expr:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Rectangle *rectangle = malloc(sizeof(Rectangle));
        if (!rectangle) {
            yyerror("Memory allocation failed in rectangle_expr.");
            YYABORT;
        }
        rectangle->p = $3->data.point;
        rectangle->width = $5;
        rectangle->height = $7;
        $$ = rectangle;
    }
    ;

square_expr:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        Square *square = malloc(sizeof(Square));
        if (!square) {
            yyerror("Memory allocation failed in square_expr.");
            YYABORT;
        }
        square->p = $3->data.point;
        square->size = $5;
        $$ = square;
    }
    ;

circle_expr:
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        Circle *circle = malloc(sizeof(Circle));
        if (!circle) {
            yyerror("Memory allocation failed in circle_expr.");
            YYABORT;
        }
        circle->p = $3->data.point;
        circle->radius = $5;
        $$ = circle;
    }
    ;

%%

/*  Section: Function Definitions
    Define the functions for the parser.
*/

/* Generate Python code from the command list */
void generate_python_code() {
    LinkedList current = command_list;
    while (current != NULL) {
        Command *cmd = (Command *)current->valeur;
        switch (cmd->type) {
            case CMD_SET_COLOR:
                printf("commands.append(('SET_COLOR', (%d, %d, %d)))\n",
                        cmd->data.color.r, cmd->data.color.g, cmd->data.color.b);
                fprintf(output, "commands.append(('SET_COLOR', (%d, %d, %d)))\n",
                        cmd->data.color.r, cmd->data.color.g, cmd->data.color.b);
                break;
            case CMD_SET_LINE_WIDTH:
                printf("commands.append(('SET_LINE_WIDTH', %d))\n",
                        cmd->data.line_width);
                fprintf(output, "commands.append(('SET_LINE_WIDTH', %d))\n",
                        cmd->data.line_width);
                break;
            case CMD_DRAW_POINT:
                printf("commands.append(('DRAW_POINT', (%d, %d)))\n",
                        cmd->data.point->x, cmd->data.point->y);
                fprintf(output, "commands.append(('DRAW_POINT', (%d, %d)))\n",
                        cmd->data.point->x, cmd->data.point->y);
                break;
            case CMD_DRAW_LINE:
                printf("commands.append(('DRAW_LINE', (%d, %d), (%d, %d)))\n",
                        cmd->data.line->p1->x, cmd->data.line->p1->y,
                        cmd->data.line->p2->x, cmd->data.line->p2->y);
                fprintf(output, "commands.append(('DRAW_LINE', (%d, %d), (%d, %d)))\n",
                        cmd->data.line->p1->x, cmd->data.line->p1->y,
                        cmd->data.line->p2->x, cmd->data.line->p2->y);
                break;
            case CMD_DRAW_RECTANGLE:
                printf("commands.append(('DRAW_RECTANGLE', (%d, %d), %d, %d))\n",
                        cmd->data.rectangle->p->x, cmd->data.rectangle->p->y,
                        cmd->data.rectangle->width, cmd->data.rectangle->height);
                fprintf(output, "commands.append(('DRAW_RECTANGLE', (%d, %d), %d, %d))\n",
                        cmd->data.rectangle->p->x, cmd->data.rectangle->p->y,
                        cmd->data.rectangle->width, cmd->data.rectangle->height);
                break;
            case CMD_DRAW_SQUARE:
                printf("commands.append(('DRAW_SQUARE', (%d, %d), %d))\n",
                        cmd->data.square->p->x, cmd->data.square->p->y,
                        cmd->data.square->size);
                fprintf(output, "commands.append(('DRAW_SQUARE', (%d, %d), %d))\n",
                        cmd->data.square->p->x, cmd->data.square->p->y,
                        cmd->data.square->size);
                break;
            case CMD_DRAW_CIRCLE:
                printf("commands.append(('DRAW_CIRCLE', (%d, %d), %d))\n",
                        cmd->data.circle->p->x, cmd->data.circle->p->y,
                        cmd->data.circle->radius);
                fprintf(output, "commands.append(('DRAW_CIRCLE', (%d, %d), %d))\n",
                        cmd->data.circle->p->x, cmd->data.circle->p->y,
                        cmd->data.circle->radius);
                break;
            default:
                break;
        }
        current = current->suivant;
    }
}