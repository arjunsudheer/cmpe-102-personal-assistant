#include <ncurses.h>
#include <string.h>

void calculator_mode() {
    char input[256];
    int rows, cols;
    int current_line = 2;
    getmaxyx(stdscr, rows, cols);

    while (1) {
        move(current_line, 0);
        clrtoeol();
        printw(">>");
        refresh();

        move(current_line, 3);
        getstr(input);

        if (strncmp(input, "quit", 5) == 0) {
            break;
        } else {
            /*
                THIS IS WHERE ARITHMETIC EXPRESSION WILL BE PARRSED AND RESLUT WILL BE CALCULATED
                ALGORITHM: Shunting Yard
                ASSEMBLY CALLS
            */
        }

        // Move to the next line for the "output"
        current_line++;
        move(current_line, 0);
        clrtoeol();
        printw("%s", "Result");
        refresh();

        // Increment to the next line for the next input
        current_line++;

        // If screen is full, then clear
        if (current_line >= rows - 1) {
            clear();
            current_line = 0; 
            refresh();
        }
    }

    clear();
}
