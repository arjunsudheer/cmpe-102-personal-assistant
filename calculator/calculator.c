#include <stdio.h>
#include <stdint.h>

int64_t get64BitInt(int64_t *a)
{
    scanf("%ld", a);
    return *a;
}

int32_t get32BitInt(int32_t *a)
{
    scanf("%d", a);
    return *a;
}

double getDouble(double *a)
{
    scanf("%le", a);
    return *a;
}

void printInt(int64_t value)
{
    printf("%ld\n", value);
}

void printDouble(double value)
{
    printf("%le\n", value);
}
