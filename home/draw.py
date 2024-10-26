import pygame
pygame.init()
screen = pygame.display.set_mode((800, 600))
pygame.display.set_caption('Draw Line')
screen.fill((255, 255, 255))
color = (0, 0, 0)

color = (1.000000, 0.000000, 0.000000)
pygame.draw.line(screen, color, (200, 300), (400, 400), 1)

pygame.display.flip()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
pygame.quit()
