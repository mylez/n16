%{
#include <iostream>
#include "uasm.tab.h"
%}

%%

[_a-zA-Z][_a-zA-Z0-9]*                  { return IDENTIFIER; }
[0][xX][0-9a-fA-F]+                     { return NUMBER_HEX; }
[1-9][0-9]*                             { std::cout << "numdec\n";return NUMBER_DEC; }

"%"     |
"%"     |
":"     |
";"     |
","     |
"("     |
")"     |
"["     |
"]"                                     { return *yytext; }

[ \t\n]*                                {}


.                                       { printf("invalid character: %s\n", yytext); }

%%

