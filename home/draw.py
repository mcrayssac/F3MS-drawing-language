import pygame
pygame.init()
screen = pygame.display.set_mode((1000, 800))
pygame.display.set_caption('Dynamic Drawing')
clock = pygame.time.Clock()
color = (0, 0, 0)
line_width = 1
commands = []

commands.append(('SET_COLOR', (0, 0, 0)))
commands.append(('DRAW_LINE', (200, 300), (400, 400)))
commands.append(('SET_LINE_WIDTH', 5))
commands.append(('SET_COLOR', (255, 0, 0)))
commands.append(('DRAW_LINE', (600, 600), (100, 600)))
commands.append(('SET_COLOR', (0, 100, 0)))
commands.append(('DRAW_LINE', (150, 500), (500, 100)))
commands.append(('SET_COLOR', (0, 0, 255)))
commands.append(('DRAW_RECTANGLE', (150, 500), 100, 200))
commands.append(('SET_LINE_WIDTH', 1))
commands.append(('DRAW_CIRCLE', (500, 100), 100))
commands.append(('SET_LINE_WIDTH', 5))
commands.append(('DRAW_SQUARE', (500, 100), 100))

running = True
index = 0
screen.fill((255, 255, 255))
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    if index < len(commands):
        cmd = commands[index]
        if cmd[0] == 'SET_COLOR':
            color = cmd[1]
        elif cmd[0] == 'SET_LINE_WIDTH':
            line_width = cmd[1]
        elif cmd[0] == 'DRAW_LINE':
            pygame.draw.line(screen, color, cmd[1], cmd[2], line_width)
        elif cmd[0] == 'DRAW_RECTANGLE':
            pygame.draw.rect(screen, color, pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[3]), line_width)
        elif cmd[0] == 'DRAW_SQUARE':
            pygame.draw.rect(screen, color, pygame.Rect(cmd[1][0], cmd[1][1], cmd[2], cmd[2]), line_width)
        elif cmd[0] == 'DRAW_CIRCLE':
            pygame.draw.circle(screen, color, cmd[1], cmd[2], line_width)
        index += 1

    pygame.display.flip()
    clock.tick(5)

pygame.quit()
