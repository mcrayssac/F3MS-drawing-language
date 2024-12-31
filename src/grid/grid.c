#include <stdlib.h>
#include "grid.h"

Grid *create_grid(int spacing) {
    Grid *grid = malloc(sizeof(Grid));
    if (!grid) return NULL;
    grid->spacing = spacing;
    return grid;
}

void free_grid(Grid *grid) {
    if (grid) {
        free(grid);
    }
}

Grid *copy_grid(Grid *grid) {
    if (!grid) return NULL;
    return create_grid(grid->spacing);
}