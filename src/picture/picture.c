#include <stdlib.h>
#include <string.h>
#include "picture.h"

Picture *create_picture(char *path, int x, int y, float scale) {
    Picture *pic = malloc(sizeof(Picture));
    if (!pic) return NULL;

    pic->path = strdup(path);
    pic->x = x;
    pic->y = y;
    pic->scale = scale;

    return pic;
}

void free_picture(Picture *pic) {
    if (pic) {
        free(pic->path);
        free(pic);
    }
}

Picture *copy_picture(Picture *pic) {
    if (!pic) return NULL;
    return create_picture(pic->path, pic->x, pic->y, pic->scale);
}