#include <stdlib.h>
#include "regular_polygon.h"

RegularPolygon* create_regular_polygon(Point *center, int sides, float radius) {
    RegularPolygon *rp = malloc(sizeof(RegularPolygon));
    if (!rp) return NULL;
    rp->center = center;
    rp->sides = sides;
    rp->radius = radius;
    return rp;
}

RegularPolygon* copy_regular_polygon(RegularPolygon *orig) {
    if (!orig) return NULL;
    RegularPolygon *rp = malloc(sizeof(RegularPolygon));
    if (!rp) return NULL;
    // copier le center de orig dans rp
    rp->center = malloc(sizeof(Point));
    rp->center->x = orig->center->x;
    rp->center->y = orig->center->y;
    rp->center->name = NULL;
    rp->sides = orig->sides;
    rp->radius = orig->radius;
    return rp;
}

void free_regular_polygon(RegularPolygon *rp) {
    if (!rp) return;
    if (rp->center) {
        free(rp->center->name);
        free(rp->center);
    }
    free(rp);
}
