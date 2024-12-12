#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shunting_yard.h"

#define MAX_INPUT 256

int main() {
    char input[MAX_INPUT];

    printf("Enter mathematical expressions or type 'quit' to exit.\n\n");

    while (1) {
        printf(">> ");
        if (!fgets(input, MAX_INPUT, stdin)) {
            break; 
        }

        input[strcspn(input, "\n")] = '\0';

        if (strcmp(input, "quit") == 0) {
            break;
        }

        // Evaluate
        double result = evaluateExpression(input);
        printf("= %.5f\n", result);
    }

    printf("Goodbye!\n");
    return 0;
}
