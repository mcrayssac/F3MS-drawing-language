#ifndef REGULAR_POLYGON_H
#define REGULAR_POLYGON_H

#include "../point/point.h"

/*
  On stocke le centre, le nombre de côtés et le rayon
*/
typedef struct {
    Point *center;
    int sides;
    float radius;
} RegularPolygon;

RegularPolygon* create_regular_polygon(Point *center, int sides, float radius);
RegularPolygon* copy_regular_polygon(RegularPolygon *orig);
void free_regular_polygon(RegularPolygon *rp);

#endif
