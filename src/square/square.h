// File: square.h
// Description: Square header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef SQUARE_H
#define SQUARE_H

#include "../point/point.h"

/* Square type */
typedef struct {
    Point *p;
    int size;
} Square;

#endif