%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_NUMBERS 100

int pos_int = 0, neg_int = 0;
int pos_frac = 0, neg_frac = 0;
int empty_line_count = 0;

char pos_int_list[MAX_NUMBERS][50];
char neg_int_list[MAX_NUMBERS][50];
char pos_frac_list[MAX_NUMBERS][50];
char neg_frac_list[MAX_NUMBERS][50];

void add_number(char list[][50], int *count, const char *text) {
    if (*count < MAX_NUMBERS) {
        strncpy(list[*count], text, 49);
        list[*count][49] = '\0'; 
        (*count)++;
    }
}

int is_float(const char *text) {   
    while (*text) {
        if (*text == '.' || tolower(*text) == 'e') {
            return 1;
        }
        text++;
    }
    return 0;
}

void print_results() {
    printf("\nFound positive integers (%d): ", pos_int);
    for (int i = 0; i < pos_int; i++) {
        printf("%s%s", pos_int_list[i], (i < pos_int-1) ? ", " : "");
    }
    
    printf("\nFound negative integers (%d): ", neg_int);
    for (int i = 0; i < neg_int; i++) {
        printf("%s%s", neg_int_list[i], (i < neg_int-1) ? ", " : "");
    }
    
    printf("\nFound positive fractions (%d): ", pos_frac);
    for (int i = 0; i < pos_frac; i++) {
        printf("%s%s", pos_frac_list[i], (i < pos_frac-1) ? ", " : "");
    }
    
    printf("\nFound negative fractions (%d): ", neg_frac);
    for (int i = 0; i < neg_frac; i++) {
        printf("%s%s", neg_frac_list[i], (i < neg_frac-1) ? ", " : "");
    }
    
    printf("\n\n=== Summary Count ===\n");
    printf("Positive integers: %d\n", pos_int);
    printf("Negative integers: %d\n", neg_int);
    printf("Positive fractions: %d\n", pos_frac);
    printf("Negative fractions: %d\n", neg_frac);
}

void reset_counters() {
    pos_int = neg_int = pos_frac = neg_frac = 0;
}
%}

DIGIT    [0-9]
SIGN     [+-]
INT      {SIGN}?{DIGIT}+
FRAC     {SIGN}?({DIGIT}*\.{DIGIT}+|{DIGIT}+\.{DIGIT}*)
EXP      [eE]{SIGN}?{DIGIT}+
NUMBER   {SIGN}?({DIGIT}+|{FRAC}){EXP}?

%%
{NUMBER} {
    empty_line_count = 0;
    char *p = yytext + strlen(yytext) - 1;
    while (p >= yytext && !isdigit(*p)) {
        *p-- = '\0';
    }

    if (is_float(yytext)) {
        if (yytext[0] == '-') {
            add_number(neg_frac_list, &neg_frac, yytext);
        } else {
            add_number(pos_frac_list, &pos_frac, yytext);
        }
    } else {
        if (yytext[0] == '-') {
            add_number(neg_int_list, &neg_int, yytext);
        } else {
            add_number(pos_int_list, &pos_int, yytext);
        }
    }
}

\n       {
    if (pos_int + neg_int + pos_frac + neg_frac == 0) {
        empty_line_count++;
        if (empty_line_count >= 2) {
            printf("\nExiting program...\n");
            return 0;
        }
    } else {
        print_results();
        reset_counters();
    }
}

.        ; 
%%

int main() {
    printf("==== Number Classifier ====\n");
    printf("Enter numbers separated by spaces or newlines.\n");
    printf("Press Enter twice to exit.\n\n");
    printf("Sample input: 23 -45 6.7 8e-2 -9.0\n\n");
    
    yylex();
    
    printf("\nProgram ended. Thank you!\n");
    return 0;
}
