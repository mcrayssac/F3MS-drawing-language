# F3MS-drawing-language

> Compilateur `.draw` vers Python avec Pygame

Ce projet consiste à développer un compilateur en C qui traduit un langage de dessin personnalisé. Il est défini dans
des fichiers `.draw` avec un langage créé spécifiquement. Le compilateur génère des scripts Python utilisant la
bibliothèque **Pygame** pour réaliser des dessins avancés et des animations.

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

## Fonctionnalités

- **Primitives de Dessin** : Lignes, cercles, rectangles, polygones, images, texte.
- **Transformations** : Rotation, mise à l'échelle, translation.
- **Animations** : Contrôle du temps, boucles d'animation, transformations animées.
- **Couleurs et Styles** : Définition des couleurs, styles de lignes, remplissages.
- **Contrôle du Flux** : Boucles `for` et `while`, conditions `if`/`else`.
- **Gestion des Erreurs** : Messages d'erreur clairs avec numéros de ligne.

## Installation

### Prérequis

- **Flex** : Générateur d'analyseur lexical.
- **Bison** : Générateur d'analyseur syntaxique.
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

3. **Installer Gtk 3 et VTE**

   ```bash
   sudo apt install libgtk-3-dev libvte-2.91-dev
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
  gcc -o ide textEditor.c `pkg-config --cflags --libs gtk+-3.0` && ./ide
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

> Dessine un point dans un environnement 2D
>

##### Syntaxe

```python
point(x, y);
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

> Dessine un ligne en indiquant ses deux extrémités
>

##### Syntaxe

```python
line(point1, point2);
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

> Dessine un rectangle en indiquant son coin supérieur gauche et ses dimensions

##### Syntaxe

```python
rectangle(point, width, height);
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

> Dessine un carré dans l’environnement en 2D, avec comme extrémité haut-gauche comme point de départ.
>

##### Syntaxe

```python
square(point, size);
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

> Dessine un cercle dans l’environnement en 2D, centré sur le point donné.
>

##### Syntaxe

```python
circle(point, radius);
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

<details>
  <summary>Grid</summary>

#### **Grid**

##### Description

> Dessine une grille dans l'environnement 2D avec un espacement spécifié entre les lignes.

##### Syntaxe

```python
grid(espacement);
```

##### Paramètres

> `int espacement` : Espacement en pixels entre les lignes de la grille.

##### Exemple

```python
grid(50);  // Dessine une grille avec des lignes espacées de 50 pixels
```

##### Note

> L'espacement définit la distance entre chaque ligne verticale et horizontale de la grille.
> Une valeur plus petite pour l'espacement crée une grille plus dense, tandis qu'une valeur plus grande crée une grille plus espacée.

</details>


<details>
  <summary>Arc</summary>

#### **Arc**

##### Description

> Dessine un arc de cercle dans l'environnement 2D avec une épaisseur et un angle spécifiés.
>

##### Syntaxe

```python
arc(point1, point2, angle, thickness);
```

##### Paramètres

> `point point1` : point de départ de l'arc (centre)
>
> `point point2` : point définissant le rayon de l'arc
>
> `float angle` : angle de l'arc en degrés
>
> `int thickness` : épaisseur du trait de l'arc
>

##### Exemple

```python
p1 = point(200, 200);  // Centre de l'arc
p2 = point(300, 200);  // Point pour définir le rayon
arc(p1, p2, 90, 5);    // Arc de 90 degrés avec une épaisseur de 5
```

##### Note

> Le rayon de l'arc est calculé automatiquement comme la moitié de la distance entre les deux points.
> L'angle est mesuré à partir de l'axe horizontal dans le sens trigonométrique.
>

</details>

<details>
  <summary>Image</summary>

#### **Image**

##### Description

> Charge et affiche une image dans l'environnement 2D à une position donnée, avec une échelle spécifiée.
>

##### Syntaxe

```python
image("chemin/vers/image.png", x, y, scale);
```

##### Paramètres

> `string chemin` : chemin vers l'image à afficher (fichier image supporté par Pygame, comme `.png` ou `.jpg`).
>
> `int x` : position en **abscisse** (coordonnée horizontale) où l'image sera affichée.
>
> `int y` : position en **ordonnée** (coordonnée verticale) où l'image sera affichée.
>
> `float scale` : facteur d'échelle pour redimensionner l'image (valeur comprise entre 0 et 1).

##### Exemple

```python
image("../home/image/image.png", 400, 600, 0.8);
```

Dans cet exemple :
- L'image est chargée depuis le chemin `"../home/image/image.png"`.
- Elle est affichée à la position `(400, 600)` sur l'écran.
- Elle est redimensionnée à **80%** de sa taille originale grâce au facteur d'échelle `0.8`.

##### Note

> L'échelle (`scale`) est une valeur flottante entre `0` et `1`.  
> Une échelle de `1` conserve la taille originale de l'image, tandis qu'une échelle de `0.5` réduit la largeur et la hauteur de l'image à 50% de leur taille originale.

</details>


<details>
  <summary>Text</summary>

#### **Text**

##### Description

> Permet d'afficher du texte dans l'environnement 2D à une position donnée, avec une taille de police spécifiée. La couleur du texte doit être définie au préalable à l'aide de `set_color`.

##### Paramètres

> **Pour `set_color`**  
> `int r` : intensité du **rouge** (valeur comprise entre 0 et 255).  
> `int g` : intensité du **vert** (valeur comprise entre 0 et 255).  
> `int b` : intensité du **bleu** (valeur comprise entre 0 et 255).

> **Pour `text`**  
> `string contenu` : texte à afficher.  
> `int x` : position en **abscisse** (coordonnée horizontale).  
> `int y` : position en **ordonnée** (coordonnée verticale).  
> `int size` : taille de la police.

##### Syntaxe

```python
set_color(255, 255, 255);  // Définit la couleur blanche
text("Monde", 150, 250, 48);  // Affiche "Monde" en blanc à (150, 250) avec une police taille 48
```

</details>


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

### Exemples

???

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

Développé par **CRAYSSAC Maxime, DELSUC Florian, AGUEL Fatima, AHMED Faïkidine et ???** dans le cadre du projet *
*Compilateur C de langage de dessin** pour le cours de **Complément algorithmique** à **CY Tech - Cergy Paris
Université (ex EISTI)**.

---

**Note :** N'hésitez pas à contribuer à ce projet en signalant des problèmes.