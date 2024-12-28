#ifndef ARC_H
#define ARC_H

#include "../point/point.h"

typedef struct {
    Point *p1;      // Premier point
    Point *p2;      // Deuxième point
    double angle;   // Angle en degrés
    int thickness;  // Épaisseur du trait
} Arc;

Arc *create_arc(Point *p1, Point *p2, double angle, int thickness);
void free_arc(Arc *arc);
Arc *copy_arc(Arc *arc);

#endif // ARC_H