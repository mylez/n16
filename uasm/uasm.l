%{
#include <iostream>
#include "uasm.tab.h"
%}

%%

[_a-zA-Z][_a-zA-Z0-9]*                  { yylval.text = strdup(yytext); return IDENTIFIER; }
[0][xX][0-9a-fA-F]+                     { yylval.text = strdup(yytext); return NUMBER_HEX; }
[1-9][0-9]*                             { yylval.text = strdup(yytext); return NUMBER_DEC;}

"@"[_a-zA-Z0-9]*                        { yylval.text = strdup(yytext); return LABEL_IDENTIFIER; }
"%"[_a-zA-Z0-9]*                        { yylval.text = strdup(yytext); return VALUE_IDENTIFIER; }


":"     |
";"     |
","     |
"("     |
")"     |
"<"     |
">"                                     { return *yytext; }

[ \t\n]*                                {}

.                                       { printf("invalid character: %s\n", yytext); }

%%

