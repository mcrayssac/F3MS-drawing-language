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

#include "../linkedList/linkedList.h"

/* Command types */
 typedef enum {
    CMD_SET_COLOR,
    CMD_SET_LINE_WIDTH,
    CMD_DRAW_LINE,
    CMD_DRAW_RECTANGLE,
    CMD_DRAW_SQUARE,
    CMD_DRAW_CIRCLE
} CommandType;

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

/* Use a linked list to store commands */
extern LinkedList command_list;

void add_command(Command cmd);

#endif
