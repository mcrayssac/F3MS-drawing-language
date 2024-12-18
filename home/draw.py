import pygame
import math
pygame.init()
screen = pygame.display.set_mode((1000, 800))
pygame.display.set_caption('Draw Line')
screen.fill((255, 255, 255))
color = (0, 0, 0)
line_width = 1

pygame.draw.line(screen, color, (200, 300), (400, 400), line_width)
line_width = 5
color = [255, 0, 0]
pygame.draw.line(screen, color, (200, 300), (400, 400), line_width)
color = [0, 100, 0]
pygame.draw.line(screen, color, (150, 500), (500, 100), line_width)
color = [0, 0, 255]
pygame.draw.rect(screen, color, pygame.Rect(100, 500, 100, 200))
line_width = 1
line_width = 3
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
triangle = [(500, 400), (550, 250), (600, 400), ]
color = [0, 255, 0]
pygame.draw.polygon(screen, color, triangle, line_width)
color = [250, 0, 255]
pygame.draw.arc(screen, color, pygame.Rect(589, 289, 222, 222), 0, 2.094395, 10)
image = pygame.image.load("../home/image/image.png").convert_alpha()
image_width, image_height = image.get_size()
scaled_image = pygame.transform.scale(image, (int(image_width * 0.800000), int(image_height * 0.800000)))
screen.blit(scaled_image, (400, 600))
pygame.display.flip()
color = [0, 0, 255]
font = pygame.font.Font(None, 36)
text_surface = font.render("Bonjour", True, color)
screen.blit(text_surface, (100, 200))
pygame.display.flip()
color = [180, 100, 180]
font = pygame.font.Font(None, 36)
text_surface = font.render("à", True, color)
screen.blit(text_surface, (207, 200))
pygame.display.flip()
color = [255, 0, 0]
font = pygame.font.Font(None, 36)
text_surface = font.render("tous", True, color)
screen.blit(text_surface, (232, 200))
pygame.display.flip()
color = [0, 0, 0]
font = pygame.font.Font(None, 36)
text_surface = font.render(" !!!", True, color)
screen.blit(text_surface, (285, 200))
pygame.display.flip()
color = [150, 85, 189]
points = []
cx, cy = 850, 300
sides, radius = 6, 50.141888
for i in range(sides):
    angle = 2 * 3.14159 * i / sides
    x = cx + radius * math.cos(angle)
    y = cy + radius * math.sin(angle)
    points.append((x, y))
pygame.draw.polygon(screen, color, points, line_width)
color = [185, 100, 105]
points = []
cx, cy = 850, 150
sides, radius = 3, 74.846199
for i in range(sides):
    angle = 2 * 3.14159 * i / sides
    x = cx + radius * math.cos(angle)
    y = cy + radius * math.sin(angle)
    points.append((x, y))
pygame.draw.polygon(screen, color, points, line_width)
color = [0, 0, 255]
points = []
cx, cy = 850, 400
sides, radius = 8, 38.784000
for i in range(sides):
    angle = 2 * 3.14159 * i / sides
    x = cx + radius * math.cos(angle)
    y = cy + radius * math.sin(angle)
    points.append((x, y))
pygame.draw.polygon(screen, color, points, line_width)

pygame.display.flip()
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
pygame.quit()
