//I made it so that to switch modes, you input ':' character and then type in the mode. Ex: ":calc" or ":todo" or ":quit"
//Sort of a vim style application

#include <ncurses.h>
#include <string.h>

enum State {
    MAIN_MENU,
    COMMAND_MODE,
    CALCULATOR,
    TODO_LIST,
    EXIT
};

void get_command(char* command) {
    int rows, cols;
    getmaxyx(stdscr, rows, cols);
    move(rows - 1, 0);
    clrtoeol();
    printw(":");
    refresh();

    move(rows - 1, 2);
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
                clear();
                printw("Main Menu:\n");
                printw("Press ':' to enter Command Mode.\n");
                printw("Available commands: ':calc' for Calculator, ':todo' for To-Do List, ':quit' to exit.\n");
                refresh();

                int ch = getch(); // wait for a key press
                if (ch == ':') {
					echo();
                    current_state = COMMAND_MODE; // enter command Mode when ':' is pressed
                }
                break;

            case COMMAND_MODE:
                get_command(command); // get command starting with ':'

                // command processing
                if (strncmp(&command[1], "calc", 4) == 0) {
                    current_state = CALCULATOR;
                } else if (strncmp(&command[1], "todo", 4) == 0) {
                    current_state = TODO_LIST;
                } else if (strncmp(&command[1], "quit", 4) == 0) {
                    current_state = EXIT;
                } else {
                    printw("Unknown command. Please use ':calc', ':todo', or ':quit'.\n");
                    refresh();
                    getch(); //press any key to return to main menu mode
                }

                memset(command, 0, sizeof(command));

                current_state = MAIN_MENU;
                break;

            case CALCULATOR:
                clear();
                printw("Calculator Mode: Perform your calculations here.\n");
                printw("Press any key to return to the main menu.\n");
                refresh();
                getch(); 
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
