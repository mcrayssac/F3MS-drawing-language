// File: point.c
// Description: Point implementation
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#include <stdlib.h>
#include "point.h"

/* Symbol table for points (a table of names and coordinates) */
Point symbol_table[100];
int symbol_count = 0;

/* Add a new point to the symbol table */
void add_point(char *name, int x, int y) {
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].x = x;
    symbol_table[symbol_count].y = y;
    symbol_count++;
}

/* Update the coordinates of an existing point */
void update_point(char *name, int x, int y) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].x = x;
            symbol_table[i].y = y;
            return;
        }
    }
    // If the point doesn't exist, add it
    add_point(name, x, y);
}

/* Find a point in the symbol table */
Point *find_point(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return &symbol_table[i];
        }
    }
    return NULL;
}