#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pointListSymbol.h"

typedef struct {
    char *name;
    PointList *plist;
} PointListSymbol;

static PointListSymbol tableList[100];
static int tableListCount = 0;

void store_point_list(const char *name, PointList *lst)
{
    // Chercher si ce name existe déjà
    for (int i = 0; i < tableListCount; i++) {
        if (strcmp(tableList[i].name, name) == 0) {
            // Met à jour
            tableList[i].plist = lst;
            printf("Point list %s updated.\n", name);
            return;
        }
    }
    // Sinon, ajout
    tableList[tableListCount].name = strdup(name);
    tableList[tableListCount].plist = lst;
    tableListCount++;
    printf("Point list %s added.\n", name);
}

PointList* find_point_list(const char *name)
{
    for (int i = 0; i < tableListCount; i++) {
        if (strcmp(tableList[i].name, name) == 0) {
            return tableList[i].plist;
        }
    }
    return NULL;
}
