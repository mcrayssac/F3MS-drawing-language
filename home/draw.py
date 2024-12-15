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

