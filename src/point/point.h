// File: point.h
// Description: Point header
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#ifndef POINT_H
#define POINT_H

/* Point type */
typedef struct {
    char *name;
    int x;
    int y;
} Point;

void add_point(char *name, int x, int y);
void update_point(char *name, int x, int y);
Point *find_point(char *name);

#endif
