#ifndef EXPRESSION_EVALUATOR_H
#define EXPRESSION_EVALUATOR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#define MAX_TOKENS 100
#define MAX_TOKEN_LENGTH 10
#define MAX_STACK_SIZE 100

typedef struct {
    char tokens[MAX_TOKENS][MAX_TOKEN_LENGTH];
    int count;
} TokenList;

// Public functions
double evaluateExpression(const char *input);

#endif
