#include <assert.h>
#include <gtk/gtk.h>
#include <stdlib.h>

#define BASE 10

static int find_nearest_power(long long num)
{
    int pow = 0;
    long long n = 1;
    while (n < num)
    {
        n *= 2;
        ++pow;
    }

    return pow;
}

static void on_dialog_response(GtkDialog *dialog, gint response_id, gpointer user_data)
{
    gtk_widget_destroy(GTK_WIDGET(dialog));
}

static void calc_and_display_pow(GtkWidget *widget, gpointer data)
{
    const gchar *text = gtk_entry_get_text(GTK_ENTRY(data));
    if (text && *text)
    {
        char *endptr;
        long long num = strtoll(text, &endptr, BASE);
        if (*endptr != '\0')
        {
            GtkWidget *msg_dialog = gtk_message_dialog_new(NULL, 
                GTK_DIALOG_MODAL, 
                GTK_MESSAGE_ERROR, 
                GTK_BUTTONS_OK, 
                "Ошибка ввода!\nРазрешены только целые числа.");
            gtk_window_set_title(GTK_WINDOW(msg_dialog), "Ошибка");
            g_signal_connect(msg_dialog, "response", G_CALLBACK(on_dialog_response), NULL);
            gtk_widget_show_all(msg_dialog);
            return;
        }

        int pow = find_nearest_power(num);
        GtkWidget *msg_dialog = gtk_message_dialog_new(NULL, 
            GTK_DIALOG_MODAL, 
            GTK_MESSAGE_INFO, 
            GTK_BUTTONS_OK, 
            "Ближайшая степень двойки ≥ %lld:\n2^%d = %lld", num, pow, (1LL << pow));
        gtk_window_set_title(GTK_WINDOW(msg_dialog), "Результат");
        g_signal_connect(msg_dialog, "response", G_CALLBACK(on_dialog_response), NULL);
        gtk_widget_show_all(msg_dialog);
    }
    else
    {
        GtkWidget *msg_dialog = gtk_message_dialog_new(NULL, 
            GTK_DIALOG_MODAL, 
            GTK_MESSAGE_ERROR, 
            GTK_BUTTONS_OK, 
            "Пожалуйста, введите число");
        gtk_window_set_title(GTK_WINDOW(msg_dialog), "Ошибка");
        g_signal_connect(msg_dialog, "response", G_CALLBACK(on_dialog_response), NULL);
        gtk_widget_show_all(msg_dialog);
    }
}

static void activate(GtkApplication *app, gpointer user_data)
{
    (void)user_data;
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Калькулятор степеней двойки");
    gtk_window_set_default_size(GTK_WINDOW(window), 300, 150);
    gtk_container_set_border_width(GTK_CONTAINER(window), 10);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_widget_destroyed), &window);

    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 10);
    gtk_grid_set_column_spacing(GTK_GRID(grid), 10);
    
    GtkWidget *label = gtk_label_new("Введите число:");
    GtkWidget *text_entry = gtk_entry_new();
    gtk_entry_set_placeholder_text(GTK_ENTRY(text_entry), "Например: 42");
    
    GtkWidget *button = gtk_button_new_with_label("Вычислить степень");
    gtk_widget_set_halign(button, GTK_ALIGN_END);
    gtk_widget_set_hexpand(button, TRUE);

    gtk_container_add(GTK_CONTAINER(window), grid);

    gtk_grid_attach(GTK_GRID(grid), label, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), text_entry, 0, 1, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), button, 0, 2, 1, 1);

    g_signal_connect(button, "clicked", G_CALLBACK(calc_and_display_pow), text_entry);

    gtk_widget_show_all(window);
}

int main(int argc, char **argv)
{
    GtkApplication *app;
    int status;

    app = gtk_application_new("org.gtk.example", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
