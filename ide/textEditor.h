#ifndef TEXT_EDITOR_H
#define TEXT_EDITOR_H

#include <gtk/gtk.h>
#include <vte/vte.h>
// Déclaration des variables globales comme externes
extern GtkWidget *text_view;
extern GtkTextBuffer *text_buffer;
extern char *filePath;
extern char *filename;

// Prototypes des fonctions
void update_window_title(GtkWidget *window);
void open_file(GtkWidget *widget, gpointer window);
void save_file(GtkWidget *widget, gpointer window);
int is_pygame_installed(void);
void execute(void);
int start_text_editor(int argc, char *argv[]);

#endif // TEXT_EDITOR_H