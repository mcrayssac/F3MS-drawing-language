// File: figure.c
// Description: Figure implementation
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#include "figure.h"

/* Figure linked list */
LinkedList figure_list = NULL;

/* Compare function for figures */
int compareFigureByName(const void *a, const void *b) {
    const Figure *figureA = (const Figure *)a;
    const char *nameB = (const char *)b;
    return strcmp(figureA->name, nameB);
}

/* Add a new figure if not already present, else update it */
void add_figure(char *name, Figure *figure) {
    Figure *existing_figure = find_figure(name);
    if (existing_figure != NULL) {
        switch (figure->type) {
            case FIGURE_POINT:
                existing_figure->data.point->x = figure->data.point->x;
                existing_figure->data.point->y = figure->data.point->y;
                break;

            case FIGURE_LINE:
                existing_figure->data.line->p1->x = figure->data.line->p1->x;
                existing_figure->data.line->p1->y = figure->data.line->p1->y;
                existing_figure->data.line->p2->x = figure->data.line->p2->x;
                existing_figure->data.line->p2->y = figure->data.line->p2->y;
                break;

            case FIGURE_RECTANGLE:
                existing_figure->data.rectangle->p->x = figure->data.rectangle->p->x;
                existing_figure->data.rectangle->p->y = figure->data.rectangle->p->y;
                existing_figure->data.rectangle->width = figure->data.rectangle->width;
                existing_figure->data.rectangle->height = figure->data.rectangle->height;
                break;

            case FIGURE_SQUARE:
                existing_figure->data.square->p->x = figure->data.square->p->x;
                existing_figure->data.square->p->y = figure->data.square->p->y;
                existing_figure->data.square->size = figure->data.square->size;
                break;

            case FIGURE_CIRCLE:
                existing_figure->data.circle->p->x = figure->data.circle->p->x;
                existing_figure->data.circle->p->y = figure->data.circle->p->y;
                existing_figure->data.circle->radius = figure->data.circle->radius;
                break;

            default:
                fprintf(stderr, "Unknown figure type\n");
                return;
        }
        printf("Figure %s updated\n", name);
        return;
    }
    figure->name = strdup(name);
    if (!figure->name) {
        fprintf(stderr, "Memory allocation failed for figure name.\n");
        exit(EXIT_FAILURE);
    }
    figure_list = addInBack(figure_list, figure);
    printf("Figure %s added\n", name);
}

/* Find a figure by name */
Figure *find_figure(char *name) {
    return find(figure_list, name, compareFigureByName);
}
