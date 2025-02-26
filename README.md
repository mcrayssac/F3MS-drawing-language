# F3MS-drawing-language

> Compilateur `.draw` vers Python avec Pygame

Ce projet consiste à développer un compilateur en C qui traduit un langage de dessin personnalisé. Il est défini dans
des fichiers `.draw` avec un langage créé spécifiquement. Le compilateur génère des scripts Python utilisant la
bibliothèque **Pygame** pour réaliser des dessins avancés et des animations.

## Demo

[https://github.com/mcrayssac/F3MS-drawing-language/blob/main/ProjetC.mp4](https://github.com/user-attachments/assets/37248500-9c9e-4b5f-9308-d4ed4ebd22b6
)

## Table des matières

- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Usage](#usage)
- [Syntaxe du Langage `.draw`](#syntaxe-du-langage-draw)
  - [Primitives de Dessin](#primitives-de-dessin)
  - [Transformations](#transformations)
  - [Animation et Timing](#animation-et-timing)
  - [Exemples](#exemples)
- [Gestion des Erreurs](#gestion-des-erreurs)
- [Dépendances](#dépendances)
- [Licence](#licence)
- [Crédits](#crédits)

---

## Introduction

Ce compilateur permet aux utilisateurs de créer des dessins complexes et des animations en écrivant du code dans un
langage simple et convivial ressemblant à Python. Les fichiers `.draw` sont ensuite compilés en scripts Python qui
utilisent Pygame pour exécuter les instructions de dessin.

## Mise en œuvre

### Choix des Outils

Pour ce projet, nous avons sélectionné plusieurs outils pour répondre aux besoins spécifiques du compilateur et offrir une expérience utilisateur optimale :

- **Flex** : Générateur d'analyseur lexical choisi pour sa capacité à analyser efficacement le code source `.draw` et à convertir les séquences de caractères en tokens compréhensibles par le compilateur.

- **Bison** : Générateur d'analyseur syntaxique utilisé pour construire l'arbre syntaxique abstrait (AST) à partir des tokens fournis par Flex. Bison facilite la définition de la grammaire du langage personnalisé.

- **Pygame** : Bibliothèque Python dédiée au multimédia et aux jeux, choisie pour sa facilité d'utilisation dans la création de graphiques 2D et la gestion des animations nécessaires pour exécuter les scripts générés.

- **GTK 3** : Utilisé pour développer une interface graphique utilisateur (IDE) conviviale, permettant aux utilisateurs d'éditer, de compiler et d'exécuter des fichiers `.draw` dans un environnement intégré.

## Fonctionnalités

- **Primitives de Dessin** : Lignes, cercles, rectangles, polygones, images, texte.
- **Transformations** : Rotation, mise à l'échelle, translation.
- **Animations** : Contrôle du temps, boucles d'animation, transformations animées.
- **Couleurs et Styles** : Définition des couleurs, styles de lignes, remplissages.
- **Contrôle du Flux** : Boucles `for` et `while`, conditions `if`/`else`.
- **Gestion des Erreurs** : Messages d'erreur clairs avec numéros de ligne.

## Installation

### Prérequis

- **Flex** : Version 2.6.4. Générateur d'analyseur lexical.
- **Bison** : Version 2.3. Générateur d'analyseur syntaxique.
- **GCC** : Compilateur C.
- **Python 3** : Version 3.6 ou ultérieure.
- **Pygame** : Bibliothèque Python pour le multimédia et les jeux.
- **Gtk 3** : Librairies pour creer un IDE

### Étapes d'Installation

1. **Cloner le Répertoire du Projet**

   ```bash
   git clone https://github.com/mcrayssac/F3MS-drawing-language.git
   cd F3MS-drawing-language
   ```

2. **Installer les Dépendances Python**

   ```bash
   pip install pygame
   ```

3. **Installer Gtk3 , Gtksourceview3 et Vte2.91 **

   ```bash
   sudo apt install libgtk-3-dev libgtksourceview-3.0-dev libvte-2.91-dev
    ```

4. **Etapes de Compilation**

- Insérer le code dans un fichier `.draw` (dans le répertoire `home` avec exemple de nom `my_draw.draw`):

    ```python
    set_color(255,0,0); 
    point1 = point(200,300);
    point2 = point(400,400);
    line(point1,point2);
    ```

- Supprimer les fichiers générés précédemment:

    ```bash
    make clean
    ```

- Compiler le compilateur:

    ```bash
    make (all) [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py]
    ```
- Compiler le fichier `.draw` en un script Python:

    ```bash
    make output [DRAW_FILE=my_draw.draw] [OUTPUT_PY=draw.py]
    ```
- Exécuter le script Python généré:

    ```bash
    python draw.py
    ```
  ou
    ```bash
    python3 draw.py
    ```

- Compiler et executer l'ide (etre dans le dossier ide):

  ```bash
    cd ide
    gcc -o ide textEditor.c `pkg-config --cflags --libs gtk+-3.0 gtksourceview-3.0 vte-2.91`
    chmod +x ide
    ./ide
  ```

## Usage

Pour compiler un fichier `.draw` en un script Python :

```bash
./f3ms_draw_compiler fichier.draw draw.py
```

Pour exécuter le script Python généré :

```bash
python draw.py
```

## Syntaxe du Langage `.draw`

### Primitives de Dessin

<details>
  <summary>Point x y</summary>

#### **Point x y**

##### Description

> Crée un point dans un environnement 2D
> 

##### Syntaxe

```python
point1 = point(x, y);
```

##### Paramètres

> `float x` : abscisse
>
> `float y` : ordonnée
>

</details>

<details>
  <summary>Line point1 point2</summary>

#### **Line point1 point2**

##### Description

> Crée une ligne en indiquant ses deux extrémités
> 

##### Syntaxe

```python
line1 = line(point1, point2);
```

##### Paramètres

> `point point1` : première extrémité de la ligne
>
> `point point2` : deuxième extrémité de la ligne
>

</details>

<details>
  <summary>Rectangle point width height</summary>

#### **Rectangle point width height**

##### Description

> Crée un rectangle en indiquant son coin supérieur gauche et ses dimensions
>

##### Syntaxe

```python
rectangle1 = rectangle(point, width, height);
```

##### Paramètres

> `point point` : coin supérieur gauche du rectangle
>
> `float width` : largeur du rectangle
>
> `float height` : hauteur du rectangle
>

</details>

<details>
  <summary>Square point size</summary>

#### **Square point size**

##### Description

> Crée un carré dans l’environnement en 2D, avec comme extrémité haut-gauche comme point de départ.
> 

##### Syntaxe

```python
square1 = square(point, size);
```

##### Paramètres

> `point point` : coin supérieur gauche du carré
>
> `float size` : taille d'un côté du carré
>

</details>

<details>
  <summary>Circle point radius</summary>

#### **Circle point radius**

##### Description

> Crée un cercle dans l’environnement en 2D, centré sur le point donné.
> 

##### Syntaxe

```python
circle1 = circle(point, radius);
```

##### Paramètres

> `point point` : centre du cercle
>
> `float radius` : rayon du cercle
>

</details>

<details>
  <summary>Ellipse point width height</summary>

#### **Ellipse point width height**

##### Description

> Dessine une ellipse dans l’environnement en 2D, centrée sur le point donné.
>

##### Syntaxe

```python
ellipse(point, width, height);
```

##### Paramètres

> `point point` : centre de l’ellipse
>
> `float width` : largeur de l’ellipse
>
> `float height` : hauteur de l’ellipse
>

</details>

<details>
  <summary>Polygon points</summary>

#### **Polygon points**

##### Description

> Dessine un polygon dans l’environnement en 2D, à partir d’une liste de points donnés.
>

##### Syntaxe

```python
polygon(points);
```

##### Paramètres

> `list points` : liste de points du polygon
>

</details>

<details>
  <summary>Arc point radius start_angle end_angle</summary>

#### **Arc point radius start_angle end_angle**

##### Description

> Dessine un arc dans l’environnement en 2D, centré sur le point donné.
>

##### Syntaxe

```python
arc(point, radius, start_angle, end_angle);
```

##### Paramètres

> `point point` : centre de l’arc
>
> `float radius` : rayon de l’arc
>
> `int start_angle` : angle de début de l’arc
>
> `int end_angle` : angle de fin de l’arc
>

</details>

<details>
  <summary>Regular polygon point sides radius</summary>

#### **Regular polygon point sides radius**

##### Description

> Dessine un polygone régulier dans l’environnement en 2D.
>

##### Syntaxe

```python
regular_polygon(point, sides, radius);
```

##### Paramètres

> `point point` : centre du polygone
>
> `int sides` : nombre de côtés du polygone
>
> `float radius` : rayon du polygone par lesquels les sommets passent
>

</details>

<details>
  <summary>Star point points outer_radius inner_radius</summary>

#### **Star point points outer_radius inner_radius**

##### Description

> Dessine une étoile dans l’environnement en 2D.
>

##### Syntaxe

```python
star(point, points, outer_radius, inner_radius);
```

##### Paramètres

> `point point` : centre de l’étoile
>
> `int points` : nombre de points extérieurs de l’étoile
>
> `float outer_radius` : rayon extérieur de l’étoile
>
> `float inner_radius` : rayon intérieur de l’étoile
>

</details>

<details>
  <summary>Text point text font_size</summary>

#### **Text point text font_size**

##### Description

> Dessine un texte dans l’environnement en 2D avec différents paramètres.
>

##### Syntaxe

```python
text(point, text, font_size);
```

##### Paramètres

> `point point` : position de départ du texte à afficher
>
> `string text` : texte à afficher
>
> `int font_size` : taille de la police du texte
>

</details>

<details>
  <summary>Image point width height filepath</summary>

#### **Image point width height filepath**

##### Description

> Dessine une image dans l’environnement en 2D avec une certaine taille.
>

##### Syntaxe

```python
image(point, width, height, filepath);
```

##### Paramètres

> `point point` : position de l’image à dessiner
>
> `float width` : largeur de l’image
>
> `float height` : hauteur de l’image
>
> `string filepath` : chemin du fichier image
>

</details>

### Variables et Assignations

Les figures peuvent être assignées à des variables pour être réutilisées et manipulées ultérieurement.

```python
point1 = point(200, 300);
point2 = point(400, 400);
line1 = line(point1, point2);
rectangle1 = rectangle(point1, 100, 200);
circle1 = circle(point2, 100);
square1 = square(point2, 100);
```

### Dessiner une Figure

La commande `draw` permet de dessiner une figure précédemment définie.

```python
draw(line1);
draw(rectangle1);
draw(circle1);
draw(square1);
```

### Transformations sur les Figures

Les transformations peuvent être appliquées spécifiquement à une figure.

- **rotate(figure, angle)**

  Applique une rotation de `angle` degrés à la figure spécifiée.

  ```python
  rotate(line1, 45);
  rotate(rectangle1, 90);
  rotate(square1, 30);
  rotate(circle1, 60);
  ```

- **translate(figure, dx, dy)**

  Déplace la figure spécifiée de `dx` en abscisse et `dy` en ordonnée.

  ```python
  translate(circle1, 200, 100);
  translate(rectangle1, 200, 100);
  ```

### Transformations

- **rotate angle**

  Applique une rotation aux objets dessinés après cette commande.

- **scale sx sy**

  Applique une mise à l'échelle horizontale `sx` et verticale `sy`.

- **translate dx dy**

  Déplace les objets dessinés après cette commande.

- **reset_transform**

  Réinitialise les transformations appliquées.

### Couleurs et Styles

- **set_color r g b**

  Définit la couleur de dessin actuelle.

- **set_fill_color r g b**

  Définit la couleur de remplissage pour les formes.

- **set_line_width width**

  Définit l'épaisseur des lignes.

### Animation et Timing

- **wait milliseconds**

  Pause l'exécution pour le temps spécifié.

- **update**

  Met à jour l'affichage avec les dessins récents.

### Contrôle du Flux

- **Boucles**

  ???

- **Conditions**

  ???

### Exemple Complet

```python
set_color(0, 0, 0); 
point1 = point(200, 300);
point2 = point(400, 400);
line1 = line(point1, point2);
draw(line1);

set_line_width(5);
set_color(255, 0, 0); 
point1 = point(600, 600);
point2 = point(100, 600);
line2 = line(point1, point2);
draw(line2);

set_color(0, 100, 0); 
point1 = point(150, 500);
point2 = point(500, 100);
line3 = line(point1, point2);
draw(line3);

set_color(0, 0, 255);
rectangle1 = rectangle(point1, 100, 200);
draw(rectangle1);

set_line_width(1);
circle1 = circle(point2, 100);
draw(circle1);

set_line_width(5);
square1 = square(point2, 100);
draw(square1);

rotate(line1, 45);
rotate(rectangle1, 90);
rotate(square1, 45);
rotate(circle1, 60);

translate(circle1, 500, 200);
translate(rectangle1, 500, 200);
translate(square1, 500, 200);
```

## Gestion des Erreurs

Le compilateur fournit des messages d'erreur clairs avec des numéros de ligne pour faciliter le débogage.

**Exemple :**

```plaintext
???
```

## Dépendances

- **Flex** : [https://github.com/westes/flex](https://github.com/westes/flex)
- **Bison** : [https://www.gnu.org/software/bison/](https://www.gnu.org/software/bison/)
- **Pygame** : [https://www.pygame.org/](https://www.pygame.org/)

## Licence

???

## Crédits

Développé par **CRAYSSAC Maxime, DELSUC Florian, AGUEL Fatima, DRIDI Iskander, AHMED Faïkidine, ELBAZ Benjamin et HAMMOUCHE Kévin** dans le cadre du projet *
*Compilateur C de langage de dessin** pour le cours de **Complément algorithmique** à **CY Tech - Cergy Paris
Université (ex EISTI)**.

---

**Note :** N'hésitez pas à contribuer à ce projet en signalant des problèmes.
