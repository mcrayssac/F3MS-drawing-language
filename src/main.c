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
    fprintf(output, "import math\n"); // Import math module
    fprintf(output, "pygame.init()\n");
    fprintf(output, "screen = pygame.display.set_mode((1000, 800))\n");
    fprintf(output, "pygame.display.set_caption('Dynamic Drawing')\n");
    fprintf(output, "clock = pygame.time.Clock()\n");
    fprintf(output, "color = (0, 0, 0)\n"); // Default color
    fprintf(output, "line_width = 1\n"); // Default line width
    fprintf(output, "commands = []\n"); // List to store commands
    fprintf(output, "figures = {}\n"); // Dictionary to store figures
    fprintf(output, "\n");

    // Parse the input file
    yyparse();

    // Generate the Python code after parsing
    generate_python_code();

    // Generate the main loop for dynamic rendering
    fprintf(output, "\n");
    fprintf(output, "running = True\n");
    fprintf(output, "index = 0\n");
    fprintf(output, "screen.fill((255, 255, 255))\n");  // Fill background with white
    fprintf(output, "while running:\n");
    fprintf(output, "    for event in pygame.event.get():\n");
    fprintf(output, "        if event.type == pygame.QUIT:\n");
    fprintf(output, "            running = False\n");
    fprintf(output, "\n");
    fprintf(output, "    if index < len(commands):\n");
    fprintf(output, "        cmd = commands[index]\n");

    // Clear the screen before processing each command
    fprintf(output, "        screen.fill((255, 255, 255))\n");  // Clear the screen

    fprintf(output, "        if cmd[0] == 'SET_COLOR':\n");
    fprintf(output, "            color = cmd[1]\n");
    fprintf(output, "        elif cmd[0] == 'SET_LINE_WIDTH':\n");
    fprintf(output, "            line_width = cmd[1]\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_POINT':\n");
    fprintf(output, "            name = cmd[2]\n");  // Figure name
    fprintf(output, "            figures[name] = {'type': 'point', 'position': cmd[1], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.circle(screen, color, cmd[1], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_LINE':\n");
    fprintf(output, "            name = cmd[3]\n");  // Corrected index from cmd[4] to cmd[3]
    fprintf(output, "            figures[name] = {'type': 'line', 'start': cmd[1], 'end': cmd[2], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.line(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_RECTANGLE':\n");
    fprintf(output, "            name = cmd[4]\n");  // Corrected index from cmd[5] to cmd[4]
    fprintf(output, "            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[3])\n");
    fprintf(output, "            figures[name] = {'type': 'rectangle', 'rect': rect, 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.rect(screen, color, rect, line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_SQUARE':\n");
    fprintf(output, "            name = cmd[3]\n");  // Index remains the same
    fprintf(output, "            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[2])\n");
    fprintf(output, "            figures[name] = {'type': 'square', 'rect': rect, 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.rect(screen, color, rect, line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_CIRCLE':\n");
    fprintf(output, "            name = cmd[3]\n");  // Index remains the same
    fprintf(output, "            figures[name] = {'type': 'circle', 'center': cmd[1], 'radius': cmd[2], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.circle(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'ROTATE':\n");
    fprintf(output, "            name = cmd[1]\n");
    fprintf(output, "            angle = cmd[2]\n");
    fprintf(output, "            if name in figures:\n");
    fprintf(output, "                figure = figures[name]\n");
    fprintf(output, "                if figure['type'] == 'line':\n");
    fprintf(output, "                    # Rotate line around its midpoint\n");
    fprintf(output, "                    sx, sy = figure['start']\n");
    fprintf(output, "                    ex, ey = figure['end']\n");
    fprintf(output, "                    mx = (sx + ex) / 2\n");
    fprintf(output, "                    my = (sy + ey) / 2\n");
    fprintf(output, "                    def rotate_point(x, y):\n");
    fprintf(output, "                        x -= mx\n");
    fprintf(output, "                        y -= my\n");
    fprintf(output, "                        radians = math.radians(angle)\n");
    fprintf(output, "                        x_new = x * math.cos(radians) - y * math.sin(radians) + mx\n");
    fprintf(output, "                        y_new = x * math.sin(radians) + y * math.cos(radians) + my\n");
    fprintf(output, "                        return x_new, y_new\n");
    fprintf(output, "                    figure['start'] = rotate_point(sx, sy)\n");
    fprintf(output, "                    figure['end'] = rotate_point(ex, ey)\n");
    fprintf(output, "                elif figure['type'] == 'rectangle' or figure['type'] == 'square':\n");
    fprintf(output, "                    # Rotate rectangle or square\n");
    fprintf(output, "                    rect = figure['rect']\n");
    fprintf(output, "                    image = pygame.Surface((rect.width, rect.height), pygame.SRCALPHA)\n");
    fprintf(output, "                    pygame.draw.rect(image, color, pygame.Rect(0, 0, rect.width, rect.height), line_width)\n");
    fprintf(output, "                    rotated_image = pygame.transform.rotate(image, angle)\n");
    fprintf(output, "                    new_rect = rotated_image.get_rect(center=rect.center)\n");
    fprintf(output, "                    figure['image'] = rotated_image\n");
    fprintf(output, "                    figure['rect'] = new_rect\n");
    fprintf(output, "                elif figure['type'] == 'circle':\n");
    fprintf(output, "                    # Rotating a circle has no visual effect\n");
    fprintf(output, "                    pass\n");
    fprintf(output, "            else:\n");
    fprintf(output, "                print('Figure not found:', name)\n");

    // After processing the command, redraw all figures
    fprintf(output, "        # Redraw all figures\n");
    fprintf(output, "        for fig in figures.values():\n");
    fprintf(output, "            fig_color = fig.get('color', (0, 0, 0))\n");
    fprintf(output, "            fig_line_width = fig.get('line_width', 1)\n");
    fprintf(output, "            if fig['type'] == 'point':\n");
    fprintf(output, "                pygame.draw.circle(screen, fig_color, fig['position'], fig_line_width)\n");
    fprintf(output, "            elif fig['type'] == 'line':\n");
    fprintf(output, "                pygame.draw.line(screen, fig_color, fig['start'], fig['end'], fig_line_width)\n");
    fprintf(output, "            elif fig['type'] == 'rectangle' or fig['type'] == 'square':\n");
    fprintf(output, "                if 'image' in fig:\n");
    fprintf(output, "                    screen.blit(fig['image'], fig['rect'])\n");
    fprintf(output, "                else:\n");
    fprintf(output, "                    pygame.draw.rect(screen, fig_color, fig['rect'], fig_line_width)\n");
    fprintf(output, "            elif fig['type'] == 'circle':\n");
    fprintf(output, "                pygame.draw.circle(screen, fig_color, fig['center'], fig['radius'], fig_line_width)\n");

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
