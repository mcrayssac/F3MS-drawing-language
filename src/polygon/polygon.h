#ifndef POLYGON_H
#define POLYGON_H

#include "../point/point.h"

/*
  On reprend la notion de liste chaînée de points.
*/
typedef struct PointList {
    Point *point;
    struct PointList *next;
} PointList;

/*
  Le Polygon contient simplement un pointeur vers cette liste de points.
*/
typedef struct {
    PointList *points;
} Polygon;

/*
  Fonctions de base (création, copie, libération).
*/
Polygon* create_polygon(PointList *plist);
Polygon* copy_polygon(Polygon *orig);
void free_polygon(Polygon *poly);

#endif
