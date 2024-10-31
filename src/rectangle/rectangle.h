#ifndef RECTANGLE_H
#define RECTANGLE_H

#include "../point/point.h"

/* Point type */
typedef struct {
    Point *p; 
    int width;
    int height;
} Rectangle;

#endif