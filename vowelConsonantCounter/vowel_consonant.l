%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int consonant_count = 0;
int vowe l_count = 0;

int is_vowel(char c) {
    switch(c) {
        case 'a': case 'e': case 'i': case 'o': case 'u':
        case 'A': case 'E': case 'I': case 'O': case 'U':
            return 1;
        default:
            return 0;
    }
}
%}

%%
[a-zA-Z] {
    if (is_vowel(yytext[0]))
        vowel_count++;
    else
        consonant_count++;
}
.|\n ;
%%

int yywrap() {
    return 1;
}

int main() {
    
    const char* input_code ="This is a sample input to check";
     "}";

    
    YY_BUFFER_STATE buffer = yy_scan_string(input_code);
    yylex();
    yy_delete_buffer(buffer);

    
    printf("Vowels: %d\n", vowel_count);
    printf("Consonants: %d\n", consonant_count);

    return 0;
}
