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

%define parse.error verbose
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
    float floatval;
    Point *pointval;
    Line *lineval;
    Rectangle *rectangleval;
    Square *squareval;
    Circle *circleval;
    Figure *figureval;
    Ellipse *ellipseval;
    Grid *gridval;
    Arc *arcval;
    Picture *pictureval;
    Text *textval;
}

/*  Section: Token Types
    Define the token types for the parser.
*/
%token <intval> NUMBER
%token <strval> IDENTIFIER STRING
%token SET_COLOR SET_LINE_WIDTH POINT LINE RECTANGLE SQUARE CIRCLE DRAW ROTATE TRANSLATE ELLIPSE GRID ARC PICTURE TEXT
%token LPAREN RPAREN COMMA SEMICOLON EQUALS
%token <floatval> FLOAT

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
%type <gridval> grid_expr
%type <arcval> arc_expr
%type <pictureval> picture_expr
%type <textval> text_expr

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
    | grid_call
    | arc_call
    | picture_call
    | text_call
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
    | ELLIPSE LPAREN error {
        error_at_line(@3.first_line,
            "Invalid ellipse command. Usage:\n"
            "ellipse(point, width, height) where:\n"
            "- point: center point of the ellipse\n"
            "- width: width of the ellipse\n"
            "- height: height of the ellipse\n"
            "\nExamples:\n"
            "ellipse(point(100,100), 150, 100);  // Ellipse with width 150px and height 100px\n"
            "\nCommon mistakes:\n"
            "❌ ellipse(100,100, 150, 100)  // Missing point constructor\n"
            "❌ ellipse(point, 150)         // Missing height\n"
            "✅ ellipse(point(100,100), 150, 100)");
        YYABORT;
    }
    ;

grid_call:
    GRID LPAREN NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_GRID;
        cmd.data.grid = malloc(sizeof(Grid));
        if (!cmd.data.grid) {
            error_at_line(@$.first_line, "Memory allocation failed in grid_call.");
            YYABORT;
        }
        cmd.data.grid->spacing = $3;
        add_command(cmd);
    }
    | GRID LPAREN error {
        error_at_line(@3.first_line,
            "Invalid grid command. Usage:\n"
            "grid(spacing) where:\n"
            "- spacing: distance between grid lines in pixels\n"
            "\nExamples:\n"
            "grid(50);  // Creates a grid with 50px spacing\n"
            "grid(100); // Creates a grid with 100px spacing\n"
            "\nCommon mistakes:\n"
            "❌ grid();        // Missing spacing value\n"
            "❌ grid(0);       // Spacing must be positive\n"
            "❌ grid(50, 100); // Too many arguments\n"
            "✅ grid(50)");
        YYABORT;
    }
    ;

arc_call:
    ARC LPAREN expr COMMA expr COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_ARC;
        cmd.data.arc = malloc(sizeof(Arc));
        if (!cmd.data.arc) {
            error_at_line(@$.first_line, "Memory allocation failed in arc_call.");
            YYABORT;
        }
        cmd.data.arc->p1 = $3->data.point;
        cmd.data.arc->p2 = $5->data.point;
        cmd.data.arc->angle = $7;
        cmd.data.arc->thickness = $9;
        add_command(cmd);
    }
    | ARC LPAREN error {
        error_at_line(@3.first_line,
            "Invalid arc command. Usage:\n"
            "arc(point1, point2, angle, thickness) where:\n"
            "- point1: starting point\n"
            "- point2: ending point\n"
            "- angle: angle in degrees (0-360)\n"
            "- thickness: line thickness\n"
            "\nExample:\n"
            "arc(point(100,100), point(200,200), 90, 2);\n"
            "\nCommon mistakes:\n"
            "❌ arc(100,100, 200,200, 90)  // Missing point constructor\n"
            "❌ arc(p1, p2, 90)            // Missing thickness\n"
            "✅ arc(point(100,100), point(200,200), 90, 2)");
        YYABORT;
    }
    ;

picture_call:
    PICTURE LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA FLOAT RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_PICTURE;
        cmd.data.picture = create_picture($3, $5, $7, $9);
        if (!cmd.data.picture) {
            error_at_line(@$.first_line, "Memory allocation failed in picture_call.");
            YYABORT;
        }
        add_command(cmd);
    }
    | PICTURE LPAREN error {
        error_at_line(@3.first_line,
            "Invalid picture command. Usage:\n"
            "picture(path, x, y, scale) where:\n"
            "- path: string path to the image file\n"
            "- x: x-coordinate position\n"
            "- y: y-coordinate position\n"
            "- scale: scaling factor (float)\n"
            "\nExamples:\n"
            "pic1 = picture(\"image.png\", 100, 100, 1.0);    // Normal size\n"
            "pic2 = picture(\"logo.jpg\", 0, 0, 2.5);         // Scaled up\n"
            "\nCommon mistakes:\n"
            "❌ picture(image.png, 100, 100, 1.0)     // Missing quotes\n"
            "❌ picture(\"image.png\", 100, 100)      // Missing scale\n"
            "✅ picture(\"image.png\", 100, 100, 1.0)");
        YYABORT;
    }
    ;
text_call:
    TEXT LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        Command cmd;
        cmd.type = CMD_DRAW_TEXT;
        cmd.data.text = malloc(sizeof(Text));
        if (!cmd.data.text) {
            error_at_line(@$.first_line, "Memory allocation failed in text_call.");
            YYABORT;
        }
        cmd.data.text->text = $3;
        cmd.data.text->position = malloc(sizeof(Point));
        if (!cmd.data.text->position) {
            free(cmd.data.text->text);
            free(cmd.data.text);
            error_at_line(@$.first_line, "Memory allocation failed in text_call.");
            YYABORT;
        }
        cmd.data.text->position->x = $5;
        cmd.data.text->position->y = $7;
        cmd.data.text->size = $9;
        add_command(cmd);
    }
    | TEXT LPAREN error {
        error_at_line(@3.first_line,
            "Invalid text command. Usage:\n"
            "text(text, x, y, size) where:\n"
            "- text: the text to display\n"
            "- x: the x-coordinate of the text\n"
            "- y: the y-coordinate of the text\n"
            "- size: the font size of the text\n"
            "\nExample:\n"
            "text(\"Hello World\", 100, 100, 50)");
        YYABORT;
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

            case FIGURE_ARC:
                fprintf(output, "p1 = (%d, %d)\n",
                    figure->data.arc->p1->x,
                    figure->data.arc->p1->y);
                fprintf(output, "p2 = (%d, %d)\n",
                    figure->data.arc->p2->x,
                    figure->data.arc->p2->y);

                fprintf(output, "radius = int(((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)**0.5 / 2)\n");
                fprintf(output, "rect = pygame.Rect(p1[0] - radius, p1[1] - radius, radius * 2, radius * 2)\n");

                fprintf(output, "pygame.draw.arc(screen, color, rect, 0, math.radians(%f), %d)\n",
                    figure->data.arc->angle,
                    figure->data.arc->thickness);

                if (figure->name != NULL) {
                fprintf(output, "figures['%s'] = {\n", figure->name);
                fprintf(output, "    'type': 'arc',\n");
                fprintf(output, "    'rect': rect,\n");
                fprintf(output, "    'start_angle': 0,\n");
                fprintf(output, "    'end_angle': math.radians(%f),\n", figure->data.arc->angle);
                fprintf(output, "    'thickness': %d,\n", figure->data.arc->thickness);
                fprintf(output, "    'color': color\n");
                fprintf(output, "}\n");
                }
                break;

            case FIGURE_PICTURE:
                cmd.type = CMD_DRAW_PICTURE;
                cmd.data.picture = copy_picture(figure->data.picture);
                if (!cmd.data.picture) {
                    error_at_line(@$.first_line, "Memory allocation failed in draw_call.");
                    YYABORT;
                }
                add_command(cmd);
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
    | grid_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_GRID;
        figure->data.grid = $1;
        $$ = figure;
    }
    | arc_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_ARC;
        figure->data.arc = $1;
        $$ = figure;
    }
    | picture_expr {
        Figure *figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_PICTURE;
        figure->data.picture = $1;
        $$ = figure;
    }
    | text_expr {
        Figure* figure = malloc(sizeof(Figure));
        if (!figure) {
            error_at_line(@$.first_line, "Memory allocation failed in figure_expr.");
            YYABORT;
        }
        figure->type = FIGURE_TEXT;
        figure->data.text = $1;
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
            "   Example: elipse(point(100,100), 100, 150)\n\n"
            "7. Grid:\n"
            "   grid(spacing)\n"
            "   Example: grid(50)\n\n"
            "8. Arc:\n"
            "   arc(point1, point2, angle, thickness)\n"
            "   Example: arc(point(0,0), point(100,100), 90, 2)\n\n"
            "9. Picture:\n"
            "   picture(path, x, y, scale)\n"
            "   Example: picture(\"image.png\", 100, 100, 1.0)\n\n"
            "10. Text:\n"
            "   text(content, x, y, size)\n"
            "   Example: text(\"Hello World\", 100, 100, 24)\n\n"
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
            "Invalid ellipse expression. Expected: ellipse(point, width, height). Example: ellipse(point(0,0), 100, 200)");
        YYABORT;
    }
    ;

grid_expr:
    GRID LPAREN NUMBER RPAREN {
        Grid *grid = malloc(sizeof(Grid));
        if (!grid) {
            error_at_line(@$.first_line, "Memory allocation failed in grid_expr.");
            YYABORT;
        }
        grid->spacing = $3;
        $$ = grid;
    }
    | GRID LPAREN error {
        error_at_line(@3.first_line,
            "Invalid grid expression. Expected: grid(spacing). Example: grid(50)");
        YYABORT;
    }
    ;

arc_expr:
    ARC LPAREN expr COMMA expr COMMA NUMBER COMMA NUMBER RPAREN {
        Arc *arc = malloc(sizeof(Arc));
        if (!arc) {
            error_at_line(@$.first_line, "Memory allocation failed in arc_expr.");
            YYABORT;
        }
        arc->p1 = $3->data.point;
        arc->p2 = $5->data.point;
        arc->angle = $7;
        arc->thickness = $9;
        $$ = arc;
    }
    | ARC LPAREN error {
        error_at_line(@3.first_line,
            "Invalid arc expression. Expected: arc(point1, point2, angle, thickness). Example: arc(point(0,0), point(100,100), 90, 2)");
        YYABORT;
    }
    ;

picture_expr:
    PICTURE LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA FLOAT RPAREN {
        Picture *pic = create_picture($3, $5, $7, $9);
        if (!pic) {
            error_at_line(@$.first_line, "Memory allocation failed in picture_expr.");
            YYABORT;
        }
        $$ = pic;
    }
    | PICTURE LPAREN error {
        error_at_line(@3.first_line,
            "Invalid picture expression. Expected: picture(path, x, y, scale). Example: picture(\"image.png\", 100, 100, 1.0)");
        YYABORT;
    }
    ;

text_expr:
    TEXT LPAREN STRING COMMA NUMBER COMMA NUMBER COMMA NUMBER RPAREN {
        Point* point = malloc(sizeof(Point));
        if (!point) {
            error_at_line(@$.first_line, "Memory allocation failed in text_expr.");
            YYABORT;
        }
        point->x = $5;
        point->y = $7;
        Text* text = create_text($3, point, $9);
        $$ = text;
    }
    | TEXT LPAREN error {
        error_at_line(@3.first_line,
            "Invalid text expression. Usage:\n"
            "text(text, x, y, size) where:\n"
            "- text: the text to display\n"
            "- x: the x-coordinate of the text\n"
            "- y: the y-coordinate of the text\n"
            "- size: the font size of the text\n"
            "\nExample:\n"
            "text(\"Hello World\", 100, 100, 50)");
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

            case CMD_DRAW_GRID:
                printf("commands.append(('DRAW_GRID', %d))\n", cmd->data.grid->spacing);
                fprintf(output, "commands.append(('DRAW_GRID', %d))\n", cmd->data.grid->spacing);
                break;

            case CMD_DRAW_ARC:
                printf("commands.append(('DRAW_ARC', (%d, %d), (%d, %d), %f, %d, '%s'))\n",
                       cmd->data.arc->p1->x, cmd->data.arc->p1->y,
                       cmd->data.arc->p2->x, cmd->data.arc->p2->y,
                       cmd->data.arc->angle, cmd->data.arc->thickness,
                       cmd->name);
                fprintf(output, "commands.append(('DRAW_ARC', (%d, %d), (%d, %d), %f, %d, '%s'))\n",
                       cmd->data.arc->p1->x, cmd->data.arc->p1->y,
                       cmd->data.arc->p2->x, cmd->data.arc->p2->y,
                       cmd->data.arc->angle, cmd->data.arc->thickness,
                       cmd->name);
                break;

            case CMD_DRAW_PICTURE:
                printf("commands.append(('DRAW_PICTURE', %s, %d, %d, %f))\n",
                       cmd->data.picture->path,
                       cmd->data.picture->x,
                       cmd->data.picture->y,
                       cmd->data.picture->scale);
                fprintf(output, "commands.append(('DRAW_PICTURE', %s, %d, %d, %f))\n",
                       cmd->data.picture->path,
                       cmd->data.picture->x,
                       cmd->data.picture->y,
                       cmd->data.picture->scale);
                break;

            case CMD_DRAW_TEXT:
                printf("commands.append(('DRAW_TEXT', %s, %d, %d, %d))\n",
                       cmd->data.text->text, cmd->data.text->position->x, cmd->data.text->position->y, cmd->data.text->size);
                fprintf(output, "commands.append(('DRAW_TEXT', %s, %d, %d, %d))\n",
                       cmd->data.text->text, cmd->data.text->position->x, cmd->data.text->position->y, cmd->data.text->size);
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