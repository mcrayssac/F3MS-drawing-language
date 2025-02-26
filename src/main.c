#include "./external/external.h"
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
    fprintf(output, "pygame.font.init()\n");
    fprintf(output, "color = (0, 0, 0)\n"); // Default color
    fprintf(output, "line_width = 1\n"); // Default line width
    fprintf(output, "commands = []\n"); // List to store commands
    fprintf(output, "figures = {}\n"); // Dictionary to store figures
    fprintf(output, "\n");

    // Parse the input file
    if (yyparse() != 0) {
        fprintf(stderr, "Parsing failed due to errors.\n");
        fclose(yyin);
        fclose(output);
        return 1;
    }

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
    fprintf(output, "            name = cmd[2]\n");
    fprintf(output, "            figures[name] = {'type': 'point', 'position': cmd[1], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.circle(screen, color, cmd[1], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_LINE':\n");
    fprintf(output, "            name = cmd[3]\n");
    fprintf(output, "            figures[name] = {'type': 'line', 'start': cmd[1], 'end': cmd[2], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.line(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_RECTANGLE':\n");
    fprintf(output, "            name = cmd[4]\n");
    fprintf(output, "            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[3])\n");
    fprintf(output, "            figures[name] = {'type': 'rectangle', 'rect': rect, 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.rect(screen, color, rect, line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_SQUARE':\n");
    fprintf(output, "            name = cmd[3]\n");
    fprintf(output, "            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[2])\n");
    fprintf(output, "            figures[name] = {'type': 'square', 'rect': rect, 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.rect(screen, color, rect, line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_CIRCLE':\n");
    fprintf(output, "            name = cmd[3]\n");
    fprintf(output, "            figures[name] = {'type': 'circle', 'center': cmd[1], 'radius': cmd[2], 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.circle(screen, color, cmd[1], cmd[2], line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_ELLIPSE':\n");
    fprintf(output, "            name = cmd[4]\n");
    fprintf(output, "            rect = pygame.Rect(cmd[1][0] - cmd[2]//2, cmd[1][1] - cmd[3]//2, cmd[2], cmd[3])\n");
    fprintf(output, "            figures[name] = {'type': 'ellipse', 'rect': rect, 'color': color, 'line_width': line_width}\n");
    fprintf(output, "            pygame.draw.ellipse(screen, color, rect, line_width)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_GRID':\n");
    fprintf(output, "            spacing = cmd[1]\n");
    fprintf(output, "            figures['grid'] = {'type': 'grid', 'spacing': spacing}\n");
    fprintf(output, "            for x in range(0, 1000, spacing):\n");
    fprintf(output, "                pygame.draw.line(screen, (200, 200, 200), (x, 0), (x, 800), 1)\n");
    fprintf(output, "            for y in range(0, 800, spacing):\n");
    fprintf(output, "                pygame.draw.line(screen, (200, 200, 200), (0, y), (1000, y), 1)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_ARC':\n");
    fprintf(output, "            p1, p2 = cmd[1], cmd[2]\n");
    fprintf(output, "            angle_deg, thickness = cmd[3], cmd[4]\n");
    fprintf(output, "            radius = int(((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)**0.5) // 2\n");
    fprintf(output, "            rect = pygame.Rect(p1[0] - radius, p1[1] - radius, radius * 2, radius * 2)\n");
    fprintf(output, "            name = cmd[5]\n");
    fprintf(output, "            figures[name] = {'type': 'arc', 'rect': rect, 'start_angle': 0, 'end_angle': math.radians(angle_deg), 'thickness': thickness, 'color': color}\n");
    fprintf(output, "            pygame.draw.arc(screen, color, rect, 0, math.radians(angle_deg), thickness)\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_PICTURE':\n");
    fprintf(output, "            path, x, y, scale = cmd[1], cmd[2], cmd[3], cmd[4]\n");
    fprintf(output, "            try:\n");
    fprintf(output, "                image = pygame.image.load(path).convert_alpha()\n");
    fprintf(output, "                image_width, image_height = image.get_size()\n");
    fprintf(output, "                scaled_image = pygame.transform.scale(image, (int(image_width * scale), int(image_height * scale)))\n");
    fprintf(output, "                screen.blit(scaled_image, (x, y))\n");
    fprintf(output, "                figures[f'picture_{path}'] = {'type': 'picture', 'path': path, 'x': x, 'y': y, 'scale': scale}\n");
    fprintf(output, "            except pygame.error as e:\n");
    fprintf(output, "                print(f\"Error loading image: {e}\")\n");
    fprintf(output, "        elif cmd[0] == 'DRAW_TEXT':\n");
    fprintf(output, "            font = pygame.font.Font(None, cmd[4])\n");
    fprintf(output, "            text_surface = font.render(cmd[1], True, color)\n");
    fprintf(output, "            screen.blit(text_surface, (cmd[2], cmd[3]))\n");
    fprintf(output, "            figures[f\"text_{cmd[1]}\"] = {\n");
    fprintf(output, "                'type': 'text',\n");
    fprintf(output, "                'text': cmd[1],\n");
    fprintf(output, "                'x': cmd[2],\n");
    fprintf(output, "                'y': cmd[3],\n");
    fprintf(output, "                'size': cmd[4],\n");
    fprintf(output, "                'color': color\n");
    fprintf(output, "            }\n");
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
    fprintf(output, "                else:\n");
    fprintf(output, "                    print('Cannot rotate figure:', name)\n");

    fprintf(output, "        elif cmd[0] == 'DRAW_POLYGON':\n");
    fprintf(output, "            # cmd = ('DRAW_POLYGON', [(x1,y1), (x2,y2), ...], 'figureName')\n");
    fprintf(output, "            points = cmd[1]\n");
    fprintf(output, "            # Convertir les points en entiers\n");
    fprintf(output, "            int_points = [(int(x), int(y)) for (x, y) in points]\n");
    fprintf(output, "            figure_name = cmd[2]\n");
    fprintf(output, "            figures[figure_name] = {\n");
    fprintf(output, "                'type': 'polygon',\n");
    fprintf(output, "                'points': int_points,\n");
    fprintf(output, "                'color': color,\n");
    fprintf(output, "                'line_width': line_width\n");
    fprintf(output, "            }\n");
    fprintf(output, "            pygame.draw.polygon(screen, color, int_points, line_width)\n");

    fprintf(output, "        elif cmd[0] == 'DRAW_REGULAR_POLYGON':\n");
    fprintf(output, "            # cmd = ('DRAW_REGULAR_POLYGON', (cx, cy), sides, radius, 'figureName')\n");
    fprintf(output, "            center = cmd[1]\n");
    fprintf(output, "            sides = cmd[2]\n");
    fprintf(output, "            radius = cmd[3]\n");
    fprintf(output, "            figure_name = cmd[4]\n");
    fprintf(output, "            cx, cy = center\n");
    fprintf(output, "            reg_points = []\n");
    fprintf(output, "            for i in range(sides):\n");
    fprintf(output, "                angle = 2 * math.pi * i / sides\n");
    fprintf(output, "                x = cx + radius * math.cos(angle)\n");
    fprintf(output, "                y = cy + radius * math.sin(angle)\n");
    fprintf(output, "                reg_points.append((int(x), int(y)))\n"); // Conversion en int
    fprintf(output, "            figures[figure_name] = {\n");
    fprintf(output, "                'type': 'regular_polygon',\n");
    fprintf(output, "                'center': center,\n");
    fprintf(output, "                'sides': sides,\n");
    fprintf(output, "                'radius': radius,\n");
    fprintf(output, "                'points': reg_points,\n");
    fprintf(output, "                'color': color,\n");
    fprintf(output, "                'line_width': line_width\n");
    fprintf(output, "            }\n");
    fprintf(output, "            pygame.draw.polygon(screen, color, reg_points, line_width)\n");

    fprintf(output, "        elif cmd[0] == 'TRANSLATE':\n");
    fprintf(output, "            name = cmd[1]\n");
    fprintf(output, "            dx = cmd[2]\n");
    fprintf(output, "            dy = cmd[3]\n");
    fprintf(output, "            if name in figures:\n");
    fprintf(output, "                figure = figures[name]\n");
    fprintf(output, "                if figure['type'] == 'point':\n");
    fprintf(output, "                    figure['position'] = (dx, dy)\n");
    fprintf(output, "                elif figure['type'] == 'line':\n");
    fprintf(output, "                    figure['start'] = (dx, dy)\n");
    fprintf(output, "                    figure['end'] = (dx + (figure['end'][0] - figure['start'][0]), dy + (figure['end'][1] - figure['start'][1]))\n");
    fprintf(output, "                elif figure['type'] == 'rectangle' or figure['type'] == 'square':\n");
    fprintf(output, "                    rect = figure['rect']\n");
    fprintf(output, "                    rect.x = dx\n");
    fprintf(output, "                    rect.y = dy\n");
    fprintf(output, "                elif figure['type'] == 'circle':\n");
    fprintf(output, "                    figure['center'] = (dx, dy)\n");
    fprintf(output, "            else:\n");
    fprintf(output, "                print('Figure not found:', name)\n");

    // After processing the command, redraw all figures
    fprintf(output, "        # Redraw all figures\n");
    fprintf(output, "        for fig in figures.values():\n");
    fprintf(output, "            fig_color = fig.get('color', (0, 0, 0))\n");
    fprintf(output, "            fig_line_width = fig.get('line_width', 1)\n");
    fprintf(output, "            if fig['type'] == 'grid':\n");
    fprintf(output, "                spacing = fig['spacing']\n");
    fprintf(output, "                for x in range(0, 1000, spacing):\n");
    fprintf(output, "                    pygame.draw.line(screen, (200, 200, 200), (x, 0), (x, 800), 1)\n");
    fprintf(output, "                for y in range(0, 800, spacing):\n");
    fprintf(output, "                    pygame.draw.line(screen, (200, 200, 200), (0, y), (1000, y), 1)\n");
    fprintf(output, "            elif fig['type'] == 'point':\n");
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
    fprintf(output, "            elif fig['type'] == 'ellipse':\n");
    fprintf(output, "                pygame.draw.ellipse(screen, fig_color, fig['rect'], fig_line_width)\n");
    fprintf(output, "            elif fig['type'] == 'arc':\n");
    fprintf(output, "                pygame.draw.arc(screen, fig_color, fig['rect'], fig['start_angle'], fig['end_angle'], fig['thickness'])\n");
    fprintf(output, "            elif fig['type'] == 'picture':\n");
    fprintf(output, "                try:\n");
    fprintf(output, "                    image = pygame.image.load(fig['path']).convert_alpha()\n");
    fprintf(output, "                    image_width, image_height = image.get_size()\n");
    fprintf(output, "                    scaled_image = pygame.transform.scale(image, (int(image_width * fig['scale']), int(image_height * fig['scale'])))\n");
    fprintf(output, "                    screen.blit(scaled_image, (fig['x'], fig['y']))\n");
    fprintf(output, "                except pygame.error as e:\n");
    fprintf(output, "                    print(f\"Error loading image: {e}\")\n");
    fprintf(output, "            elif fig['type'] == 'text':\n");
    fprintf(output, "                font = pygame.font.Font(None, fig['size'])\n");
    fprintf(output, "                text_surface = font.render(fig['text'], True, fig_color)\n");
    fprintf(output, "                screen.blit(text_surface, (fig['x'], fig['y']))\n");
    fprintf(output, "            elif fig['type'] == 'polygon':\n");
    fprintf(output, "                pygame.draw.polygon(screen, fig_color, fig['points'], fig_line_width)\n");
    fprintf(output, "            elif fig['type'] == 'regular_polygon':\n");
    fprintf(output, "                pygame.draw.polygon(screen, fig_color, fig['points'], fig_line_width)\n");
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
