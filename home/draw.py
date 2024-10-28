import pygame
pygame.init()
screen = pygame.display.set_mode((1000, 800))
pygame.display.set_caption('Draw Line')
screen.fill((255, 255, 255))
color = (0, 0, 0)
line_width = 1

color = [0, 0, 0]
pygame.draw.line(screen, color, (200, 300), (400, 400), line_width)
line_width = 5
color = [255, 0, 0]
pygame.draw.line(screen, color, (600, 600), (100, 600), line_width)
color = [0, 100, 0]
pygame.draw.line(screen, color, (150, 500), (500, 100), line_width)

pygame.display.flip()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
pygame.quit()
