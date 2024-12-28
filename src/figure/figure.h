// File: figure.h
// Description: Figure header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef FIGURE_H
#define FIGURE_H

#include "../point/point.h"
#include "../circle/circle.h"
#include "../rectangle/rectangle.h"
#include "../square/square.h"
#include "../line/line.h"
#include "../color/color.h"
#include "../linkedList/linkedList.h"
#include "../ellipse/ellipse.h"
#include "../grid/grid.h"
#include "../arc/arc.h"

typedef enum {
    FIGURE_POINT,
    FIGURE_LINE,
    FIGURE_RECTANGLE,
    FIGURE_SQUARE,
    FIGURE_CIRCLE,
    FIGURE_ELLIPSE,
    FIGURE_GRID,
    FIGURE_ARC
} FigureType;

typedef struct {
    char *name;
    FigureType type;
    union {
        Point *point;
        Line *line;
        Rectangle *rectangle;
        Square *square;
        Circle *circle;
        Ellipse *ellipse;
        Grid *grid;
        Arc *arc;
    } data;
} Figure;

/* Function prototypes */
void add_figure(char *name, Figure *figure);
Figure *find_figure(char *name);

extern LinkedList figure_list;

#endif
