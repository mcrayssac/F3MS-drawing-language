// File: ellipse.h
#ifndef ELLIPSE_H
#define ELLIPSE_H

#include "../point/point.h"

typedef struct {
    Point *p;
    int width;
    int height;
} Ellipse;

#endif