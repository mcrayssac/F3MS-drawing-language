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
#include "../picture/picture.h"
#include "../text/text.h"
#include "../polygon/polygon.h"
#include "../regular_polygon/regular_polygon.h"

typedef enum {
    FIGURE_POINT,
    FIGURE_LINE,
    FIGURE_RECTANGLE,
    FIGURE_SQUARE,
    FIGURE_CIRCLE,
    FIGURE_ELLIPSE,
    FIGURE_GRID,
    FIGURE_ARC,
    FIGURE_PICTURE,
    FIGURE_TEXT,
    FIGURE_POLYGON,
    FIGURE_REGULAR_POLYGON,
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
        Picture *picture;
        Text *text;
        Polygon *polygon;
        RegularPolygon *regular_polygon;
    } data;
} Figure;

/* Function prototypes */
void add_figure(char *name, Figure *figure);
Figure *find_figure(char *name);

extern LinkedList figure_list;

#endif
