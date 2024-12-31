#include <stdlib.h>
#include <string.h>
#include "text.h"

Text* create_text(char* text, Point* position, int size) {
    Text* text_obj = malloc(sizeof(Text));
    if (!text_obj) return NULL;

    text_obj->text = strdup(text);
    text_obj->position = malloc(sizeof(Point));
    if (!text_obj->position) {
        free(text_obj->text);
        free(text_obj);
        return NULL;
    }
    text_obj->position->x = position->x;
    text_obj->position->y = position->y;
    text_obj->size = size;

    return text_obj;
}

void free_text(Text* text) {
    if (text) {
        free(text->text);
        free(text->position);
        free(text);
    }
}

Text* copy_text(Text* text) {
    if (!text) return NULL;
    return create_text(text->text, text->position, text->size);
}