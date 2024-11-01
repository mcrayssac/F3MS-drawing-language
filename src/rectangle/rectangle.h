// File: rectangle.h
// Description: Rectangle header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef RECTANGLE_H
#define RECTANGLE_H

#include "../point/point.h"

/* Rectangle type */
typedef struct {
    Point *p; 
    int width;
    int height;
} Rectangle;

#endif