#include <stdio.h>
#include <stdlib.h>
#include "./common/common.h"

extern FILE *yyin;
extern FILE *output;
int yyparse(void);

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <input.draw> <output.py>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Cannot open input file");
        return 1;
    }

    output = fopen(argv[2], "w");
    if (!output) {
        perror("Cannot open output file");
        return 1;
    }

    // Write the header of the Python script
    fprintf(output, "import pygame\n");
    fprintf(output, "pygame.init()\n");
    fprintf(output, "screen = pygame.display.set_mode((1000, 800))\n");
    fprintf(output, "pygame.display.set_caption('Draw Line')\n");
    fprintf(output, "screen.fill((255, 255, 255))\n"); // Fill background with white
    fprintf(output, "color = (0, 0, 0)\n"); // Default color
    fprintf(output, "\n");

    yyparse();

    // Write the footer of the Python script
    fprintf(output, "\n");
    fprintf(output, "pygame.display.flip()\n");
    fprintf(output, "running = True\n");
    fprintf(output, "while running:\n");
    fprintf(output, "    for event in pygame.event.get():\n");
    fprintf(output, "        if event.type == pygame.QUIT:\n");
    fprintf(output, "            running = False\n");
    fprintf(output, "pygame.quit()\n");

    fclose(yyin);
    fclose(output);

    return 0;
}
