#include <stdlib.h>
#include "arc.h"

Arc *create_arc(Point *p1, Point *p2, double angle, int thickness) {
    Arc *arc = malloc(sizeof(Arc));
    if (!arc) return NULL;

    arc->p1 = copy_point(p1);
    arc->p2 = copy_point(p2);
    arc->angle = angle;
    arc->thickness = thickness;

    return arc;
}

void free_arc(Arc *arc) {
    if (arc) {
        free_point(arc->p1);
        free_point(arc->p2);
        free(arc);
    }
}

Arc *copy_arc(Arc *arc) {
    if (!arc) return NULL;
    return create_arc(arc->p1, arc->p2, arc->angle, arc->thickness);
}