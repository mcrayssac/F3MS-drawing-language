// File: common.h
// Description: Common header
// Author: CRAYSSAC Maxime
// Date: 2024-10-31

#ifndef COMMON_H
#define COMMON_H

#include "../figure/figure.h"
#include "../command/command.h"
#include "../temp/parser.tab.h"

/* Function prototypes for error handling */
void yyerror(const char *msg);  // Basic error handler for Bison
void error_at_line(int line, const char *fmt, ...);  // Line-aware error handler with formatting

int yylex(void);

/* External variables */
extern FILE *output;

#endif
