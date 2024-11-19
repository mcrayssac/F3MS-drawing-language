#ifndef COMMON_H
#define COMMON_H

typedef struct {
    char *name;
    int x;
    int y;
} Point;

typedef struct PointList {
    Point *point;
    struct PointList *next;
} PointList;

#endif
