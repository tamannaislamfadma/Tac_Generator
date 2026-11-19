%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

int temp_count = 1;

char* new_temp() {
    char* temp = malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}
%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token ASSIGN PLUS MINUS MUL DIV LPAREN RPAREN NEWLINE
%type <str> expr term factor

%%

program:
    program statement NEWLINE
    | program NEWLINE
    | /* empty */
;

statement:
    ID ASSIGN expr {
        printf("%s = %s\n--------------------\n", $1, $3);
        free($1);
        free($3);
        temp_count = 1;
    }
    | expr {
        printf("result = %s\n--------------------\n", $1);
        free($1);
        temp_count = 1;
    }
;

expr:
    expr PLUS term {
        char* t = new_temp();
        printf("%s = %s + %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | expr MINUS term {
        char* t = new_temp();
        printf("%s = %s - %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | term { $$ = $1; }
;

term:
    term MUL factor {
        char* t = new_temp();
        printf("%s = %s * %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | term DIV factor {
        char* t = new_temp();
        printf("%s = %s / %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | factor { $$ = $1; }
;

factor:
    NUMBER { $$ = $1; }
    | ID { $$ = $1; }
    | LPAREN expr RPAREN { $$ = $2; }
;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    printf("--- Three Address Code ---\n\n");
    yyparse();
    return 0;
}
