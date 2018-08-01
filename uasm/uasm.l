%{
#include "uasm.tab.h"
%}

%%


"%"[_a-zA-Z0-9]+        { yylval.text = strdup(yytext); return SIG_VAL; }
"@"[_a-zA-Z0-9]+        { yylval.text = strdup(yytext); return SIG_ADDR; }
[_A-Z]+                 { return SIG_LINE; }
":"                     { return COLON; }
";"                     { return SEMI_COLON; }
","                     { return COMMA; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"~"                     { return TILDE; }

[ \t\n]                 {}
"//".*                  {}

.                       { printf("invalid character: %s\n", yytext); }

%%

