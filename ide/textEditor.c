#include <gtk/gtk.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <vte/vte.h>
#include <unistd.h>
#include <fcntl.h>
#include "textEditor.h"

/* Variables globales pour stocker les widgets */
GtkWidget *text_view;
GtkTextBuffer *text_buffer;
GtkWidget *terminal;
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
    if (filePath != NULL) {
        /* Sauvegarde rapide dans le fichier existant */
        GtkTextIter start, end;
        gtk_text_buffer_get_bounds(text_buffer, &start, &end);
        gchar *text = gtk_text_buffer_get_text(text_buffer, &start, &end, FALSE);

        if (g_file_set_contents(filePath, text, -1, NULL)) {
            /* Mise à jour du titre de la fenêtre si nécessaire */
            update_window_title(window);
        } else {
            g_print("Erreur lors de la sauvegarde dans %s.\n", filePath);
        }
        g_free(text);
        return;
    }

    /* Si aucun fichier n'est ouvert, ouvrir le dialogue pour choisir un chemin */
    GtkWidget *dialog = gtk_file_chooser_dialog_new("Enregistrer le fichier", GTK_WINDOW(window),
                                                    GTK_FILE_CHOOSER_ACTION_SAVE, "Annuler", GTK_RESPONSE_CANCEL,
                                                    "Enregistrer", GTK_RESPONSE_ACCEPT, NULL);

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {
        GtkFileChooser *chooser = GTK_FILE_CHOOSER(dialog);
        gchar *save_path = gtk_file_chooser_get_filename(chooser);

        GtkTextIter start, end;
        gtk_text_buffer_get_bounds(text_buffer, &start, &end);
        gchar *text = gtk_text_buffer_get_text(text_buffer, &start, &end, FALSE);

        if (g_file_set_contents(save_path, text, -1, NULL)) {
            /* Met à jour le fichier actuel */
            g_free(filePath);
            filePath = g_strdup(save_path);

            /* Met à jour le nom du fichier */
            g_free(filename);
            filename = g_path_get_basename(filePath);

            /* Met à jour le titre de la fenêtre */
            update_window_title(window);
        } else {
            g_print("Erreur lors de la sauvegarde dans %s.\n", save_path);
        }

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
    if (filePath == NULL) {
        const char *message = "Erreur : filePath est NULL\n\r";
        vte_terminal_feed(VTE_TERMINAL(terminal), message, strlen(message));
        return;
    }


    char command[512];
    char command2[512];

    // Commande pour compiler
    snprintf(command, sizeof(command), "../src/temp/draw_compiler ../home/%s ../home/draw.py 10\n", filename);
    vte_terminal_feed_child(VTE_TERMINAL(terminal), command, strlen(command));

    // Créer l'environnement virtuel si nécessaire
    if (!is_pygame_installed()) {
        // Commande de création de l'environnement virtuel
        snprintf(command, sizeof(command), "python3 -m venv myenv\n");
        vte_terminal_feed_child(VTE_TERMINAL(terminal), command, strlen(command));

        // Commande d'installation de pygame
        snprintf(command, sizeof(command), "./myenv/bin/pip install pygame\n");
        vte_terminal_feed_child(VTE_TERMINAL(terminal), command, strlen(command));
    }

    // Commande pour exécuter draw.py
    snprintf(command2, sizeof(command2), "./myenv/bin/python3 ../home/draw.py\n");
    vte_terminal_feed_child(VTE_TERMINAL(terminal), command2, strlen(command2));
}

/* Fonction pour gérer les raccourcis clavier */
void on_key_press(GtkWidget *widget, GdkEventKey *event, gpointer user_data) {
    if ((event->state & GDK_CONTROL_MASK) && event->keyval == GDK_KEY_s) {
        /* Appelle la fonction save_file pour Ctrl+S */
        save_file(widget, user_data);
    }
    else if ((event->state & GDK_CONTROL_MASK) &&
            (event->keyval == GDK_KEY_KP_Enter || event->keyval == GDK_KEY_Return)) {
        execute();
    }
    else if (event->keyval == GDK_KEY_Escape) {
        gtk_main_quit(); // Cela termine le programme GTK
    }
    // Raccourci pour exécuter directement le script draw.py
    else if ((event->state & GDK_CONTROL_MASK) && event->keyval == GDK_KEY_x) {
        char commandX[512];
        snprintf(commandX, sizeof(commandX), "../src/temp/draw_compiler ../home/my_draw.draw ../home/draw.py && ./myenv/bin/python3 ../home/draw.py & \n");
        vte_terminal_feed_child(VTE_TERMINAL(terminal), commandX, strlen(commandX));
    }
}

/* Fonction pour colorer les lignes commençant par '#' */
void highlight_comments() {
    GtkTextIter start, end;
    gtk_text_buffer_get_start_iter(text_buffer, &start);
    gtk_text_buffer_get_end_iter(text_buffer, &end);

    // Supprime d'abord les anciens tags
    gtk_text_buffer_remove_tag_by_name(text_buffer, "comment", &start, &end);

    GtkTextIter line_start, line_end;
    gtk_text_buffer_get_start_iter(text_buffer, &line_start);
    do {
        gtk_text_iter_forward_to_line_end(&line_start);
        line_end = line_start;

        // Vérifie si la ligne commence par '#'
        GtkTextIter line_begin = line_start;
        gtk_text_iter_set_line_offset(&line_begin, 0);
        gchar *line_text = gtk_text_buffer_get_text(text_buffer, &line_begin, &line_end, FALSE);
        if (line_text[0] == '#') {
            gtk_text_buffer_apply_tag_by_name(text_buffer, "comment", &line_begin, &line_end);
        }
        g_free(line_text);

    } while (gtk_text_iter_forward_line(&line_start));
}

/* Configuration des tags pour le texte */
void setup_text_tags() {
    GtkTextTagTable *tag_table = gtk_text_buffer_get_tag_table(text_buffer);
    GtkTextTag *comment_tag = gtk_text_tag_new("comment");
    g_object_set(comment_tag, "foreground", "green", NULL); // Texte vert
    gtk_text_tag_table_add(tag_table, comment_tag);
}

/* Mise à jour pour détecter les changements de texte */
void setup_highlighting() {
    setup_text_tags();
    g_signal_connect(text_buffer, "changed", G_CALLBACK(highlight_comments), NULL);
}

/* Fonction pour initialiser l'interface de l'éditeur */
int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    /* Définir la fenêtre principale */
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);

    /* Définir le titre initial de la fenêtre */
    update_window_title(window);
    gtk_window_set_default_size(GTK_WINDOW(window), 900, 750);

    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_container_add(GTK_CONTAINER(window), vbox);

    /* Création d'une hbox pour les boutons en haut */
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 5);

    /* Bouton ouvrir */
    GtkWidget *open_button = gtk_button_new();
    GtkWidget *open_image = gtk_image_new_from_icon_name("document-open", GTK_ICON_SIZE_BUTTON);
    gtk_button_set_image(GTK_BUTTON(open_button), open_image);
    gtk_button_set_label(GTK_BUTTON(open_button), "Ouvrir");
    gtk_button_set_always_show_image(GTK_BUTTON(open_button), TRUE);
    g_signal_connect(open_button, "clicked", G_CALLBACK(open_file), window);
    gtk_box_pack_start(GTK_BOX(hbox), open_button, FALSE, FALSE, 7);

    /* Bouton enregistrer */
    GtkWidget *save_button = gtk_button_new();
    GtkWidget *save_image = gtk_image_new_from_icon_name("document-save", GTK_ICON_SIZE_BUTTON);
    gtk_button_set_image(GTK_BUTTON(save_button), save_image);
    gtk_button_set_label(GTK_BUTTON(save_button), "Enregistrer");
    gtk_button_set_always_show_image(GTK_BUTTON(save_button), TRUE);
    g_signal_connect(save_button, "clicked", G_CALLBACK(save_file), window);
    gtk_box_pack_start(GTK_BOX(hbox), save_button, FALSE, FALSE, 2);

    /* Bouton executer */
    GtkWidget *exec_button = gtk_button_new();
    GtkWidget *image = gtk_image_new_from_icon_name("media-playback-start", GTK_ICON_SIZE_BUTTON);
    gtk_button_set_image(GTK_BUTTON(exec_button), image);
    gtk_button_set_label(GTK_BUTTON(exec_button), "Exécuter");
    gtk_button_set_always_show_image(GTK_BUTTON(exec_button), TRUE);

    g_signal_connect(exec_button, "clicked", G_CALLBACK(execute), window);
    gtk_box_pack_start(GTK_BOX(hbox), exec_button, FALSE, FALSE, 5);

    /* Connecte l'événement pour gérer les Ctrl*/
    g_signal_connect(window, "key-press-event", G_CALLBACK(on_key_press), window);

    /* Ajoute la hbox avec les boutons en haut du vbox */
    gtk_box_pack_start(GTK_BOX(vbox), hbox, FALSE, FALSE, 7);

    /* ScrolledWindow pour permettre le défilement vertical */
    GtkWidget *scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    gtk_box_pack_start(GTK_BOX(vbox), scrolled_window, TRUE, TRUE, 0);

    /* TextView pour éditer du texte */
    text_view = gtk_text_view_new();
    gtk_text_view_set_left_margin(GTK_TEXT_VIEW(text_view), 5);
    text_buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_view));
    gtk_container_add(GTK_CONTAINER(scrolled_window), text_view);

    /* Initialiser les tags et activer le surlignage */
    setup_highlighting();

    /* Création du terminal VTE */
    terminal = vte_terminal_new();
    vte_terminal_set_size(VTE_TERMINAL(terminal), 80, 24);

    /* Ajout du terminal dans un ScrolledWindow */
    GtkWidget *terminal_scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(terminal_scrolled_window),
                                   GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    gtk_container_add(GTK_CONTAINER(terminal_scrolled_window), terminal);
    // Définir une hauteur fixe de 150 pixels pour le terminal
    gtk_widget_set_size_request(terminal_scrolled_window, -1, 300);

    gtk_box_pack_start(GTK_BOX(vbox), terminal_scrolled_window, FALSE, FALSE, 0);
    /* Lancement du shell parent dans le terminal VTE */
    const char *shell_argv[] = {"/bin/bash", "--norc", "-i", NULL};
    char *envp[] = {"PS1=$ ", NULL};  // Définit un prompt minimaliste

    vte_terminal_spawn_async(VTE_TERMINAL(terminal),
                             VTE_PTY_DEFAULT,
                             NULL,
                             (char **)shell_argv,
                             envp,              // Utilise notre environnement personnalisé
                             G_SPAWN_DEFAULT,
                             NULL, NULL, NULL,
                             -1,
                             NULL,
                             NULL, NULL);

    /* Signal pour fermer la fenêtre */
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show_all(window);
    gtk_main();
    return 0;
}