TAC Generator - Mac/Terminal

Requirements:
- Homebrew
- Flex
- Bison
- GCC/Clang

Build:
    bison -d parser.y
    flex lexer.l
    gcc lex.yy.c parser.tab.c -o tac_gen

Run:
    ./tac_gen input.txt

If your macOS compiler complains about strdup being undeclared, try:
    gcc -D_POSIX_C_SOURCE=200809L lex.yy.c parser.tab.c -o tac_gen

The expected project pipeline is:
input.txt -> lexer.l (Flex) -> tokens -> parser.y (Bison) -> TAC
