/*  lexer.l
    This file contains the lexer for the parser.
    It defines the tokens that the parser will use to parse the input file.
    The lexer is implemented using flex.
*/

/*  Section: Header Files
    Include necessary header files.
*/
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../common/common.h"

#include "parser.tab.h"

%}

/*  Section: Options
    Define options for the lexer.
*/
%option noyywrap
%option nounput
%option noinput

/*  Section: Patterns Definitions
    Define patterns for the lexer.
*/
DIGIT       [0-9]
NUMBER      {DIGIT}+
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r\n]+
COMMENT     "#".*

/*  Section: Token Rules
    Define rules for the lexer.
*/
%%

"set_color"         { return SET_COLOR; }
"set_line_width"    { return SET_LINE_WIDTH; }
"point"             { return POINT; }
"line"              { return LINE; }
"rectangle"         { return RECTANGLE; }
"square"            { return SQUARE;}
"circle"            { return CIRCLE; }
"ellipse"           { return ELLIPSE; }
"grid"              { return GRID; }

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
