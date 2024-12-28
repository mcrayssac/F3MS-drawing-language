// File: command.h
// Description: Command header
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#ifndef COMMAND_H
#define COMMAND_H

#include "../point/point.h"
#include "../circle/circle.h"
#include "../rectangle/rectangle.h"
#include "../square/square.h"
#include "../line/line.h"
#include "../color/color.h"
#include "../ellipse/ellipse.h"
#include "../grid/grid.h"

#include "../linkedList/linkedList.h"
#include "../figure/figure.h"

/* Command types */
typedef enum
{
    CMD_SET_COLOR,
    CMD_SET_LINE_WIDTH,
    CMD_DRAW_POINT,
    CMD_DRAW_LINE,
    CMD_DRAW_RECTANGLE,
    CMD_DRAW_SQUARE,
    CMD_DRAW_CIRCLE,
    CMD_ROTATE,
    CMD_TRANSLATE,
    CMD_DRAW_ELLIPSE,
    CMD_DRAW_GRID,
} CommandType;

typedef struct
{
    CommandType type;
    char* name;

    union
    {
        Color color;
        int line_width;
        Point* point;
        Line* line;
        Rectangle* rectangle;
        Square* square;
        Circle* circle;
        Ellipse* ellipse;

        struct
        {
            int spacing;
        } grid;

        struct
        {
            Figure* figure;
            int angle;
        } rotate;

        struct
        {
            Figure* figure;
            int dx;
            int dy;
        } translate;

        struct
        {
            Point* p;
            int width;
            int height;
        } Ellipse;
    } data;
} Command;

/* Use a linked list to store commands */
extern LinkedList command_list;

/* Add a command to the list */
void add_command(Command cmd);

#endif
