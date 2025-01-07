#include <stdlib.h>
#include <string.h>  // si besoin de strdup
#include <stdio.h>
#include "polygon.h"

/* 
   Fonction pour créer un Polygon à partir d’une liste chaînée de points.
*/
Polygon* create_polygon(PointList *plist) {
    Polygon *poly = malloc(sizeof(Polygon));
    if (!poly) return NULL;
    poly->points = plist;
    return poly;
}

/*
   Pour copier un Polygon, il faut copier la liste de points.
*/
static PointList* copy_point_list(PointList *original) {
    if (!original) return NULL;
    PointList *node = malloc(sizeof(PointList));
    if (!node) return NULL;

    // copie du point
    node->point = malloc(sizeof(Point));
    if (!node->point) {
        free(node);
        return NULL;
    }
    node->point->x = original->point->x;
    node->point->y = original->point->y;

    // on copie récursivement le reste
    node->next = copy_point_list(original->next);
    return node;
}

Polygon* copy_polygon(Polygon *orig) {
    if (!orig) return NULL;
    Polygon *poly = malloc(sizeof(Polygon));
    if (!poly) return NULL;
    poly->points = copy_point_list(orig->points);
    return poly;
}

/*
   Libérer un Polygon (=on libère la liste chaînée)
*/
static void free_point_list(PointList *plist) {
    if (!plist) return;
    free_point_list(plist->next);
    if (plist->point) {
        free(plist->point->name);  // si le name est alloué
        free(plist->point);
    }
    free(plist);
}

void free_polygon(Polygon *poly) {
    if (!poly) return;
    free_point_list(poly->points);
    free(poly);
}
