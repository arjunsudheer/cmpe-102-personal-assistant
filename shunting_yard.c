#include "shunting_yard.h"

// Global variables for RPN evaluation
static char outputQueue[MAX_STACK_SIZE][MAX_TOKEN_LENGTH];
static int outputQueueTop = 0;

static char operatorStack[MAX_STACK_SIZE][MAX_TOKEN_LENGTH];
static int operatorStackTop = -1;

// Utility function prototypes
static TokenList tokenize(const char *input);
static void processToken(const char *token);
static void finalizeOutputQueue();
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
static void processParenthesis(const char *token);
static void processOperator(const char *operator);
static void tokenizeUnaryMinus(TokenList *result, const char *input, int *i);

// Evaluate the expression from input
double evaluateExpression(const char *input) {
    // Reset global variables
    outputQueueTop = 0;
    operatorStackTop = -1;

    // Tokenize the input
    TokenList tokens = tokenize(input);

    // Process each token
    for (int i = 0; i < tokens.count; i++) {
        processToken(tokens.tokens[i]);
    }

    // Finalize the RPN output queue
    finalizeOutputQueue();

    // Evaluate the RPN expression
    return evaluateRPN(outputQueue, outputQueueTop);
}


// Implementation of other internal functions (unchanged from your provided code)
// Push to Output Queue
void pushToOutputQueue(const char *token) {
    strcpy(outputQueue[outputQueueTop++], token);
}

// Push to Operator Stack
void pushToOperatorStack(const char *token) {
    strcpy(operatorStack[++operatorStackTop], token);
}

// Pop from Operator Stack
char* popFromOperatorStack() {
    return operatorStack[operatorStackTop--];
}

// Peek at the top of the Operator Stack
char* peekOperatorStack() {
    return operatorStack[operatorStackTop];
}

// Precedence and associativity functions
int getPrecedence(const char *op) {
    if (strcmp(op, "(") == 0 || strcmp(op, ")") == 0) return 0;
    if (strcmp(op, "sin") == 0 || strcmp(op, "cos") == 0 || strcmp(op, "tan") == 0 ||
        strcmp(op, "ln") == 0 || strcmp(op, "sqrt") == 0) return 4;
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

// Check if a token is a function
int isFunction(const char *token) {
    return strcmp(token, "sin") == 0 || strcmp(token, "cos") == 0 ||
           strcmp(token, "tan") == 0 || strcmp(token, "ln") == 0 ||
           strcmp(token, "sqrt") == 0;
}

// Check if a token is a number
int isNumber(const char *token) {
    if (token[0] == '-' && isdigit(token[1])) return 1; // Negative numbers
    return isdigit(token[0]);
}

// Convert token to number
double toNumber(const char *token) {
    return atof(token);
}

// Process operators
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

// Process parentheses
void processParenthesis(const char *token) {
    if (strcmp(token, "(") == 0) {
        pushToOperatorStack(token);
    } else if (strcmp(token, ")") == 0) {
        while (operatorStackTop >= 0 && strcmp(peekOperatorStack(), "(") != 0) {
            pushToOutputQueue(popFromOperatorStack());
        }
        if (operatorStackTop < 0) {
            printf("Error: Mismatched parentheses\n");
            exit(EXIT_FAILURE);
        }
        popFromOperatorStack();
        if (operatorStackTop >= 0 && isFunction(peekOperatorStack())) {
            pushToOutputQueue(popFromOperatorStack());
        }
    }
}

// Process token
void processToken(const char *token) {
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
        exit(EXIT_FAILURE);
    }
}

// Finalize the output queue
void finalizeOutputQueue() {
    while (operatorStackTop >= 0) {
        char *top = popFromOperatorStack();
        if (strcmp(top, "(") == 0) {
            printf("Error: Mismatched parentheses\n");
            exit(EXIT_FAILURE);
        }
        pushToOutputQueue(top);
    }
}

// Tokenize unary minus
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

// Tokenizer
TokenList tokenize(const char *input) {
    TokenList result = {.count = 0};
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
            exit(EXIT_FAILURE);
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
            // Push numbers to the stack
            stack[++stackTop] = toNumber(token);
        } else if (strcmp(token, "-u") == 0 || strcmp(token, "!") == 0) {
            // Handle unary operators
            if (stackTop < 0) {
                printf("Error: Insufficient operand for operator '%s'\n", token);
                exit(EXIT_FAILURE);
            }
            double operand = stack[stackTop--];
            stack[++stackTop] = applyUnaryOperator(token, operand);
        } else if (strchr("+-*/%^", token[0]) || strcmp(token, "^") == 0) {
            // Handle binary operators
            if (stackTop < 1) {
                printf("Error: Insufficient operands for operator '%s'\n", token);
                exit(EXIT_FAILURE);
            }
            double operand2 = stack[stackTop--];
            double operand1 = stack[stackTop--];
            stack[++stackTop] = applyOperator(token, operand1, operand2);
        } else if (isFunction(token)) {
            // Handle functions
            if (stackTop < 0) {
                printf("Error: Insufficient operand for function '%s'\n", token);
                exit(EXIT_FAILURE);
            }
            double operand = stack[stackTop--];
            stack[++stackTop] = applyFunction(token, operand);
        } else {
            printf("Error: Unknown token '%s'\n", token);
            exit(EXIT_FAILURE);
        }
    }

    // Final result
    if (stackTop != 0) {
        printf("Error: Invalid RPN expression\n");
        exit(EXIT_FAILURE);
    }
    return stack[stackTop];
}


// Apply basic operations
double applyOperator(const char *op, double operand1, double operand2) {
    if (strcmp(op, "+") == 0) return operand1 + operand2;
    if (strcmp(op, "-") == 0) return operand1 - operand2;
    if (strcmp(op, "*") == 0) return operand1 * operand2;
    if (strcmp(op, "/") == 0) return operand1 / operand2;
    if (strcmp(op, "%") == 0) return fmod(operand1, operand2);
    if (strcmp(op, "^") == 0) return pow(operand1, operand2);
    printf("Error: Unknown operator '%s'\n", op);
    exit(EXIT_FAILURE);
}

// Apply unary operators
double applyUnaryOperator(const char *op, double operand) {
    if (strcmp(op, "-u") == 0) return -operand;
    if (strcmp(op, "!") == 0) {
        if (operand < 0 || operand != (int)operand) {
            printf("Error: Factorial is only defined for non-negative integers\n");
            exit(EXIT_FAILURE);
        }
        double result = 1;
        for (int i = 1; i <= (int)operand; i++) result *= i;
        return result;
    }
    printf("Error: Unknown unary operator '%s'\n", op);
    exit(EXIT_FAILURE);
}

// Apply functions
double applyFunction(const char *func, double operand) {
    if (strcmp(func, "sin") == 0) return sin(operand);
    if (strcmp(func, "cos") == 0) return cos(operand);
    if (strcmp(func, "tan") == 0) return tan(operand);
    if (strcmp(func, "ln") == 0) return log(operand);
    if (strcmp(func, "sqrt") == 0) return sqrt(operand);
    printf("Error: Unknown function '%s'\n", func);
    exit(EXIT_FAILURE);
}