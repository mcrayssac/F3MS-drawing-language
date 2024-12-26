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
    
    extern int yylineno;
%}

%error-verbose
%locations

%{
    // Include parser.tab.h to define YYLTYPE
    #include "../temp/parser.tab.h"
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
    Ellipse *ellipseval;
}

/*  Section: Token Types
    Define the token types for the parser.
*/
%token <intval> NUMBER
%token <strval> IDENTIFIER
%token SET_COLOR SET_LINE_WIDTH POINT LINE RECTANGLE SQUARE CIRCLE DRAW ROTATE TRANSLATE ELLIPSE
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
%type <ellipseval> ellipse_expr

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
    | error SEMICOLON {
        error_at_line(@1.first_line, 
            "Syntax Error: Invalid statement\n\n"
            "Expected one of:\n"
            "1. Figure Assignment:\n"
            "   variable = figure;\n\n"
            "2. Drawing Commands:\n"
            "   - draw(figure_name);\n"
            "   - set_color(r,g,b);\n"
            "   - set_line_width(width);\n\n"
            "3. Transformations:\n"
            "   - rotate(figure_name, angle);\n"
            "   - translate(figure_name, dx, dy);\n\n"
            "Examples:\n"
            "✅ mySquare = square(point(0,0), 100);\n"
            "✅ set_color(255, 0, 0);\n"
            "✅ draw(mySquare);\n\n"
            "Common mistakes:\n"
            "❌ square(0,0, 100)      // Missing assignment\n"
            "❌ draw square;          // Missing parentheses\n"
            "❌ myCircle: circle(...) // Wrong assignment operator");
        YYABORT;
    }
    ;

assignment:
    IDENTIFIER EQUALS figure_expr {
        Figure *figure = $3;
        add_figure($1, figure);
    }
    | IDENTIFIER EQUALS error {
        error_at_line(@2.first_line, 
            "Invalid assignment. Usage:\n"
            "variable = figure_expression\n"
            "\nValid assignments:\n"
            "1. Simple figures:\n"
            "   p1 = point(100,200);\n"
            "   c1 = circle(point(300,300), 50);\n"
            "\n2. Compound figures:\n"
            "   line1 = line(point(0,0), point(100,100));\n"
            "\nNaming rules:\n"
            "- Start with letter (a-z, A-Z)\n"
            "- Can contain numbers\n"
            "- No spaces or special characters\n"
            "\nCommon mistakes:\n"
            "❌ 1point = point(0,0)     // Starts with number\n"
            "❌ my point = point(0,0)   // Contains space\n"
            "❌ point = point(0,0)      // Using reserved word\n"
            "✅ myPoint1 = point(0,0)   // Valid name");
        YYABORT;
    }
    ;

function_call:
    set_color_call
    | set_line_width_call
    | rectangle_call
    | square_call
    | circle_call
    | draw_call
    | rotate_call
    | translate_call
    | ellipse_call
    ;

set_line_width_call:
    SET_LINE_WIDTH LPAREN NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_SET_LINE_WIDTH;
        cmd.data.line_width = $3;
        add_command(cmd);
    }
    | SET_LINE_WIDTH LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid line width setting\n\n"
            "Usage: set_line_width(width)\n"
            "where width is a positive number\n\n"
            "Recommended values:\n"
            "╔════════════╦══════════════════╗\n"
            "║ Line Width ║ Visual Effect    ║\n"
            "╠════════════╬══════════════════╣\n"
            "║     1     ║ Very thin line   ║\n"
            "║    2-3    ║ Normal line      ║\n"
            "║    4-5    ║ Thick line       ║\n"
            "║    >5     ║ Very thick line  ║\n"
            "╚════════════╩══════════════════╝\n\n"
            "Examples:\n"
            "✅ set_line_width(1)  // Default thin line\n"
            "✅ set_line_width(3)  // Medium thickness\n"
            "✅ set_line_width(5)  // Thick line\n\n"
            "Common mistakes:\n"
            "❌ set_line_width()     // Missing width\n"
            "❌ set_line_width(-2)   // Negative width\n"
            "❌ set_line_width(2.5)  // Decimal width\n"
            "❌ set_line_width(\"2\")  // String instead of number");
        YYABORT;
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
    | SET_COLOR LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid color values. Expected: set_color(r,g,b) where:\n"
            "- r, g, b are numbers between 0 and 255\n"
            "Common colors:\n"
            "- Red:    set_color(255,0,0)\n"
            "- Green:  set_color(0,255,0)\n"
            "- Blue:   set_color(0,0,255)\n"
            "- Black:  set_color(0,0,0)\n"
            "- White:  set_color(255,255,255)");
        YYABORT;
    }
    ;

rectangle_call:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_RECTANGLE;
        cmd.data.rectangle = malloc(sizeof(Rectangle));
        if (!cmd.data.rectangle) {
            error_at_line(@$.first_line, "Memory allocation failed in rectangle_call.");
            YYABORT;
        }
        cmd.data.rectangle->p = $3->data.point;
        cmd.data.rectangle->width = $5;
        cmd.data.rectangle->height = $7;
        add_command(cmd);
    }
    | RECTANGLE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid rectangle command. Usage:\n"
            "rectangle(point, width, height) where:\n"
            "- point: top-left corner position\n"
            "- width: rectangle width (pixels)\n"
            "- height: rectangle height (pixels)\n"
            "\nExamples:\n"
            "rect1 = rectangle(point(100,100), 200, 150);  // 200x150 rectangle\n"
            "rect2 = rectangle(point(0,0), 500, 300);      // Full width rectangle\n"
            "\nCommon mistakes:\n"
            "❌ rectangle(100,100, 200, 150)  // Missing point constructor\n"
            "❌ rectangle(point, 200)         // Missing height\n"
            "✅ rectangle(point(100,100), 200, 150)");
        YYABORT;
    }
    ;

square_call:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_SQUARE;
        cmd.data.square = malloc(sizeof(Square));
        if (!cmd.data.square) {
            error_at_line(@$.first_line, "Memory allocation failed in square_call.");
            YYABORT;
        }
        cmd.data.square->p = $3->data.point;
        cmd.data.square->size = $5;
        add_command(cmd);
    }
    | SQUARE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid square command. Usage:\n"
            "square(point, size) where:\n"
            "- point: top-left corner position\n"
            "- size: length of each side\n"
            "\nExamples:\n"
            "square1 = square(point(100,100), 50);   // 50x50 square\n"
            "square2 = square(point(0,0), 200);      // Large square at origin\n"
            "\nCommon mistakes:\n"
            "❌ square(100,100, 50)    // Missing point constructor\n"
            "❌ square(point, 50, 50)  // Too many arguments\n"
            "✅ square(point(100,100), 50)");
        YYABORT;
    }
    ;

circle_call:
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_CIRCLE;
        cmd.data.circle = malloc(sizeof(Circle));
        if (!cmd.data.circle) {
            error_at_line(@$.first_line, "Memory allocation failed in circle_call.");
            YYABORT;
        }
        cmd.data.circle->p = $3->data.point;
        cmd.data.circle->radius = $5;
        add_command(cmd);
    }
    ;

ellipse_call:
    ELLIPSE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_ELLIPSE;
        cmd.data.ellipse = malloc(sizeof(Ellipse));
        if (!cmd.data.ellipse) {
            error_at_line(@$.first_line, "Memory allocation failed in ellipse_call.");
            YYABORT;
        }
        cmd.data.ellipse->p = $3->data.point;
        cmd.data.ellipse->width = $5;
        cmd.data.ellipse->height = $7;
        add_command(cmd);
    }
    ;


rotate_call:
    ROTATE LPAREN IDENTIFIER COMMA NUMBER RPAREN {
        Figure *figure = find_figure($3);
        if (figure == NULL) {
            error_at_line(@$.first_line, "Undefined figure '%s'. Note: Expected a figure variable name, not a figure type", $3);
            YYABORT;
        }
        Command cmd;
        cmd.type = CMD_ROTATE;
        cmd.data.rotate.figure = figure;
        cmd.data.rotate.angle = $5;
        add_command(cmd);
    }
    | ROTATE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid rotate command. Usage:\n"
            "rotate(figure_name, angle) where:\n"
            "- figure_name: a previously defined variable\n"
            "- angle: rotation in degrees (clockwise)\n"
            "\nExamples:\n"
            "mySquare = square(point(100,100), 50);\n"
            "rotate(mySquare, 45);    // Rotate 45 degrees clockwise\n"
            "rotate(mySquare, -90);   // Rotate 90 degrees counter-clockwise");
        YYABORT;
    }
    ;

translate_call:
    TRANSLATE LPAREN IDENTIFIER COMMA NUMBER COMMA NUMBER RPAREN {
        Figure *figure = find_figure($3);
        if (figure == NULL) {
            error_at_line(@$.first_line, "Undefined figure");
            YYABORT;
        }
        Command cmd;
        cmd.type = CMD_TRANSLATE;
        cmd.data.translate.figure = figure;
        cmd.data.translate.dx = $5;
        cmd.data.translate.dy = $7;
        add_command(cmd);
    }
    | TRANSLATE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid translate command. Usage:\n"
            "translate(figure_name, dx, dy) where:\n"
            "- figure_name: a previously defined variable\n"
            "- dx: horizontal displacement (positive = right)\n"
            "- dy: vertical displacement (positive = down)\n"
            "\nExamples:\n"
            "myCircle = circle(point(100,100), 50);\n"
            "translate(myCircle, 100, 0);     // Move 100 pixels right\n"
            "translate(myCircle, -50, 200);   // Move 50 left and 200 down");
        YYABORT;
    }
    ;


draw_call:
    DRAW LPAREN IDENTIFIER RPAREN {
        Figure *figure = find_figure($3);
        if (figure == NULL) {
            error_at_line(@$.first_line, "Undefined figure");
            YYABORT;
        }
        Command cmd;
        cmd.name = strdup($3);
        switch (figure->type) {
            case FIGURE_POINT:
                cmd.type = CMD_DRAW_POINT;
                cmd.data.point = malloc(sizeof(Point));
                if (!cmd.data.point) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.point->x = figure->data.point->x;
                cmd.data.point->y = figure->data.point->y;
                break;

            case FIGURE_LINE:
                cmd.type = CMD_DRAW_LINE;
                cmd.data.line = malloc(sizeof(Line));
                if (!cmd.data.line) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.line->p1 = malloc(sizeof(Point));
                cmd.data.line->p2 = malloc(sizeof(Point));
                if (!cmd.data.line->p1 || !cmd.data.line->p2) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
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
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.rectangle->p = malloc(sizeof(Point));
                if (!cmd.data.rectangle->p) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
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
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.square->p = malloc(sizeof(Point));
                if (!cmd.data.square->p) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
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
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.circle->p = malloc(sizeof(Point));
                if (!cmd.data.circle->p) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                cmd.data.circle->p->x = figure->data.circle->p->x;
                cmd.data.circle->p->y = figure->data.circle->p->y;
                cmd.data.circle->radius = figure->data.circle->radius;
                break;

            case FIGURE_ELLIPSE:
   	 			cmd.type = CMD_DRAW_ELLIPSE;
    			cmd.data.ellipse = malloc(sizeof(Ellipse));
    			if (!cmd.data.ellipse) {
        			error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
        			YYABORT;
    			}
    			cmd.data.ellipse->p = malloc(sizeof(Point));
    			if (!cmd.data.ellipse->p) {
        			error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
        			YYABORT;
    			}
    			cmd.data.ellipse->p->x = figure->data.ellipse->p->x;
    			cmd.data.ellipse->p->y = figure->data.ellipse->p->y;
    			cmd.data.ellipse->width = figure->data.ellipse->width;
    			cmd.data.ellipse->height = figure->data.ellipse->height;
    			break;

            default:
                error_at_line(@$.first_line, "Unknown figure type");
                YYABORT;
        }
        add_command(cmd);
    }
    | DRAW LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid draw command. Usage:\n"
            "draw(figure_name) where:\n"
            "- figure_name: name of a previously defined figure\n"
            "\nExample workflow:\n"
            "1. Define a figure:\n"
            "   myCircle = circle(point(100,100), 50);\n"
            "\n2. Draw the figure:\n"
            "   draw(myCircle);\n"
            "\nCommon mistakes:\n"
            "❌ draw(circle(100,100,50))  // Direct figure definition\n"
            "❌ draw(\"myCircle\")         // Using quotes\n"
            "❌ draw(circle)              // Using type instead of variable\n"
            "✅ draw(myCircle)            // Using defined variable");
        YYABORT;
    }
    ;

expr:
    figure_expr
    ;

figure_expr:
    point_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_POINT;
        figure->data.point = $1;
        $$ = figure;
    }
    | line_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_LINE;
        figure->data.line = $1;
        $$ = figure;
    }
    | rectangle_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_RECTANGLE;
        figure->data.rectangle = $1;
        $$ = figure;
    }
    | square_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_SQUARE;
        figure->data.square = $1;
        $$ = figure;
    }
    | circle_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_CIRCLE;
        figure->data.circle = $1;
        $$ = figure;
    }
	| ellipse_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_ELLIPSE;
        figure->data.ellipse = $1;
        $$ = figure;
    }
    | IDENTIFIER {
        Figure *figure = find_figure($1);
        if (figure == NULL) {
            error_at_line(@$.first_line, "Undefined figure");
            YYABORT;
        } else {
            $$ = figure;
        }
    }
    | error {
        error_at_line(@1.first_line, 
            "Invalid figure expression. Available figures:\n\n"
            "1. Point:\n"
            "   point(x, y)\n"
            "   Example: point(100, 200)\n\n"
            "2. Line:\n"
            "   line(point1, point2)\n"
            "   Example: line(point(0,0), point(100,100))\n\n"
            "3. Rectangle:\n"
            "   rectangle(point, width, height)\n"
            "   Example: rectangle(point(50,50), 200, 100)\n\n"
            "4. Square:\n"
            "   square(point, size)\n"
            "   Example: square(point(100,100), 50)\n\n"
            "5. Circle:\n"
            "   circle(point, radius)\n"
            "   Example: circle(point(300,300), 75)\n\n"
			"6. Ellipse:\n"
			"   elipse(point, width, height)\n"
			"   Example: elipse(point(100,100), 100, 150)\n"
            "You can also use previously defined variables.\n"
            "Example: line(p1, p2) where p1 and p2 are point variables");
        YYABORT;
    }
    ;

point_expr:
    POINT LPAREN NUMBER COMMA NUMBER RPAREN {
        Point *point = malloc(sizeof(Point));
        if (!point) {
            error_at_line(@$.first_line, "Memory allocation failed in point_expr.");
            YYABORT;
        }
        point->x = $3;
        point->y = $5;
        $$ = point;
    }
    | POINT LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid point expression. Usage:\n"
            "point(x, y) where:\n"
            "- x: horizontal position (0 = left, increases right)\n"
            "- y: vertical position (0 = top, increases down)\n"
            "\nScreen coordinate system:\n"
            "  0,0 ─→ x\n"
            "   │\n"
            "   ↓ y\n"
            "\nExamples:\n"
            "p1 = point(0, 0);      // Top-left corner\n"
            "p2 = point(500, 0);    // Top-right area\n"
            "p3 = point(250, 400);  // Middle-bottom area\n"
            "\nCommon mistakes:\n"
            "❌ point(100)      // Missing y coordinate\n"
            "❌ point('100,100') // Using strings\n"
            "✅ point(100, 100)");
        YYABORT;
    }
    ;

line_expr:
    LINE LPAREN expr COMMA expr RPAREN {
        Line *line = malloc(sizeof(Line));
        if (!line) {
            error_at_line(@$.first_line, "Memory allocation failed in line_expr.");
            YYABORT;
        }
        line->p1 = $3->data.point;
        line->p2 = $5->data.point;
        $$ = line;
    }
    | LINE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid line expression. Usage:\n"
            "line(point1, point2) where:\n"
            "- point1: start point coordinates\n"
            "- point2: end point coordinates\n"
            "\nValid forms:\n"
            "1. Direct points:\n"
            "   line(point(0,0), point(100,100))\n"
            "\n2. Using variables:\n"
            "   p1 = point(0,0);\n"
            "   p2 = point(100,100);\n"
            "   line(p1, p2);\n"
            "\nCommon mistakes:\n"
            "❌ line(0,0, 100,100)    // Missing point constructors\n"
            "❌ line(point(0,0))      // Missing second point\n"
            "❌ line(p1, 100)         // Second argument not a point\n"
            "✅ line(point(0,0), point(100,100))");
        YYABORT;
    }
    ;

rectangle_expr:
    RECTANGLE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Rectangle *rectangle = malloc(sizeof(Rectangle));
        if (!rectangle) {
            error_at_line(@$.first_line, "Memory allocation failed in rectangle_expr.");
            YYABORT;
        }
        rectangle->p = $3->data.point;
        rectangle->width = $5;
        rectangle->height = $7;
        $$ = rectangle;
    }
    | RECTANGLE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid rectangle expression. Expected: rectangle(point, width, height). Example: rectangle(point(0,0), 100, 200)");
        YYABORT;
    }
    ;

square_expr:
    SQUARE LPAREN expr COMMA NUMBER RPAREN {
        Square *square = malloc(sizeof(Square));
        if (!square) {
            error_at_line(@$.first_line, "Memory allocation failed in square_expr.");
            YYABORT;
        }
        square->p = $3->data.point;
        square->size = $5;
        $$ = square;
    }
    | SQUARE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid square expression. Expected: square(point, size). Example: square(point(0,0), 100)");
        YYABORT;
    }
    ;

circle_expr:
    CIRCLE LPAREN expr COMMA NUMBER RPAREN {
        Circle *circle = malloc(sizeof(Circle));
        if (!circle) {
            error_at_line(@$.first_line, "Memory allocation failed in circle_expr.");
            YYABORT;
        }
        circle->p = $3->data.point;
        circle->radius = $5;
        $$ = circle;
    }
    | CIRCLE LPAREN error {
        error_at_line(@3.first_line, 
            "Invalid circle command. Usage:\n"
            "circle(point, radius) where:\n"
            "- point: center position\n"
            "- radius: circle radius in pixels\n"
            "\nExamples:\n"
            "circle1 = circle(point(300,300), 100);  // Large centered circle\n"
            "circle2 = circle(point(50,50), 25);     // Small corner circle\n"
            "\nCommon mistakes:\n"
            "❌ circle(300,300, 100)   // Missing point constructor\n"
            "❌ circle(point, 100,100) // Too many arguments\n"
            "✅ circle(point(300,300), 100)");
        YYABORT;
    }
    ;

ellipse_expr:
    ELLIPSE LPAREN expr COMMA NUMBER COMMA NUMBER RPAREN {
        Ellipse *ellipse = malloc(sizeof(Ellipse));
        if (!ellipse) {
            error_at_line(@$.first_line, "Memory allocation failed in ellipse_expr.");
            YYABORT;
        }
        ellipse->p = $3->data.point;
        ellipse->width = $5;
        ellipse->height = $7;
        $$ = ellipse;
    }
    | ELLIPSE LPAREN error {
        error_at_line(@3.first_line,
            "Invalid ellipse expression. Usage:\n"
            "ellipse(point, width, height) where:\n"
            "- point: center point of the ellipse\n"
            "- width: width of the ellipse\n"
            "- height: height of the ellipse\n"
            "\nExamples:\n"
            "myellipse = ellipse(point(100,100), 150, 100);  // Ellipse with width 150px and height 100px\n"
            "\nCommon mistakes:\n"
            "❌ ellipse(100,100, 150, 100)  // Missing point constructor\n"
            "❌ ellipse(point, 150)         // Missing height\n"
            "✅ ellipse(point(100,100), 150, 100)");
        YYABORT;
    }
    ;

%%

/*  Section: Function Definitions
    Define the functions for the parser.
*/

/* Error handling functions */
void yyerror_simple(const char *msg) {
    // For Bison's internal error reporting
    fprintf(stderr, "Error: %s\n", msg);
}

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
                printf("commands.append(('DRAW_POINT', (%d, %d), '%s'))\n",
                        cmd->data.point->x, cmd->data.point->y, cmd->name);
                fprintf(output, "commands.append(('DRAW_POINT', (%d, %d), '%s'))\n",
                        cmd->data.point->x, cmd->data.point->y, cmd->name);
                break;
            case CMD_DRAW_LINE:
                printf("commands.append(('DRAW_LINE', (%d, %d), (%d, %d), '%s'))\n",
                        cmd->data.line->p1->x, cmd->data.line->p1->y,
                        cmd->data.line->p2->x, cmd->data.line->p2->y,
                        cmd->name);
                fprintf(output, "commands.append(('DRAW_LINE', (%d, %d), (%d, %d), '%s'))\n",
                        cmd->data.line->p1->x, cmd->data.line->p1->y,
                        cmd->data.line->p2->x, cmd->data.line->p2->y,
                        cmd->name);
                break;
            case CMD_DRAW_RECTANGLE:
                printf("commands.append(('DRAW_RECTANGLE', (%d, %d), %d, %d, '%s'))\n",
                        cmd->data.rectangle->p->x, cmd->data.rectangle->p->y,
                        cmd->data.rectangle->width, cmd->data.rectangle->height,
                        cmd->name);
                fprintf(output, "commands.append(('DRAW_RECTANGLE', (%d, %d), %d, %d, '%s'))\n",
                        cmd->data.rectangle->p->x, cmd->data.rectangle->p->y,
                        cmd->data.rectangle->width, cmd->data.rectangle->height,
                        cmd->name);
                break;
            case CMD_DRAW_SQUARE:
                printf("commands.append(('DRAW_SQUARE', (%d, %d), %d, '%s'))\n",
                        cmd->data.square->p->x, cmd->data.square->p->y,
                        cmd->data.square->size,
                        cmd->name);
                fprintf(output, "commands.append(('DRAW_SQUARE', (%d, %d), %d, '%s'))\n",
                        cmd->data.square->p->x, cmd->data.square->p->y,
                        cmd->data.square->size,
                        cmd->name);
                break;
            case CMD_DRAW_CIRCLE:
                printf("commands.append(('DRAW_CIRCLE', (%d, %d), %d, '%s'))\n",
                        cmd->data.circle->p->x, cmd->data.circle->p->y,
                        cmd->data.circle->radius,
                        cmd->name);
                fprintf(output, "commands.append(('DRAW_CIRCLE', (%d, %d), %d, '%s'))\n",
                        cmd->data.circle->p->x, cmd->data.circle->p->y,
                        cmd->data.circle->radius,
                        cmd->name);
                break;

			case CMD_DRAW_ELLIPSE:
    			printf("commands.append(('DRAW_ELLIPSE', (%d, %d), %d, %d, '%s'))\n",
    			    cmd->data.ellipse->p->x, cmd->data.ellipse->p->y,
    			    cmd->data.ellipse->width, cmd->data.ellipse->height,
    			    cmd->name);
    			fprintf(output, "commands.append(('DRAW_ELLIPSE', (%d, %d), %d, %d, '%s'))\n",
    				    cmd->data.ellipse->p->x, cmd->data.ellipse->p->y,
    				    cmd->data.ellipse->width, cmd->data.ellipse->height,
				        cmd->name);
    			break;

            case CMD_ROTATE:
                printf("commands.append(('ROTATE', '%s', %d))\n",
                       cmd->data.rotate.figure->name, cmd->data.rotate.angle);
                fprintf(output, "commands.append(('ROTATE', '%s', %d))\n",
                        cmd->data.rotate.figure->name, cmd->data.rotate.angle);
                break;
            case CMD_TRANSLATE:
                printf("commands.append(('TRANSLATE', '%s', %d, %d))\n",
                        cmd->data.translate.figure->name, cmd->data.translate.dx, cmd->data.translate.dy);
                fprintf(output, "commands.append(('TRANSLATE', '%s', %d, %d))\n",
                        cmd->data.translate.figure->name, cmd->data.translate.dx, cmd->data.translate.dy);
                break;
            default:
                break;
        }
        current = current->suivant;
    }
}