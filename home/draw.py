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
color = [0, 0, 255]
pygame.draw.rect(screen, color, pygame.Rect(100, 500, 100, 200))
line_width = 1
pygame.draw.circle(screen, color,(500, 100), 100, line_width)
line_width = 5
pygame.draw.rect(screen, color, pygame.Rect(500, 100, 100, 100))
color = [225, 10, 0]
pygame.draw.ellipse(screen, color, pygame.Rect(400, 500, 200, 90))
for x in range(0, 1000, 50):
    pygame.draw.line(screen, (0, 0, 0), (x, 0), (x, 800), 1)
for y in range(0, 800, 50):
    pygame.draw.line(screen, (0, 0, 0), (0, y), (1000, y), 1)
pentagon = [(100, 100), (150, 50), (200, 100), (175, 150), (125, 150), ]
color = [255, 0, 0]
pygame.draw.polygon(screen, color, pentagon, line_width)
triangle = [(300, 300), (350, 250), (400, 300), ]
color = [0, 255, 0]
pygame.draw.polygon(screen, color, triangle, line_width)

pygame.display.flip()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
pygame.quit()
