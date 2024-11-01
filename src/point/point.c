// File: point.c
// Description: Point implementation
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#include <stdlib.h>
#include "point.h"
#include "../linkedList/linkedList.h"

/* Symbol linked list */
LinkedList symbol_linked_list = NULL;

/* Compare function for points */
int comparePoint(const void *a, const void *b) {
    const Point *pointA = a;
    const Point *pointB = b;
    return strcmp(pointA->name, pointB->name);
}

/* New compare function that compares Point* with char* */
int comparePointByName(const void *a, const void *b) {
    const Point *pointA = (const Point *)a;
    const char *nameB = (const char *)b;
    return strcmp(pointA->name, nameB);
}

/* Add a new point to the symbol table */
void add_point(char *name, int x, int y) {
    Point *point = malloc(sizeof(Point));
    if (!point) {
        fprintf(stderr, "Memory allocation failed in add_point.\n");
        exit(EXIT_FAILURE);
    }
    point->name = strdup(name);
    if (!point->name) {
        fprintf(stderr, "Memory allocation failed for point name.\n");
        exit(EXIT_FAILURE);
    }
    point->x = x;
    point->y = y;
    symbol_linked_list = addInBack(symbol_linked_list, point);
    printf("Point %s added at (%d, %d)\n", name, x, y);
}

/* Update the coordinates of an existing point */
void update_point(char *name, int x, int y) {
    Point *point = find_point(name);
    if (point != NULL) {
        point->x = x;
        point->y = y;
        printf("Point %s updated to (%d, %d)\n", name, x, y);
        return;
    }
    printf("Point %s not found\n", name);
    // If the point doesn't exist, add it
    add_point(name, x, y);
}

/* Find a point in the symbol table using the new compare function */
Point *find_point(char *name) {
    return find(symbol_linked_list, name, comparePointByName);
}