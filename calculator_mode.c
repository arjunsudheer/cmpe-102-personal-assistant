#include <ncurses.h>
#include <string.h>
#include "expression_evaluator.h"

void calculator_mode() {
    char input[1000];
    int rows, cols;
    int current_line = 2;
    getmaxyx(stdscr, rows, cols);

    while (1) {
        memset(input, 0, sizeof(input)); //clear input

        move(current_line, 0);
        clrtoeol();
        printw(">>");
        refresh();

        move(current_line, 3);
        getstr(input);

        if (strncmp(input, "quit", 5) == 0) {
            break;
        } 

        // Move to the next line for the "output"
        current_line++;
        move(current_line, 0);
        clrtoeol();

        double result = evaluateExpression(input);
        printw("%.5f", result); // Display the result with 5 decimal places
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
