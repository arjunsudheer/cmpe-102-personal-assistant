#include "shunting_yard.h"

extern double square_root(double operand);
extern double sin_main(double operand);
extern double cos_main(double operand);
extern double tan_main(double operand);
extern double logarithm_main(double operand);
extern double exponent_main(double operand1, double operand2);
extern long factorial_main(long input);
extern double floating_point_addition_main(double, double);
extern double floating_point_subtraction_main(double, double);
extern double floating_point_multiplication_main(double, double);
extern double floating_point_division_main(double, double);
extern int modulus_main(int, int);
extern int fibonacci_main(int n);

static char outputQueue[MAX_STACK_SIZE][MAX_TOKEN_LENGTH];
static int outputQueueTop = 0;

static char operatorStack[MAX_STACK_SIZE][MAX_TOKEN_LENGTH];
static int operatorStackTop = -1;

static TokenList tokenize(const char *input);
static int processToken(const char *token);
static int finalizeOutputQueue();
static double evaluateRPN(char rpn[][MAX_TOKEN_LENGTH], int rpnCount);
static void pushToOutputQueue(const char *token);
static void pushToOperatorStack(const char *token);
static char* popFromOperatorStack();
static char* peekOperatorStack();
static int getPrecedence(const char *op);
static int isRightAssociative(const char *op);
static int isFunction(const char *token);
static int isNumber(const char *token);
static double toNumber(const char *token);
static double applyOperator(const char *op, double operand1, double operand2);
static double applyUnaryOperator(const char *op, double operand);
static double applyFunction(const char *func, double operand);
static int processParenthesis(const char *token);
static void processOperator(const char *operator);
static void tokenizeUnaryMinus(TokenList *result, const char *input, int *i);

double evaluateExpression(const char *input) {
    outputQueueTop = 0;
    operatorStackTop = -1;

    TokenList tokens = tokenize(input);
    if (tokens.error) {
        printf("Error: Tokenization failed.\n");
        return NAN;
    }

    for (int i = 0; i < tokens.count; i++) {
        if (processToken(tokens.tokens[i]) < 0) {
            printf("Error: Token processing failed.\n");
            return NAN;
        }
    }

    if (finalizeOutputQueue() < 0) {
        printf("Error: Finalizing output queue failed.\n");
        return NAN;
    }

    return evaluateRPN(outputQueue, outputQueueTop);
}

void pushToOutputQueue(const char *token) {
    strcpy(outputQueue[outputQueueTop++], token);
}

void pushToOperatorStack(const char *token) {
    strcpy(operatorStack[++operatorStackTop], token);
}

char* popFromOperatorStack() {
    return operatorStack[operatorStackTop--];
}

char* peekOperatorStack() {
    return operatorStack[operatorStackTop];
}

int getPrecedence(const char *op) {
    if (strcmp(op, "(") == 0 || strcmp(op, ")") == 0) return 0;
    if (strcmp(op, "sin") == 0 || strcmp(op, "cos") == 0 || strcmp(op, "tan") == 0 ||
        strcmp(op, "ln") == 0 || strcmp(op, "sqrt") == 0 || strcmp(op, "fib") == 0) return 4;
    if (strcmp(op, "!") == 0) return 4;
    if (strcmp(op, "^") == 0) return 3;
    if (strcmp(op, "-u") == 0) return 3;
    if (strcmp(op, "*") == 0 || strcmp(op, "/") == 0 || strcmp(op, "%") == 0) return 2;
    if (strcmp(op, "+") == 0 || strcmp(op, "-") == 0) return 1;
    return -1;
}

int isRightAssociative(const char *op) {
    if (strcmp(op, "^") == 0 || strcmp(op, "-u") == 0 || strcmp(op, "!") == 0) return 1;
    return 0;
}

int isFunction(const char *token) {
    return strcmp(token, "sin") == 0 || strcmp(token, "cos") == 0 ||
           strcmp(token, "tan") == 0 || strcmp(token, "ln") == 0 ||
           strcmp(token, "sqrt") == 0 || strcmp(token, "fib") == 0;
}

int isNumber(const char *token) {
    if (token[0] == '-' && isdigit(token[1])) return 1; 
    return isdigit(token[0]);
}

double toNumber(const char *token) {
    return atof(token);
}

void processOperator(const char *operator) {
    while (operatorStackTop >= 0) {
        char *top = peekOperatorStack();
        if ((getPrecedence(top) > getPrecedence(operator)) ||
            (getPrecedence(top) == getPrecedence(operator) && !isRightAssociative(operator))) {
            pushToOutputQueue(popFromOperatorStack());
        } else {
            break;
        }
    }
    pushToOperatorStack(operator);
}

int processParenthesis(const char *token) {
    if (strcmp(token, "(") == 0) {
        pushToOperatorStack(token);
    } else if (strcmp(token, ")") == 0) {
        while (operatorStackTop >= 0 && strcmp(peekOperatorStack(), "(") != 0) {
            pushToOutputQueue(popFromOperatorStack());
        }
        if (operatorStackTop < 0) {
            printf("Error: Mismatched parentheses\n");
            return -1;
        }
        popFromOperatorStack();
        if (operatorStackTop >= 0 && isFunction(peekOperatorStack())) {
            pushToOutputQueue(popFromOperatorStack());
        }
    }
    return 0;
}

int processToken(const char *token) {
    if (isNumber(token)) {
        pushToOutputQueue(token);
    } else if (isFunction(token)) {
        pushToOperatorStack(token);
    } else if (strcmp(token, "(") == 0 || strcmp(token, ")") == 0) {
        processParenthesis(token);
    } else if (strchr("+-*/%^!", token[0]) || strcmp(token, "-u") == 0) {
        processOperator(token);
    } else {
        printf("Error: Unknown token '%s'\n", token);
        return -1;
    }
    return 0;
}

int finalizeOutputQueue() {
    while (operatorStackTop >= 0) {
        char *top = popFromOperatorStack();
        if (strcmp(top, "(") == 0) {
            printf("Error: Mismatched parentheses\n");
            return -1;
        }
        pushToOutputQueue(top);
    }
    return 0;
}

void tokenizeUnaryMinus(TokenList *result, const char *input, int *i) {
    int prevTokenIndex = result->count - 1;
    if (prevTokenIndex < 0 || strcmp(result->tokens[prevTokenIndex], "(") == 0 ||
        strchr("+-*/%^", result->tokens[prevTokenIndex][0])) {
        strcpy(result->tokens[result->count++], "-u");
    } else {
        strcpy(result->tokens[result->count++], "-");
    }
    (*i)++;
}

TokenList tokenize(const char *input) {
    TokenList result = {.count = 0, .error = 0};
    int i = 0;

    while (input[i] != '\0') {
        if (isdigit(input[i])) {
            int j = 0;
            while (isdigit(input[i]) || input[i] == '.') {
                result.tokens[result.count][j++] = input[i++];
            }
            result.tokens[result.count][j] = '\0';
            result.count++;
        } else if (isalpha(input[i])) {
            int j = 0;
            while (isalpha(input[i])) {
                result.tokens[result.count][j++] = input[i++];
            }
            result.tokens[result.count][j] = '\0';
            result.count++;
        } else if (input[i] == '-') {
            tokenizeUnaryMinus(&result, input, &i);
        } else if (strchr("+-*/%^()!", input[i])) {
            result.tokens[result.count][0] = input[i++];
            result.tokens[result.count][1] = '\0';
            result.count++;
        } else if (isspace(input[i])) {
            i++;
        } else {
            printf("Error: Invalid character '%c'\n", input[i]);
            result.error = 1;
            return result;
        }
    }
    return result;
}

double evaluateRPN(char rpn[][MAX_TOKEN_LENGTH], int rpnCount) {
    double stack[MAX_STACK_SIZE];
    int stackTop = -1;

    for (int i = 0; i < rpnCount; i++) {
        const char *token = rpn[i];

        if (isNumber(token)) {
            stack[++stackTop] = toNumber(token);
        } else if (strcmp(token, "-u") == 0 || strcmp(token, "!") == 0) {
            if (stackTop < 0) {
                printf("Error: Insufficient operand for operator '%s'\n", token);
                return NAN;
            }
            double operand = stack[stackTop--];
            stack[++stackTop] = applyUnaryOperator(token, operand);
        } else if (strchr("+-*/%^", token[0]) || strcmp(token, "^") == 0) {
            if (stackTop < 1) {
                printf("Error: Insufficient operands for operator '%s'\n", token);
                return NAN;
            }
            double operand2 = stack[stackTop--];
            double operand1 = stack[stackTop--];
            stack[++stackTop] = applyOperator(token, operand1, operand2);
        } else if (isFunction(token)) {
            // Handle functions
            if (stackTop < 0) {
                printf("Error: Insufficient operand for function '%s'\n", token);
                return NAN;
            }
            double operand = stack[stackTop--];
            stack[++stackTop] = applyFunction(token, operand);
        } else {
            printf("Error: Unknown token '%s'\n", token);
            return NAN;
        }
    }

    if (stackTop != 0) {
        printf("Error: Invalid RPN expression\n");
        return NAN;
    }
    return stack[stackTop];
}

double applyOperator(const char *op, double operand1, double operand2) {
    if (strcmp(op, "+") == 0) return operand1 + operand2; //floating_point_addition_main(operand1, operand2);
    if (strcmp(op, "-") == 0) return floating_point_subtraction_main(operand1, operand2);
    if (strcmp(op, "*") == 0) return operand1 * operand2; //floating_point_multiplication_main(operand1, operand2);
    if (strcmp(op, "/") == 0) return floating_point_division_main(operand1, operand2);
    if (strcmp(op, "%") == 0) return modulus_main(operand1, operand2);
    if (strcmp(op, "^") == 0) return exponent_main(operand1, operand2);
    printf("Error: Unknown operator '%s'\n", op);
    return NAN;
}

double applyUnaryOperator(const char *op, double operand) {
    if (strcmp(op, "-u") == 0) return -operand;
    if (strcmp(op, "!") == 0) {
        if (operand < 0 || operand != (int)operand) {
            printf("Error: Factorial is only defined for non-negative integers\n");
            return NAN;
        }
        double result = factorial_main(operand);
        return result;
    }
    printf("Error: Unknown unary operator '%s'\n", op);
    return NAN;
}

double applyFunction(const char *func, double operand) {
    if (strcmp(func, "sin") == 0) return sin_main(operand);
    if (strcmp(func, "cos") == 0) return cos_main(operand);
    if (strcmp(func, "tan") == 0) return tan_main(operand);
    if (strcmp(func, "ln") == 0) return logarithm_main(operand);
    if (strcmp(func, "sqrt") == 0) return square_root(operand);
    if (strcmp(func, "fib") == 0) {
        if ((int)operand < 0) {
            return NAN;
        }
        return fibonacci_main((int)operand);
    }

    printf("Error: Unknown function '%s'\n", func);
    return NAN;
}