#ifndef TEXT_H
#define TEXT_H

#include <string.h>
#include "../point/point.h"

typedef struct {
    char* text;
    Point* position;
    int size;
} Text;

Text* create_text(char* text, Point* position, int size);
void free_text(Text* text);
Text* copy_text(Text* text);

#endif // TEXT_H