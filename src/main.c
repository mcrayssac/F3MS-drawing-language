#include <stdio.h>
#include <stdlib.h>
#include "./common/common.h"

extern FILE *yyin;
extern FILE *output;
int yyparse(void);

/* Declare generate_python_code function */
void generate_python_code();

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <input.draw> <output.py> <frame>\n", argv[0]);
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

    // Write the Python script header
    fprintf(output, "import pygame\n");
    fprintf(output, "pygame.init()\n");
    fprintf(output, "screen = pygame.display.set_mode((1000, 800))\n");
    fprintf(output, "pygame.display.set_caption('Dynamic Drawing')\n");
    fprintf(output, "clock = pygame.time.Clock()\n");
    fprintf(output, "color = (0, 0, 0)\n"); // Default color
    fprintf(output, "line_width = 1\n"); // Default line width
    fprintf(output, "commands = []\n"); // List to store commands
    fprintf(output, "\n");

    // Parse the input file
    yyparse();

    // Generate the Python code after parsing
    generate_python_code();

    // Generate the main loop for dynamic rendering
    fprintf(output, "\n");
    fprintf(output, "running = True\n");
    fprintf(output, "index = 0\n");
    fprintf(output, "screen.fill((255, 255, 255))\n"); // Fill background with white
    fprintf(output, "while running:\n");
    fprintf(output, "    for event in pygame.event.get():\n");
    fprintf(output, "        if event.type == pygame.QUIT:\n");
    fprintf(output, "            running = False\n");
    fprintf(output, "\n");
    fprintf(output, "    if index < len(commands):\n");
    fprintf(output, "        cmd = commands[index]\n");
    fprintf(output, "        if cmd[0] == 'SET_COLOR':\n");
    fprintf(output, "            color = cmd[1]\n");
    fprintf(output, "        elif cmd[0] == 'SET_LINE_WIDTH':\n");
    fprintf(output, "            line_width = cmd[1]\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_LINE':\n");
    fprintf(output, "            pygame.draw.line(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_RECTANGLE':\n");
    fprintf(output, "            pygame.draw.rect(screen, color, pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[3]), line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_SQUARE':\n");
    fprintf(output, "            pygame.draw.rect(screen, color, pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[2]), line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_CIRCLE':\n");
    fprintf(output, "            pygame.draw.circle(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        index += 1\n");
    fprintf(output, "\n");
    fprintf(output, "    pygame.display.flip()\n");
    fprintf(output, "    clock.tick(%d)\n", atoi(argv[3]));
    fprintf(output, "\n");
    fprintf(output, "pygame.quit()\n");

    fclose(yyin);
    fclose(output);

    return 0;
}
