%{
#include "uasm.tab.h"
%}

%%


"%"[_a-zA-Z0-9]+        { yylval.text = strdup(yytext); return SIG_VAL; }
"@"[_a-zA-Z0-9]+        { yylval.text = strdup(yytext); return SIG_LABEL; }
[_A-Z][_A-Z0-9]*        { return SIG_LINE; }
":"                     { return COLON; }
";"                     { return SEMI_COLON; }
","                     { return COMMA; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"["						{ return LSQRBRK; }
"]"						{ return RSQRBRK; }
"~"                     { return TILDE; }
"branch"				{ return BRANCH; }

[1-9][0-9]+             { return NUMBER_DEC; }
[0][xX][0-9a-fA-F]+     { return NUMBER_HEX; }

[ \t\n]                 {}
"//".*                  {}

.                       { printf("invalid character: %s\n", yytext); }

%%

