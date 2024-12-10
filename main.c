#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shunting_yard.h"

#define MAX_INPUT 256

int main() {
    char input[MAX_INPUT];

    printf("Simple Calculator\n");
    printf("Enter mathematical expressions or type 'quit' to exit.\n\n");

    while (1) {
        printf(">> ");
        if (!fgets(input, MAX_INPUT, stdin)) {
            break; // Exit on EOF
        }

        // Remove newline character if present
        input[strcspn(input, "\n")] = '\0';

        // Exit condition
        if (strcmp(input, "quit") == 0) {
            break;
        }

        // Evaluate the expression
        double result = evaluateExpression(input);
        printf("= %.5f\n", result);
    }

    printf("Goodbye!\n");
    return 0;
}
