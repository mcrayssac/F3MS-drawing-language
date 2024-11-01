// File: line.h
// Description: Line header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef LINE_H
#define LINE_H

#include "../point/point.h"

/* Line type */
typedef struct {
    char *name;
    Point *p1;
    Point *p2;
} Line;

#endif