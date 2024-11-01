// File: circle.h
// Description: Circle header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef CIRCLE_H
#define CIRCLE_H

#include "../point/point.h"

/* Circle type */
typedef struct {
    Point *p;
    int radius;
} Circle;

#endif
