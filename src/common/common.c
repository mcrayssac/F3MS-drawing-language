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

/* Error handling function */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}