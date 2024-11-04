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

commands.append(('SET_COLOR', (0, 0, 0)))
commands.append(('DRAW_LINE', (100, 100), (100, 0), 'lineX'))
commands.append(('DRAW_LINE', (100, 100), (0, 100), 'lineY'))

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
        elif cmd[0] == 'TRANSLATE':
            name = cmd[1]
            dx = cmd[2]
            dy = cmd[3]
            if name in figures:
                figure = figures[name]
                if figure['type'] == 'point':
                    figure['position'] = (figure['position'][0] + dx, figure['position'][1] + dy)
                elif figure['type'] == 'line':
                    figure['start'] = (figure['start'][0] + dx, figure['start'][1] + dy)
                    figure['end'] = (figure['end'][0] + dx, figure['end'][1] + dy)
                elif figure['type'] == 'rectangle' or figure['type'] == 'square':
                    rect = figure['rect']
                    rect.x += dx
                    rect.y += dy
                elif figure['type'] == 'circle':
                    figure['center'] = (figure['center'][0] + dx, figure['center'][1] + dy)
        # Redraw all figures
        for fig in figures.values():
            fig_color = fig.get('color', (0, 0, 0))
            fig_line_width = fig.get('line_width', 1)
            if fig['type'] == 'point':
                pygame.draw.circle(screen, fig_color, fig['position'], fig_line_width)
            elif fig['type'] == 'line':
                pygame.draw.line(screen, fig_color, fig['start'], fig['end'], fig_line_width)
            elif fig['type'] == 'rectangle' or fig['type'] == 'square':
                pygame.draw.rect(screen, fig_color, fig['rect'], fig_line_width)
            elif fig['type'] == 'circle':
                pygame.draw.circle(screen, fig_color, fig['center'], fig['radius'], fig_line_width)
        index += 1

    pygame.display.flip()
    clock.tick(5)

pygame.quit()
