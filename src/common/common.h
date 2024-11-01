// File: common.h
// Description: Common header
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#ifndef COMMON_H
#define COMMON_H

#include "../figure/figure.h"
#include "../command/command.h"

/* Function prototype for error handling */
void yyerror(const char *s); 
int yylex(void);

/* External variables (defined in common.c) */
extern FILE *output;

#endif
