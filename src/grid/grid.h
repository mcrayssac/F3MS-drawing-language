#ifndef GRID_H
#define GRID_H

// Structure pour représenter une grille
typedef struct {
    int spacing;  // Espacement entre les lignes de la grille
} Grid;

// Fonctions pour manipuler les grilles
Grid *create_grid(int spacing);
void free_grid(Grid *grid);
Grid *copy_grid(Grid *grid);

#endif // GRID_H