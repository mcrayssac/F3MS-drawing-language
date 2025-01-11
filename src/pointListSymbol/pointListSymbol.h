#ifndef POINT_LIST_SYMBOL_H
#define POINT_LIST_SYMBOL_H

#include "../polygon/polygon.h" // pour PointList

void store_point_list(const char *name, PointList *lst);
PointList* find_point_list(const char *name);

#endif
