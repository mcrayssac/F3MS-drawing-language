import pygame
import math
pygame.init()
screen = pygame.display.set_mode((1000, 800))
pygame.display.set_caption('Dynamic Drawing')
clock = pygame.time.Clock()
pygame.font.init()
color = (0, 0, 0)
line_width = 1
commands = []
figures = {}

p1 = (600, 150)
p2 = (700, 250)
radius = int(((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)**0.5 / 2)
rect = pygame.Rect(p1[0] - radius, p1[1] - radius, radius * 2, radius * 2)
pygame.draw.arc(screen, color, rect, 0, math.radians(180.000000), 7)
figures['myarc'] = {
    'type': 'arc',
    'rect': rect,
    'start_angle': 0,
    'end_angle': math.radians(180.000000),
    'thickness': 7,
    'color': color
}
commands.append(('DRAW_GRID', 80))
commands.append(('SET_COLOR', (150, 180, 0)))
commands.append(('SET_LINE_WIDTH', 4))
commands.append(('DRAW_ELLIPSE', (400, 300), 120, 180, 'myellipse'))
commands.append(('SET_COLOR', (55, 160, 10)))
commands.append(('SET_LINE_WIDTH', 5))
commands.append(('DRAW_ELLIPSE', (400, 300), 120, 180, 'myarc'))
commands.append(('SET_COLOR', (55, 160, 10)))
commands.append(('DRAW_TEXT', "Arc", 580, 120, 35))
commands.append(('SET_COLOR', (150, 180, 0)))
commands.append(('DRAW_TEXT', "Ellipse", 360, 288, 38))
commands.append(('SET_COLOR', (8, 105, 154)))
commands.append(('DRAW_TEXT', "France", 350, 680, 45))
commands.append(('DRAW_PICTURE', "../home/image/logo.png", 100, 100, 0.750000))
commands.append(('SET_COLOR', (255, 255, 255)))
commands.append(('SET_LINE_WIDTH', 150))
commands.append(('DRAW_RECTANGLE', (300, 510), 200, 140, 'rectanglefond'))
commands.append(('SET_COLOR', (66, 144, 70)))
commands.append(('DRAW_POLYGON', [(100,100), (150,50), (200,100), ], 'myPoly'))
commands.append(('DRAW_POLYGON', [(100,100), (150,50), (200,100), ], 'myPoly'))
commands.append(('SET_COLOR', (39, 182, 171)))
commands.append(('DRAW_REGULAR_POLYGON', (100,100), 5, 60.000000, 'myRegPoly1'))
commands.append(('DRAW_REGULAR_POLYGON', (100,100), 5, 60.000000, 'myRegPoly1'))
commands.append(('SET_COLOR', (171, 22, 191)))
commands.append(('DRAW_REGULAR_POLYGON', (300,300), 4, 100.000000, 'myRegPoly2'))
commands.append(('DRAW_REGULAR_POLYGON', (300,300), 4, 100.000000, 'myRegPoly2'))
commands.append(('SET_COLOR', (0, 85, 164)))
commands.append(('SET_LINE_WIDTH', 15))
commands.append(('DRAW_RECTANGLE', (300, 630), 66, 20, 'rectbleu1'))
commands.append(('DRAW_RECTANGLE', (300, 610), 66, 20, 'rectbleu2'))
commands.append(('DRAW_RECTANGLE', (300, 590), 66, 20, 'rectbleu3'))
commands.append(('DRAW_RECTANGLE', (300, 570), 66, 20, 'rectbleu4'))
commands.append(('DRAW_RECTANGLE', (300, 550), 66, 20, 'rectbleu5'))
commands.append(('DRAW_RECTANGLE', (300, 530), 66, 20, 'rectbleu6'))
commands.append(('DRAW_RECTANGLE', (300, 510), 66, 20, 'rectbleu7'))
commands.append(('SET_COLOR', (239, 65, 53)))
commands.append(('SET_LINE_WIDTH', 15))
commands.append(('DRAW_RECTANGLE', (434, 630), 66, 20, 'rectrouge1'))
commands.append(('DRAW_RECTANGLE', (434, 610), 66, 20, 'rectrouge2'))
commands.append(('DRAW_RECTANGLE', (434, 590), 66, 20, 'rectrouge3'))
commands.append(('DRAW_RECTANGLE', (434, 570), 66, 20, 'rectrouge4'))
commands.append(('DRAW_RECTANGLE', (434, 550), 66, 20, 'rectrouge5'))
commands.append(('DRAW_RECTANGLE', (434, 530), 66, 20, 'rectrouge6'))
commands.append(('DRAW_RECTANGLE', (434, 510), 66, 20, 'rectrouge7'))

running = True
index = 0
screen.fill((255, 255, 255))
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    if index < len(commands):
        cmd = commands[index]
        screen.fill((255, 255, 255))
        if cmd[0] == 'SET_COLOR':
            color = cmd[1]
        elif cmd[0] == 'SET_LINE_WIDTH':
            line_width = cmd[1]
        elif cmd[0] == 'DRAW_POINT':
            name = cmd[2]
            figures[name] = {'type': 'point', 'position': cmd[1], 'color': color, 'line_width': line_width}
            pygame.draw.circle(screen, color, cmd[1], line_width)
        elif cmd[0] == 'DRAW_LINE':
            name = cmd[3]
            figures[name] = {'type': 'line', 'start': cmd[1], 'end': cmd[2], 'color': color, 'line_width': line_width}
            pygame.draw.line(screen, color, cmd[1], cmd[2], line_width)
        elif cmd[0] == 'DRAW_RECTANGLE':
            name = cmd[4]
            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[3])
            figures[name] = {'type': 'rectangle', 'rect': rect, 'color': color, 'line_width': line_width}
            pygame.draw.rect(screen, color, rect, line_width)
        elif cmd[0] == 'DRAW_SQUARE':
            name = cmd[3]
            rect = pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[2])
            figures[name] = {'type': 'square', 'rect': rect, 'color': color, 'line_width': line_width}
            pygame.draw.rect(screen, color, rect, line_width)
        elif cmd[0] == 'DRAW_CIRCLE':
            name = cmd[3]
            figures[name] = {'type': 'circle', 'center': cmd[1], 'radius': cmd[2], 'color': color, 'line_width': line_width}
            pygame.draw.circle(screen, color, cmd[1], cmd[2], line_width)
        elif cmd[0] == 'DRAW_ELLIPSE':
            name = cmd[4]
            rect = pygame.Rect(cmd[1][0] - cmd[2]//2, cmd[1][1] - cmd[3]//2, cmd[2], cmd[3])
            figures[name] = {'type': 'ellipse', 'rect': rect, 'color': color, 'line_width': line_width}
            pygame.draw.ellipse(screen, color, rect, line_width)
        elif cmd[0] == 'DRAW_GRID':
            spacing = cmd[1]
            figures['grid'] = {'type': 'grid', 'spacing': spacing}
            for x in range(0, 1000, spacing):
                pygame.draw.line(screen, (200, 200, 200), (x, 0), (x, 800), 1)
            for y in range(0, 800, spacing):
                pygame.draw.line(screen, (200, 200, 200), (0, y), (1000, y), 1)
        elif cmd[0] == 'DRAW_ARC':
            p1, p2 = cmd[1], cmd[2]
            angle_deg, thickness = cmd[3], cmd[4]
            radius = int(((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)**0.5) // 2
            rect = pygame.Rect(p1[0] - radius, p1[1] - radius, radius * 2, radius * 2)
            name = cmd[5]
            figures[name] = {'type': 'arc', 'rect': rect, 'start_angle': 0, 'end_angle': math.radians(angle_deg), 'thickness': thickness, 'color': color}
            pygame.draw.arc(screen, color, rect, 0, math.radians(angle_deg), thickness)
        elif cmd[0] == 'DRAW_PICTURE':
            path, x, y, scale = cmd[1], cmd[2], cmd[3], cmd[4]
            try:
                image = pygame.image.load(path).convert_alpha()
                image_width, image_height = image.get_size()
                scaled_image = pygame.transform.scale(image, (int(image_width * scale), int(image_height * scale)))
                screen.blit(scaled_image, (x, y))
                figures[f'picture_{path}'] = {'type': 'picture', 'path': path, 'x': x, 'y': y, 'scale': scale}
            except pygame.error as e:
                print(f"Error loading image: {e}")
        elif cmd[0] == 'DRAW_TEXT':
            font = pygame.font.Font(None, cmd[4])
            text_surface = font.render(cmd[1], True, color)
            screen.blit(text_surface, (cmd[2], cmd[3]))
            figures[f"text_{cmd[1]}"] = {
                'type': 'text',
                'text': cmd[1],
                'x': cmd[2],
                'y': cmd[3],
                'size': cmd[4],
                'color': color
            }
            name = cmd[1]
            angle = cmd[2]
            if name in figures:
                figure = figures[name]
                if figure['type'] == 'line':
                    # Rotate line around its midpoint
                    sx, sy = figure['start']
                    ex, ey = figure['end']
                    mx = (sx + ex) / 2
                    my = (sy + ey) / 2
                    def rotate_point(x, y):
                        x -= mx
                        y -= my
                        radians = math.radians(angle)
                        x_new = x * math.cos(radians) - y * math.sin(radians) + mx
                        y_new = x * math.sin(radians) + y * math.cos(radians) + my
                        return x_new, y_new
                    figure['start'] = rotate_point(sx, sy)
                    figure['end'] = rotate_point(ex, ey)
                elif figure['type'] == 'rectangle' or figure['type'] == 'square':
                    # Rotate rectangle or square
                    rect = figure['rect']
                    image = pygame.Surface((rect.width, rect.height), pygame.SRCALPHA)
                    pygame.draw.rect(image, color, pygame.Rect(0, 0, rect.width, rect.height), line_width)
                    rotated_image = pygame.transform.rotate(image, angle)
                    new_rect = rotated_image.get_rect(center=rect.center)
                    figure['image'] = rotated_image
                    figure['rect'] = new_rect
                elif figure['type'] == 'circle':
                    # Rotating a circle has no visual effect
                    pass
                else:
                    print('Cannot rotate figure:', name)
        elif cmd[0] == 'DRAW_POLYGON':
            # cmd = ('DRAW_POLYGON', [(x1,y1), (x2,y2), ...], 'figureName')
            points = cmd[1]
            # Convertir les points en entiers
            int_points = [(int(x), int(y)) for (x, y) in points]
            figure_name = cmd[2]
            figures[figure_name] = {
                'type': 'polygon',
                'points': int_points,
                'color': color,
                'line_width': line_width
            }
            pygame.draw.polygon(screen, color, int_points, line_width)
        elif cmd[0] == 'DRAW_REGULAR_POLYGON':
            # cmd = ('DRAW_REGULAR_POLYGON', (cx, cy), sides, radius, 'figureName')
            center = cmd[1]
            sides = cmd[2]
            radius = cmd[3]
            figure_name = cmd[4]
            cx, cy = center
            reg_points = []
            for i in range(sides):
                angle = 2 * math.pi * i / sides
                x = cx + radius * math.cos(angle)
                y = cy + radius * math.sin(angle)
                reg_points.append((int(x), int(y)))
            figures[figure_name] = {
                'type': 'regular_polygon',
                'center': center,
                'sides': sides,
                'radius': radius,
                'points': reg_points,
                'color': color,
                'line_width': line_width
            }
            pygame.draw.polygon(screen, color, reg_points, line_width)
        elif cmd[0] == 'TRANSLATE':
            name = cmd[1]
            dx = cmd[2]
            dy = cmd[3]
            if name in figures:
                figure = figures[name]
                if figure['type'] == 'point':
                    figure['position'] = (dx, dy)
                elif figure['type'] == 'line':
                    figure['start'] = (dx, dy)
                    figure['end'] = (dx + (figure['end'][0] - figure['start'][0]), dy + (figure['end'][1] - figure['start'][1]))
                elif figure['type'] == 'rectangle' or figure['type'] == 'square':
                    rect = figure['rect']
                    rect.x = dx
                    rect.y = dy
                elif figure['type'] == 'circle':
                    figure['center'] = (dx, dy)
            else:
                print('Figure not found:', name)
        # Redraw all figures
        for fig in figures.values():
            fig_color = fig.get('color', (0, 0, 0))
            fig_line_width = fig.get('line_width', 1)
            if fig['type'] == 'grid':
                spacing = fig['spacing']
                for x in range(0, 1000, spacing):
                    pygame.draw.line(screen, (200, 200, 200), (x, 0), (x, 800), 1)
                for y in range(0, 800, spacing):
                    pygame.draw.line(screen, (200, 200, 200), (0, y), (1000, y), 1)
            elif fig['type'] == 'point':
                pygame.draw.circle(screen, fig_color, fig['position'], fig_line_width)
            elif fig['type'] == 'line':
                pygame.draw.line(screen, fig_color, fig['start'], fig['end'], fig_line_width)
            elif fig['type'] == 'rectangle' or fig['type'] == 'square':
                if 'image' in fig:
                    screen.blit(fig['image'], fig['rect'])
                else:
                    pygame.draw.rect(screen, fig_color, fig['rect'], fig_line_width)
            elif fig['type'] == 'circle':
                pygame.draw.circle(screen, fig_color, fig['center'], fig['radius'], fig_line_width)
            elif fig['type'] == 'ellipse':
                pygame.draw.ellipse(screen, fig_color, fig['rect'], fig_line_width)
            elif fig['type'] == 'arc':
                pygame.draw.arc(screen, fig_color, fig['rect'], fig['start_angle'], fig['end_angle'], fig['thickness'])
            elif fig['type'] == 'picture':
                try:
                    image = pygame.image.load(fig['path']).convert_alpha()
                    image_width, image_height = image.get_size()
                    scaled_image = pygame.transform.scale(image, (int(image_width * fig['scale']), int(image_height * fig['scale'])))
                    screen.blit(scaled_image, (fig['x'], fig['y']))
                except pygame.error as e:
                    print(f"Error loading image: {e}")
            elif fig['type'] == 'text':
                font = pygame.font.Font(None, fig['size'])
                text_surface = font.render(fig['text'], True, fig_color)
                screen.blit(text_surface, (fig['x'], fig['y']))
            elif fig['type'] == 'polygon':
                pygame.draw.polygon(screen, fig_color, fig['points'], fig_line_width)
            elif fig['type'] == 'regular_polygon':
                pygame.draw.polygon(screen, fig_color, fig['points'], fig_line_width)
        index += 1

    pygame.display.flip()
    clock.tick(5)

pygame.quit()
