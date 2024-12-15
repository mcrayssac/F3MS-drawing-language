// File: common.c
// Description: Common implementation
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#include "../external/external.h"
#include "common.h"
#include "../command/command.h"
#include "../point/point.h"

/* Output file */
FILE *output;

/* Error handling functions */
void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

void error_at_line(int line, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "\033[1;31mError at line %d:\033[0m ", line);
    vfprintf(stderr, fmt, args);
    fprintf(stderr, "\n");
    va_end(args);
}