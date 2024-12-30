#ifndef PICTURE_H
#define PICTURE_H

typedef struct {
    char *path;     // Chemin de l'image
    int x;          // Position X
    int y;          // Position Y
    float scale;    // Facteur d'échelle
} Picture;

Picture *create_picture(char *path, int x, int y, float scale);
void free_picture(Picture *pic);
Picture *copy_picture(Picture *pic);

#endif // PICTURE_H