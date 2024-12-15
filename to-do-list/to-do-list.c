#include <stdio.h>
#include <stdint.h>
#include <string.h>

// Get a 64-bit integer from the user
int64_t get64BitInt(int64_t *a)
{
    if (scanf("%ld", a) == 1)
    {
        return *a;
    }
    // Return 0 if input fails
    return 0;
}

// Get a 32-bit integer from the user
int32_t get32BitInt(int32_t *a)
{
    if (scanf("%d", a) == 1)
    {
        return *a;
    }
    // Return 0 if input fails
    return 0;
}

void clearInputBuffer()
{
    int c;
    while ((c = getchar()) != '\n' && c != EOF)
        ;
}

// Get a string from the user with buffer overflow protection
char *getString(char *buffer, int maxLength)
{
    // Clear any leftover input in the buffer
    clearInputBuffer();

    if (fgets(buffer, maxLength, stdin) == NULL)
    {
        return NULL;
    }

    size_t len = strlen(buffer);

    // Remove trailing newline, if present
    if (len > 0 && buffer[len - 1] == '\n')
    {
        buffer[len - 1] = '\0';
    }
    else
    {
        // Clear the input buffer if input exceeded maxLength
        clearInputBuffer();
    }

    // Return the input buffer
    return buffer;
}

// Print a task in format that indicates the index
void printTask(const char *str, int index)
{
    printf("%d. %s", index + 1, str);
}

// Print an integer
void printInt(int64_t value)
{
    printf("Ans: %ld\n", value);
}
