%{
#include <stdio.h>
#include <string.h>

int is_c = 0;
int is_cpp = 0;
int is_java = 0;
%}

%option noyywrap

%%

^"#include"[ \t]*"<(stdio.h|stdlib.h|string.h)>" {
    is_c = 1;
}

^"#include"[ \t]*"<(iostream|vector|string)>" {
    is_cpp = 1;
}

^"using"[ \t]+"namespace"[ \t]+"std" {
    is_cpp = 1;
}

^"import"[ \t]+"java\\." {
    is_java = 1;
}

"int"[ \t]+"main"[ \t]*"\(" {
    if (!is_java) is_c = 1;
}

"public"[ \t]+"static"[ \t]+"void"[ \t]+"main"[ \t]*"\(" {
    is_java = 1;
}

"class"[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*"{" {
    if (!is_c && !is_cpp) is_java = 1;
}

"//".*             
"/\\*"([^*]|\*+[^*/])"*\*+/" 
[ \t\n]+          
.                  

%%

int main() {
    FILE *file = fopen("test_input.txt", "r");
    if (!file) {
       perror("Unable to open test_input.txt");
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);

    if (is_java) {
        printf("This appears to be a Java program.\n");
    } else if (is_cpp) {
        printf("This appears to be a C++ program.\n");
    } else if (is_c) {
        printf("This appears to be a C program.\n");
    } else {
        printf("Could not determine the language. Not a recognized C, C++, or Java program.\n");
    }

    return 0;
}
