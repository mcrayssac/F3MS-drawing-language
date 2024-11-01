// File: linkedList.h
// Description: LinkedList header
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#ifndef H_LINKEDLIST_H
#define H_LINKEDLIST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct LinkedList {
    void *valeur;
    struct LinkedList *suivant;
} *LinkedList;

typedef int (*CompareFunc)(const void *a, const void *b);
typedef void (*PrintFunc)(const void *data);

LinkedList addInFront(LinkedList liste, void *valeur);
LinkedList addInBack(LinkedList liste, void *valeur);
LinkedList deleteValue(LinkedList liste, void *valeur, CompareFunc cmp);
void* find(LinkedList liste, void *valeur, CompareFunc cmp);
int contains(LinkedList liste, void *valeur, CompareFunc cmp);
void affiche(LinkedList liste, PrintFunc print);   

#endif
