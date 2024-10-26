%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../common/common.h"

/* Include parser definitions */
#include "parser.tab.h"

%}

%option noyywrap
%option nounput
%option noinput

DIGIT       [0-9]
NUMBER      {DIGIT}+
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r\n]+
COMMENT     "#".*

%%

"set_color"         { return SET_COLOR; }
"point"             { return POINT; }
"line"              { return LINE; }

{IDENTIFIER}        { yylval.strval = strdup(yytext); return IDENTIFIER; }
{NUMBER}            { yylval.intval = atoi(yytext); return NUMBER; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
","                 { return COMMA; }
";"                 { return SEMICOLON; }
"="                 { return EQUALS; }
{WHITESPACE}        { /* Ignore whitespace */ }
{COMMENT}           { /* Ignore comments */ }
.                   { printf("Unknown character: %s\n", yytext); exit(1); }

%%
