#include <ncurses.h>
#include <string.h>

void calculator_mode() {
    char input[256];
    int rows, cols;
    getmaxyx(stdscr, rows, cols);

    while (1) {
        move(rows - 2, 0);
        clrtoeol();
        printw("Enter expression: ");
        refresh();

        // move(rows - 2, 17);
        // getstr(input);

        if (strncmp(input, "quit", 5) == 0) {
            break;
        }

        // clear();
        // printw("You entered: %s\n", input);
        // printw("Processing expression in Assembly...\n");
        // refresh();

        // char result[256] = "Result from Assemblyto be implemented)";
        // printw("Result: %s\n", result);

        printw("\nPress any key to enter another expression or ':quit' to exit.\n");
        getch();
    }

    clear();
}
