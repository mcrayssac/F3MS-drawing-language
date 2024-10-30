#include <gtk/gtk.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Variables globales pour stocker les widgets */
GtkWidget *text_view;
GtkTextBuffer *text_buffer;
char *filePath = NULL; // Utilisé pour stocker le chemin complet du fichier
char *filename = NULL; // Utilisé pour stocker le nom du fichier

/* Fonction pour mettre à jour le titre de la fenêtre */
void update_window_title(GtkWidget *window) {
    char window_title[256];
    if (filename != NULL) {
        snprintf(window_title, sizeof(window_title), "IDE - %s", filename);
    } else {
        snprintf(window_title, sizeof(window_title), "IDE");
    }
    gtk_window_set_title(GTK_WINDOW(window), window_title);
}

/* Fonction pour ouvrir un fichier */
void open_file(GtkWidget *widget, gpointer window) {
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Ouvrir un fichier", GTK_WINDOW(window),
                                                    GTK_FILE_CHOOSER_ACTION_OPEN, "Annuler", GTK_RESPONSE_CANCEL,
                                                    "Ouvrir", GTK_RESPONSE_ACCEPT, NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        GtkFileChooser *chooser = GTK_FILE_CHOOSER(dialog);

        /* Libère la mémoire de filename si un fichier est déjà ouvert */
        g_free(filePath);

        /* Met à jour le chemin complet du fichier */
        filePath = gtk_file_chooser_get_filename(chooser);

        /* Récupère le nom du fichier à partir du chemin complet */
        filename = g_path_get_basename(filePath);

        /* Lit le contenu du fichier et l'affiche dans le text_view */
        gchar *content;
        g_file_get_contents(filePath, &content, NULL, NULL);
        gtk_text_buffer_set_text(text_buffer, content, -1);
        g_free(content);

        /* Met à jour le titre de la fenêtre avec le nom du fichier */
        update_window_title(window);
    }
    gtk_widget_destroy(dialog);
}

/* Fonction pour enregistrer un fichier */
void save_file(GtkWidget *widget, gpointer window) {
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Enregistrer le fichier", GTK_WINDOW(window),
                                                    GTK_FILE_CHOOSER_ACTION_SAVE, "Annuler", GTK_RESPONSE_CANCEL,
                                                    "Enregistrer", GTK_RESPONSE_ACCEPT, NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        char *save_path;
        GtkFileChooser *chooser = GTK_FILE_CHOOSER(dialog);
        save_path = gtk_file_chooser_get_filename(chooser);

        GtkTextIter start, end;
        gtk_text_buffer_get_bounds(text_buffer, &start, &end);
        gchar *text = gtk_text_buffer_get_text(text_buffer, &start, &end, FALSE);

        g_file_set_contents(save_path, text, -1, NULL);
        g_free(text);
        g_free(save_path);
    }
    gtk_widget_destroy(dialog);
}

/* Fonction pour vérifier si pygame est installé */
int is_pygame_installed() {
    return system("./myenv/bin/python3 -c \"import pygame\" 2>/dev/null") == 0;
}

/* Fonction pour exécuter le fichier */
void execute() {
    printf("Execution...\n");

    if (filePath == NULL) {
        printf("Erreur : filePath est NULL\n");
        return;
    }

    printf("Chemin du fichier : %s\n", filePath);
    printf("Nom du fichier : %s\n", filename);

    char command[512];

    // Construire la commande pour exécuter le compilateur
    snprintf(command, sizeof(command), "../src/temp/draw_compiler ../home/%s ../home/draw.py", filename);

    // Exécuter la commande du compilateur
    int result = system(command);
    if (result != 0) {
        printf("Erreur lors de l'exécution de la commande (code : %d)\n", result);
        return;
    } else {
        printf("Commande exécutée avec succès\n");
    }

    // Vérifier si l'environnement virtuel existe, sinon le créer et installer pygame
    if (!is_pygame_installed()) {
        printf("Création de l'environnement virtuel et installation de pygame...\n");

        // Créer l'environnement virtuel
        if (system("python3 -m venv myenv") != 0) {
            printf("Erreur lors de la création de l'environnement virtuel\n");
            return;
        }

        // Installer pygame dans l'environnement virtuel
        if (system("./myenv/bin/pip install pygame") != 0) {
            printf("Erreur lors de l'installation de pygame\n");
            return;
        }
    } else {
        printf("Pygame déjà installé dans l'environnement virtuel.\n");
    }

    // Construire la commande pour exécuter draw.py avec l'interpréteur de l'environnement virtuel
    snprintf(command, sizeof(command), "./myenv/bin/python3 ../home/draw.py");

    // Exécuter le fichier draw.py
    result = system(command);
    if (result != 0) {
        printf("Erreur lors de l'exécution du script Python draw.py (code : %d)\n", result);
    } else {
        printf("Script Python exécuté avec succès\n");
    }
}


/* Fonction pour initialiser l'interface de l'éditeur */
//int start_text_editor(int argc, char *argv[]) {  // Changé de main à start_text_editor
int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    /* Définir la fenêtre principale */
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);

    /* Définir le titre initial de la fenêtre */
    update_window_title(window);
    gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);

    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_container_add(GTK_CONTAINER(window), vbox);

    /* Création d'une hbox pour les boutons en haut */
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 5);

    /* Boutons d'ouverture et d'enregistrement */
    GtkWidget *open_button = gtk_button_new_with_label("Ouvrir");
    g_signal_connect(open_button, "clicked", G_CALLBACK(open_file), window);
    gtk_box_pack_start(GTK_BOX(hbox), open_button, FALSE, FALSE, 0);

    GtkWidget *save_button = gtk_button_new_with_label("Enregistrer");
    g_signal_connect(save_button, "clicked", G_CALLBACK(save_file), window);
    gtk_box_pack_start(GTK_BOX(hbox), save_button, FALSE, FALSE, 5);

    GtkWidget *exec_button = gtk_button_new_with_label("Executer");
    g_signal_connect(exec_button, "clicked", G_CALLBACK(execute), window);
    gtk_box_pack_start(GTK_BOX(hbox), exec_button, FALSE, FALSE, 0);

    /* Ajoute la hbox avec les boutons en haut du vbox */
    gtk_box_pack_start(GTK_BOX(vbox), hbox, FALSE, FALSE, 5);

    /* TextView pour éditer du texte */
    text_view = gtk_text_view_new();
    text_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));
    gtk_box_pack_start(GTK_BOX(vbox), text_view, TRUE, TRUE, 0);

    /* Signal pour fermer la fenêtre */
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show_all(window);
    gtk_main();
    return 0;
}