%{
#include <stdio.h>
#include <string.h>

void print_token(const char* token_type, const char* lexeme) {
    printf("%-15s : %s\n", token_type, lexeme);
}
%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          {LETTER}({LETTER}|{DIGIT}|_)*
INT_LITERAL {DIGIT}+
FLOAT_LITERAL {DIGIT}+"."{DIGIT}+
WHITESPACE  [ \t\r\n]+

%%

"if"        { print_token("KEYWORD", yytext); }
"else"      { print_token("KEYWORD", yytext); }
"while"     { print_token("KEYWORD", yytext); }
"return"    { print_token("KEYWORD", yytext); }
"int"       { print_token("KEYWORD", yytext); }
"float"     { print_token("KEYWORD", yytext); }
"void"      { print_token("KEYWORD", yytext); }

"=="        { print_token("EQ_OP", yytext); }
"!="        { print_token("NE_OP", yytext); }
"<="        { print_token("LE_OP", yytext); }
">="        { print_token("GE_OP", yytext); }
"<"         { print_token("LT_OP", yytext); }
">"         { print_token("GT_OP", yytext); }
"="         { print_token("ASSIGN_OP", yytext); }
"+"         { print_token("ADD_OP", yytext); }
"-"         { print_token("SUB_OP", yytext); }
"*"         { print_token("MUL_OP", yytext); }
"/"         { print_token("DIV_OP", yytext); }

"("         { print_token("LPAREN", yytext); }
")"         { print_token("RPAREN", yytext); }
"{"         { print_token("LBRACE", yytext); }
"}"         { print_token("RBRACE", yytext); }
";"         { print_token("SEMICOLON", yytext); }
","         { print_token("COMMA", yytext); }

{FLOAT_LITERAL} { print_token("FLOAT_LITERAL", yytext); }
{INT_LITERAL}   { print_token("INT_LITERAL", yytext); }

{ID}        { print_token("IDENTIFIER", yytext); }

"//".*      
"/\*"([^*]|\*+[^*/])*\*+"/" 

{WHITESPACE}

.           { printf("UNKNOWN     : %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
