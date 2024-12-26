import pygame
import math
pygame.init()
screen = pygame.display.set_mode((1000, 800))
pygame.display.set_caption('Dynamic Drawing')
clock = pygame.time.Clock()
color = (0, 0, 0)
line_width = 1
commands = []
figures = {}

commands.append(('SET_COLOR', (0, 100, 0)))
commands.append(('SET_LINE_WIDTH', 2))
commands.append(('DRAW_ELLIPSE', (300, 200), 150, 100, 'myellipse'))

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
        elif cmd[0] == 'ROTATE':
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
            if fig['type'] == 'point':
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
        index += 1

    pygame.display.flip()
    clock.tick(10)

pygame.quit()
