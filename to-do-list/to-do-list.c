#include <stdio.h>
#include <stdint.h>
#include <string.h>

// Get a 64-bit integer from the user
int64_t get64BitInt(int64_t *a) {
    if (scanf("%ld", a) == 1) {
        return *a;
    }
    return 0;  // Return 0 if input fails
}

// Get a 32-bit integer from the user
int32_t get32BitInt(int32_t *a) {
    if (scanf("%d", a) == 1) {
        return *a;
    }
    return 0;  // Return 0 if input fails
}

// Get a string from the user with buffer overflow protection
int getString(char *buffer, int maxLength) {
    if (fgets(buffer, maxLength, stdin) != NULL) {
        // Remove trailing newline, if present
        char *newline = strchr(buffer, '\n');
        if (newline) {
            *newline = '\0';
        } else {
            // Clear the input buffer if input exceeded maxLength
            int c;
            while ((c = getchar()) != '\n' && c != EOF) {
                // Do nothing, just clear the input buffer
            }
        }
        return strlen(buffer);  // Return the length of the string
    }
    return -1;  // Return -1 if input fails
}

// Print a string
void printStr(const char *str) {
    printf("%s", str);  // Removed newline to make it more flexible
}

// Print an integer
void printInt(int64_t value) {
    printf("Ans: %ld\n", value);
}

