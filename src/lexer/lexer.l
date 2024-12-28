/*  lexer.l
    This file contains the lexer for the parser.
    It defines the tokens that the parser will use to parse the input file.
    The lexer is implemented using flex.
*/

/*  Section: Header Files
    Include necessary header files.
*/
%{

#include "../external/external.h"
#include "../common/common.h"

extern int yylineno;

// This macro ensures that the lexer updates yylloc with the current line number, allowing the parser to have accurate location information.
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;

#include "../temp/parser.tab.h"

%}

/*  Section: Options
    Define options for the lexer.
*/
%option noyywrap
%option nounput
%option noinput
%option yylineno  

/*  Section: Patterns Definitions
    Define patterns for the lexer.
*/
DIGIT       [0-9]
NUMBER      {DIGIT}+
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
WHITESPACE  [ \t\r\n]+
COMMENT     "#".*
INVALID_ID  {DIGIT}+{LETTER}+({LETTER}|{DIGIT})*
INVALID_NUM {DIGIT}*\.{DIGIT}+

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
"draw"              { return DRAW; }
"rotate"            { return ROTATE; }
"translate"         { return TRANSLATE; }
"ellipse"           { return ELLIPSE; }
"grid"              { return GRID;}
"arc"               { return ARC;}

{IDENTIFIER}        { yylval.strval = strdup(yytext); return IDENTIFIER; }
{NUMBER}            { yylval.intval = atoi(yytext); return NUMBER; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
","                 { return COMMA; }
";"                 { return SEMICOLON; }
"="                 { return EQUALS; }
{WHITESPACE}        { /* Ignore whitespace */ }
{COMMENT}           { /* Ignore comments */ }

{INVALID_ID}        { 
    error_at_line(yylineno, 
        "Invalid identifier '%s'\n"
        "Identifiers must:\n"
        "- Start with a letter\n"
        "- Contain only letters and numbers\n\n"
        "Examples:\n"
        "✅ myPoint1\n"
        "✅ circleA\n"
        "✅ line123\n\n"
        "Common mistakes:\n"
        "❌ 1point    // Starts with number\n"
        "❌ my-point  // Contains hyphen\n"
        "❌ point_1   // Contains underscore", 
        yytext);
    return -1;
}

{INVALID_NUM}       {
    error_at_line(yylineno,
        "Invalid number '%s'\n"
        "Numbers must be integers\n\n"
        "Examples:\n"
        "✅ 42\n"
        "✅ 100\n"
        "✅ 255\n\n"
        "Common mistakes:\n"
        "❌ 3.14    // Decimals not allowed\n"
        "❌ 1,000   // Commas not allowed\n"
        "❌ -42     // Negative numbers handled separately",
        yytext);
    return -1;
}

.                   {
    error_at_line(yylineno,
        "Unexpected character '%s'\n"
        "Valid symbols are:\n"
        "( )    Parentheses\n"
        ",      Comma\n"
        ";      Semicolon\n"
        "=      Assignment\n\n"
        "Common mistakes:\n"
        "❌ Using {} instead of ()\n"
        "❌ Using : instead of =\n"
        "❌ Missing semicolon\n"
        "❌ Using invalid symbols like @ # $ %",
        yytext);
    return -1;
}

%%
