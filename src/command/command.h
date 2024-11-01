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


/* Command types */
 typedef enum {
    CMD_SET_COLOR,
    CMD_SET_LINE_WIDTH,
    CMD_DRAW_LINE,
    CMD_DRAW_RECTANGLE,
    CMD_DRAW_SQUARE,
    CMD_DRAW_CIRCLE
} CommandType;

// typedef struct {
//     CommandType type;
//     union {
//         struct { int r, g, b; } color;
//         int line_width; //? 
//         struct { Point *p1, *p2; } line;
//         struct { Point *p; int width, height; } rectangle;
//         struct { Point *p; int size; } square;
//         struct { Point *p; int radius; } circle;
//     } data;
// } Command;
typedef struct {
    CommandType type;
    union {
        Color color;
        int line_width;
        Line line;
        Rectangle rectangle;
        Square square;
        Circle circle;
    } data;
} Command;

/* External variables (defined in command.c) */
extern Command command_list[1000];
extern int command_count;

void add_command(Command cmd);

#endif
