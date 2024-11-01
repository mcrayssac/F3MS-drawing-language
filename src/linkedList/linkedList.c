// File: linkedList.c
// Description: LinkedList implementation
// Author: CRAYSSAC Maxime
// Date: 2024-11-01

#include "linkedList.h"

/**
 * Adds a new node with the given value at the front of the list.
 *
 * @param list The head of the list.
 * @param valeur Pointer to the data to store in the new node.
 * @return The new head of the list.
 */
LinkedList addInFront(LinkedList list, void *valeur) {
    LinkedList new_node = malloc(sizeof(struct LinkedList));
    if (new_node == NULL) {
        fprintf(stderr, "Error allocating memory in addInFront.\n");
        exit(EXIT_FAILURE);
    }
    new_node->valeur = valeur;
    new_node->suivant = list;
    return new_node;
}

/**
 * Adds a new node with the given value at the back of the list.
 *
 * @param list The head of the list.
 * @param valeur Pointer to the data to store in the new node.
 * @return The head of the list.
 */
LinkedList addInBack(LinkedList list, void *valeur) {
    LinkedList new_node = malloc(sizeof(struct LinkedList));
    if (new_node == NULL) {
        fprintf(stderr, "Error allocating memory in addInBack.\n");
        exit(EXIT_FAILURE);
    }
    new_node->valeur = valeur;
    new_node->suivant = NULL;

    if (list == NULL) {
        // The list is empty; the new node becomes the first node.
        return new_node;
    } else {
        // Traverse to the end of the list and append the new node.
        LinkedList current = list;
        while (current->suivant != NULL) {
            current = current->suivant;
        }
        current->suivant = new_node;
        return list;
    }
}

/**
 * Deletes the first node in the list that matches the given value,
 * using the provided compare function.
 *
 * @param list The head of the list.
 * @param valeur Pointer to the data to match for deletion.
 * @param cmp Function pointer for comparing data.
 * @return The head of the list after deletion.
 */
LinkedList deleteValue(LinkedList list, void *valeur, CompareFunc cmp) {
    LinkedList current = list;
    LinkedList prev = NULL;

    while (current != NULL) {
        if (cmp(current->valeur, valeur) == 0) {
            // Node to delete found.
            if (prev == NULL) {
                // Deleting the first node.
                LinkedList temp = current->suivant;
                free(current);
                return temp;
            } else {
                // Deleting a middle or last node.
                prev->suivant = current->suivant;
                free(current);
                return list;
            }
        }
        prev = current;
        current = current->suivant;
    }
    // Value not found; list remains unchanged.
    return list;
}

/**
 * Finds the data in the list that matches the given value,
 * using the provided compare function.
 *
 * @param list The head of the list.
 * @param valeur Pointer to the data to search for.
 * @param cmp Function pointer for comparing data.
 * @return Pointer to the matching data if found; NULL otherwise.
 */
void* find(LinkedList list, void *valeur, CompareFunc cmp) {
    LinkedList current = list;
    while (current != NULL) {
        if (cmp(current->valeur, valeur) == 0) {
            return current->valeur; // Data found.
        }
        current = current->suivant;
    }
    return NULL; // Data not found.
}

/**
 * Checks if the list contains a node with the given value,
 * using the provided compare function.
 *
 * @param list The head of the list.
 * @param valeur Pointer to the data to search for.
 * @param cmp Function pointer for comparing data.
 * @return 1 if the value is found; 0 otherwise.
 */
int contains(LinkedList list, void *valeur, CompareFunc cmp) {
    LinkedList current = list;
    while (current != NULL) {
        if (cmp(current->valeur, valeur) == 0) {
            return 1; // Value found.
        }
        current = current->suivant;
    }
    return 0; // Value not found.
}

/**
 * Displays the list using the provided print function.
 *
 * @param list The head of the list.
 * @param print Function pointer for printing data.
 */
void affiche(LinkedList list, PrintFunc print) {
    LinkedList current = list;
    while (current != NULL) {
        print(current->valeur);
        current = current->suivant;
    }
}
