//I made it so that to switch modes, you input ':' character and then type in the mode. Ex: ":calc" or ":todo" or ":quit"
//Sort of a vim style application

#include <ncurses.h>
#include <string.h>
#include "calculator_mode.h"

enum State {
    MAIN_MENU,
    COMMAND_MODE,
    CALCULATOR,
    TODO_LIST,
    EXIT
};

// Will move cursor to the bottom of the screen, displaying ':', waiting for command to be entered 
void get_command(char* command) {
    int rows, cols;
    getmaxyx(stdscr, rows, cols);
    move(rows - 1, 0);
    clrtoeol();
    printw(":");
    refresh();

    move(rows - 1, 1);
    getstr(command);
}

int main() {
    enum State current_state = MAIN_MENU;
    char command[100];
    
    initscr();
    raw();
    keypad(stdscr, TRUE);
	noecho();

    while (current_state != EXIT) {
        switch (current_state) {
            case MAIN_MENU:
                noecho();
                clear();
                printw("Main Menu\n");
                printw("Press ':' to enter Command Mode\n\n");
                printw("Available commands\n':calc' for Calculator\n':todo' for To-Do List\n':quit' to exit.\n");
                refresh();

                int ch = getch(); // wait for a key press
                if (ch == ':') {
					echo();
                    current_state = COMMAND_MODE; // enter command Mode when ':' is pressed
                } else {
                    // Ignore input that is not ':'
                }
                break;

            case COMMAND_MODE:
                get_command(command); // get command starting with ':'

                // command processing
                if (strncmp(&command[0], "calc", 4) == 0) {
                    current_state = CALCULATOR;
                } else if (strncmp(&command[0], "todo", 4) == 0) {
                    current_state = TODO_LIST;
                } else if (strncmp(&command[0], "quit", 4) == 0) {
                    current_state = EXIT;
                    break;
                } else {
                    printw("Unknown command. Please use ':calc', ':todo', or ':quit'.\n");
                    refresh();
                    getch(); //press any key to return to main menu mode
                    current_state = MAIN_MENU;

                }

                memset(command, 0, sizeof(command));
                break;

            case CALCULATOR:
                clear();
                printw("Calculator Mode: Perform your calculations here.\n");
                printw("Press any key to return to the main menu.\n");
                refresh();
                calculator_mode();
                current_state = MAIN_MENU;
                break;

            case TODO_LIST:
                clear();
                printw("To-Do List Mode: Manage your tasks here.\n");
                printw("Press any key to return to the main menu.\n");
                refresh();
                getch(); 
                current_state = MAIN_MENU;
                break;
        }
    }

    endwin();
    return 0;
}
