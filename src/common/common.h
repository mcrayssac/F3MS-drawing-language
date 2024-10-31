#ifndef COMMON_H
#define COMMON_H

/* Point type */
typedef struct {
    char *name;
    int x;
    int y;
} Point;

/* Command types */
 typedef enum {
    CMD_SET_COLOR,
    CMD_SET_LINE_WIDTH,
    CMD_DRAW_LINE,
    CMD_DRAW_RECTANGLE,
    CMD_DRAW_SQUARE,
    CMD_DRAW_CIRCLE
} CommandType;

typedef struct {
    CommandType type;
    union {
        struct { int r, g, b; } color;
        int line_width;
        struct { Point *p1, *p2; } line;
        struct { Point *p; int width, height; } rectangle;
        struct { Point *p; int size; } square;
        struct { Point *p; int radius; } circle;
    } data;
} Command;

#endif
